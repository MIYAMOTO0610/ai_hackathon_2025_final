import 'package:ai_hackathon_2025_final/common/constants.dart';
import 'package:ai_hackathon_2025_final/presentation/game/cell.dart';
import 'package:flutter/material.dart';

class Grid extends StatelessWidget {
  const Grid({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < kRow; i++)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [for (int j = 0; j < kColumn; j++) Cell()],
            ),
        ],
      ),
    );
  }
}
