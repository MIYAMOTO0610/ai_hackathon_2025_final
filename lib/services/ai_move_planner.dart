import 'package:ai_hackathon_2025_final/common/constants.dart';

/// Represents a kanji that has already been placed on the grid.
class KanjiGridCell {
  const KanjiGridCell({required this.kanji, required this.strokeCount});

  final String kanji;
  final int strokeCount;

  Map<String, Object> toJson() => {'kanji': kanji, 'strokeCount': strokeCount};
}

/// Rule applied to the next move.
class StrokeRule {
  const StrokeRule.moreThanEight({required this.minStrokeCount})
    : type = StrokeRuleType.moreThanEight,
      targetColumn = null,
      targetColumnTotal = null,
      requiredStrokeCount = null;

  const StrokeRule.columnExactTotal({
    required this.targetColumn,
    required this.targetColumnTotal,
    required this.requiredStrokeCount,
  }) : type = StrokeRuleType.columnExactTotal,
       minStrokeCount = null;

  final StrokeRuleType type;
  final int? minStrokeCount;
  final int? targetColumn;
  final int? targetColumnTotal;
  final int? requiredStrokeCount;
}

enum StrokeRuleType { moreThanEight, columnExactTotal }

/// Next move suggestion for the AI opponent.
class AiMovePlan {
  AiMovePlan({
    required this.targetIndex,
    required this.row,
    required this.column,
    required this.strokeRule,
    required List<List<KanjiGridCell?>> boardSnapshot,
    required this.prompt,
    required this.filledCount,
  }) : boardSnapshot = List<List<KanjiGridCell?>>.unmodifiable(
         boardSnapshot
             .map((row) => List<KanjiGridCell?>.unmodifiable(row))
             .toList(growable: false),
       );

  final int targetIndex;
  final int row;
  final int column;
  final StrokeRule strokeRule;
  final List<List<KanjiGridCell?>> boardSnapshot;
  final String prompt;
  final int filledCount;

  /// Serializable representation of the current board.
  List<List<Map<String, Object>?>> get boardAsJson => boardSnapshot
      .map((row) => row.map((cell) => cell?.toJson()).toList(growable: false))
      .toList(growable: false);
}

/// Builds the instructions/prompt for the AI based on the current grid state.
class AiMovePlanner {
  AiMovePlanner({
    this.openingThreshold = 7,
    this.minOpeningStroke = 9,
    this.columnStrokeTarget = 9,
  });

  final int openingThreshold;
  final int minOpeningStroke;
  final int columnStrokeTarget;

  AiMovePlan buildNextMove(List<KanjiGridCell?> cells) {
    if (cells.length != kRow * kColumn) {
      throw ArgumentError.value(
        cells.length,
        'cells.length',
        'Grid must contain exactly ${kRow * kColumn} entries.',
      );
    }

    final normalized = List<KanjiGridCell?>.from(cells, growable: false);
    final filledCount = normalized.whereType<KanjiGridCell>().length;
    final emptyIndices = <int>[
      for (var i = 0; i < normalized.length; i++)
        if (normalized[i] == null) i,
    ];

    if (emptyIndices.isEmpty) {
      throw StateError('All cells are already filled.');
    }

    late final int targetIndex;
    late final StrokeRule strokeRule;

    if (filledCount < openingThreshold) {
      targetIndex = emptyIndices.first;
      strokeRule = StrokeRule.moreThanEight(minStrokeCount: minOpeningStroke);
    } else {
      final candidate = _pickColumnCandidate(normalized, emptyIndices);
      targetIndex = candidate.index;
      strokeRule = StrokeRule.columnExactTotal(
        targetColumn: candidate.column,
        targetColumnTotal: columnStrokeTarget,
        requiredStrokeCount: candidate.requiredStrokeCount,
      );
    }

    final row = targetIndex ~/ kColumn;
    final column = targetIndex % kColumn;
    final boardSnapshot = _buildBoardSnapshot(normalized);
    final prompt = _buildPrompt(
      boardSnapshot: boardSnapshot,
      row: row,
      column: column,
      strokeRule: strokeRule,
      filledCount: filledCount,
    );

    return AiMovePlan(
      targetIndex: targetIndex,
      row: row,
      column: column,
      strokeRule: strokeRule,
      boardSnapshot: boardSnapshot,
      prompt: prompt,
      filledCount: filledCount,
    );
  }

  _ColumnCandidate _pickColumnCandidate(
    List<KanjiGridCell?> cells,
    List<int> emptyIndices,
  ) {
    _ColumnCandidate? best;

    for (final index in emptyIndices) {
      final column = index % kColumn;
      final sum = _columnStrokeSum(cells, column);
      final remaining = columnStrokeTarget - sum;
      if (remaining <= 0) {
        continue;
      }

      best = _ColumnCandidate(
        index: index,
        column: column,
        requiredStrokeCount: remaining,
      );
      break;
    }

    if (best == null) {
      throw StateError('No column can reach $columnStrokeTarget strokes.');
    }

    return best;
  }

  int _columnStrokeSum(List<KanjiGridCell?> cells, int column) {
    var sum = 0;
    for (var row = 0; row < kRow; row++) {
      final cell = cells[row * kColumn + column];
      if (cell != null) {
        sum += cell.strokeCount;
      }
    }
    return sum;
  }

  List<List<KanjiGridCell?>> _buildBoardSnapshot(List<KanjiGridCell?> cells) {
    return List<List<KanjiGridCell?>>.generate(
      kRow,
      (row) => List<KanjiGridCell?>.generate(
        kColumn,
        (col) => cells[row * kColumn + col],
        growable: false,
      ),
      growable: false,
    );
  }

  String _buildPrompt({
    required List<List<KanjiGridCell?>> boardSnapshot,
    required int row,
    required int column,
    required StrokeRule strokeRule,
    required int filledCount,
  }) {
    final buffer = StringBuffer()
      ..writeln('あなたは3x3漢字バトルのAIプレイヤーです。')
      ..writeln('現在の盤面（行×列）:');

    for (var r = 0; r < kRow; r++) {
      final cells = boardSnapshot[r]
          .map(
            (cell) =>
                cell == null ? '空欄' : '${cell.kanji}(${cell.strokeCount}画)',
          )
          .join(' | ');
      buffer.writeln('行${r + 1}: $cells');
    }

    buffer
      ..writeln()
      ..writeln('ルール:')
      ..writeln('・7マス目までは8画を超える漢字を置く')
      ..writeln('・8マス目以降は、選んだ列の合計画数が9ぴったりになるように調整する')
      ..writeln()
      ..writeln('現在の埋まり状況: ${filledCount}マス / ${kRow * kColumn}マス')
      ..writeln('今回埋めるマス: 行${row + 1}・列${column + 1}');

    switch (strokeRule.type) {
      case StrokeRuleType.moreThanEight:
        buffer.writeln(
          '条件: 8画を超える（${strokeRule.minStrokeCount}画以上）の漢字を1文字だけ選んでください。',
        );
      case StrokeRuleType.columnExactTotal:
        buffer.writeln(
          '条件: 列${(strokeRule.targetColumn ?? 0) + 1}の合計画数が'
          '${strokeRule.targetColumnTotal}になるように、'
          '${strokeRule.requiredStrokeCount}画の漢字を1文字選んでください。',
        );
    }

    buffer.writeln('出力は条件を満たす漢字1文字のみとします。');

    return buffer.toString();
  }
}

class _ColumnCandidate {
  _ColumnCandidate({
    required this.index,
    required this.column,
    required this.requiredStrokeCount,
  });

  final int index;
  final int column;
  final int requiredStrokeCount;
}
