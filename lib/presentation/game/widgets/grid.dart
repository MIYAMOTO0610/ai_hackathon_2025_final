import 'package:ai_hackathon_2025_final/common/constants.dart';
import 'package:ai_hackathon_2025_final/domain/cell.dart';
import 'package:ai_hackathon_2025_final/presentation/game/widgets/canvas.dart';
import 'package:ai_hackathon_2025_final/presentation/game/widgets/cell_widget.dart';
import 'package:flutter/material.dart' hide Canvas;

class Grid extends StatefulWidget {
  const Grid({
    super.key,
    required this.cells,
    required this.winningIndices,
    required this.onCellTap,
  });

  final List<Cell> cells;
  final List<int> winningIndices;
  final void Function(int) onCellTap;

  @override
  State<Grid> createState() => _GridState();
}

class _GridState extends State<Grid> {
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
              cell: widget.cells[index],
              onTap: () => widget.onCellTap(index),
              isWinning: widget.winningIndices.contains(index),
            ),
          ),
        ),
      ),
    );
  }
}
