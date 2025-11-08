import 'package:ai_hackathon_2025_final/presentation/game/widgets/grid.dart';
import 'package:flutter/material.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 64, 32, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/game_page_1.png', width: 299),
                    Grid(),
                  ],
                ),
              ),
            ),
            Image.asset(
              'assets/images/game_page_2.png',
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
