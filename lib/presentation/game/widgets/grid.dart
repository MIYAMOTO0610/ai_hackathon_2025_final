import 'package:ai_hackathon_2025_final/common/constants.dart';
import 'package:ai_hackathon_2025_final/domain/cell.dart';
import 'package:ai_hackathon_2025_final/presentation/game/widgets/canvas.dart';
import 'package:ai_hackathon_2025_final/presentation/game/widgets/cell_widget.dart';
import 'package:flutter/material.dart' hide Canvas;

class Grid extends StatefulWidget {
  const Grid({super.key});

  @override
  State<Grid> createState() => _GridState();
}

class _GridState extends State<Grid> {
  final _cells = List<Cell>.filled(kRow * kColumn, Cell());
  int? _currentIndex;
  List<int> _winningIndices = [];

  void _onCellTap(int index) async {
    setState(() {
      _currentIndex = index;
    });

    await showDialog(
      context: context,
      builder: (context) => Canvas(onCanvasExported: _onCanvasExported),
    );

    _winningIndices = _checkWin(_currentIndex!);

    print('winningIndices: $_winningIndices');
    if (_winningIndices.isEmpty) return;
    // TODO: 揃ったラインのマス目の色を変更する
    print('WIN');
    setState(() {});
  }

  void _onCanvasExported(Cell cell) {
    if (_currentIndex == null) return;
    setState(() {
      _cells[_currentIndex!] = cell;
    });
  }

  // 判定ロジック
  // 揃ったときindexのリスト, 揃っていないときから配列を返す
  List<int> _checkWin(int lastIndex) {
    final row = lastIndex ~/ kColumn;
    final col = lastIndex % kColumn;

    // 行
    final rowIndices = List<int>.generate(kColumn, (i) => row * kColumn + i);
    final sumRow = rowIndices.fold(
      0,
      (sum, idx) => sum + (_cells[idx].strokeCount ?? 0),
    );
    if (sumRow == 9) return rowIndices;

    // 列
    final colIndices = List<int>.generate(kRow, (i) => i * kColumn + col);
    final sumCol = colIndices.fold(
      0,
      (sum, idx) => sum + (_cells[idx].strokeCount ?? 0),
    );
    if (sumCol == 9) return colIndices;

    // 左上→右下 の対角線
    if (row == col) {
      final mainDiagIndices = List<int>.generate(kRow, (i) => i * kColumn + i);
      final sumMainDiag = mainDiagIndices.fold(
        0,
        (sum, idx) => sum + (_cells[idx].strokeCount ?? 0),
      );
      if (sumMainDiag == 9) return mainDiagIndices;
    }

    // 右上→左下 の対角線
    if (row + col == kRow - 1) {
      final subDiagIndices = List<int>.generate(
        kRow,
        (i) => i * kColumn + (kColumn - 1 - i),
      );
      final sumSubDiag = subDiagIndices.fold(
        0,
        (sum, idx) => sum + (_cells[idx].strokeCount ?? 0),
      );
      if (sumSubDiag == 9) return subDiagIndices;
    }

    return [];
  }

  // TODO: ゲーム終了時に全部
  void _onGameEnd() {
    setState(() {
      for (var i = 0; i < _cells.length; i++) {
        _cells[i] = Cell();
      }
      _currentIndex = null;
      _winningIndices.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFFFFD86D),
          border: Border.all(
            color: Color(0xFFDF9427),
            width: 4,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Color(0xFFDF9427),
            border: Border.all(
              color: Color(0xFFDF9427),
              width: 4,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: GridView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: kRow * kColumn,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: kColumn,
            ),
            itemBuilder: (context, index) => CellWidget(
              cell: _cells[index],
              onTap: () => _onCellTap(index),
              isWinning: _winningIndices.contains(index),
            ),
          ),
        ),
      ),
    );
  }
}
