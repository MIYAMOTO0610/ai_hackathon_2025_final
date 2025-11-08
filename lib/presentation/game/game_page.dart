import 'package:ai_hackathon_2025_final/presentation/game/widgets/grid.dart';
import 'package:flutter/material.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(body: Center(child: Grid())),
    );
  }
}
