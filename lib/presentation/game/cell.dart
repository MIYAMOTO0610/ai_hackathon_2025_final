import 'package:flutter/material.dart';

class Cell extends StatelessWidget {
  const Cell({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black),
      ),
      width: 100,
      height: 100,
    );
  }
}
