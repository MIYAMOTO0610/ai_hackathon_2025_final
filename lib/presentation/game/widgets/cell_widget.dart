import 'package:ai_hackathon_2025_final/common/constants.dart';
import 'package:ai_hackathon_2025_final/domain/cell.dart';
import 'package:flutter/material.dart' hide Canvas;

class CellWidget extends StatelessWidget {
  const CellWidget({super.key, required this.cell, required this.onTap});

  final Cell cell;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          decoration: BoxDecoration(
            color: kCellColor,
            borderRadius: BorderRadius.circular(8),
          ),
          width: 100,
          height: 100,
          child: cell.image != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(cell.image!, fit: BoxFit.cover),
                )
              : null,
        ),
      ),
    );
  }
}
