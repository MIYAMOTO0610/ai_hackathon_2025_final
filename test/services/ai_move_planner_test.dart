import 'package:ai_hackathon_2025_final/common/constants.dart';
import 'package:ai_hackathon_2025_final/services/ai_move_planner.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AiMovePlanner', () {
    test('suggests opening move with >8 strokes requirement', () {
      final planner = AiMovePlanner();
      final cells = List<KanjiGridCell?>.filled(kRow * kColumn, null);

      final plan = planner.buildNextMove(cells);

      expect(plan.targetIndex, 0);
      expect(plan.strokeRule.type, StrokeRuleType.moreThanEight);
      expect(plan.prompt, contains('8画を超える'));
    });

    test('switches to column exact rule after the 7th filled cell', () {
      final planner = AiMovePlanner();
      final cells = <KanjiGridCell?>[
        const KanjiGridCell(kanji: '漢', strokeCount: 12),
        const KanjiGridCell(kanji: '字', strokeCount: 6),
        null,
        const KanjiGridCell(kanji: '書', strokeCount: 10),
        const KanjiGridCell(kanji: '道', strokeCount: 12),
        const KanjiGridCell(kanji: '永', strokeCount: 4),
        const KanjiGridCell(kanji: '雨', strokeCount: 8),
        const KanjiGridCell(kanji: '風', strokeCount: 9),
        null,
      ];

      final plan = planner.buildNextMove(cells);

      expect(plan.strokeRule.type, StrokeRuleType.columnExactTotal);
      expect(plan.targetIndex, 2);
      expect(plan.strokeRule.requiredStrokeCount, 5);
      expect(plan.prompt, contains('5画の漢字'));
    });
  });
}
