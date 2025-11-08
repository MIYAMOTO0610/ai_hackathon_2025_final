import 'package:ai_hackathon_2025_final/presentation/game/widgets/canvas.dart';
import 'package:flutter/material.dart' hide Canvas;

class Cell extends StatelessWidget {
  const Cell({super.key});

  void onTap(BuildContext context) {
    // 手書き入力画面
    showDialog(context: context, builder: (context) => Canvas());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black),
        ),
        width: 100,
        height: 100,
      ),
    );
  }
}
