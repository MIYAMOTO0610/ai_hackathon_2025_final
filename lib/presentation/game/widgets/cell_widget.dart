import 'package:ai_hackathon_2025_final/common/constants.dart';
import 'package:ai_hackathon_2025_final/domain/cell.dart';
import 'package:flutter/material.dart' hide Canvas;

class CellWidget extends StatelessWidget {
  const CellWidget({
    super.key,
    required this.cell,
    required this.onTap,
    this.isWinning = false,
    this.textColor = const Color(0xFFA86300),
  });

  final Cell cell;
  final VoidCallback onTap;
  final bool isWinning;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final bgColor = isWinning ? Color(0xFFFFD0A8) : kCellColor;

    return GestureDetector(
      onTap: () => onTap(),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          width: 100,
          height: 100,
          child: cell.kanji != null
              ? Text(
                  cell.kanji!,
                  style: TextStyle(
                    fontFamily: 'Kanata-Tegaki',
                    fontSize: 64,
                    color: textColor,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
