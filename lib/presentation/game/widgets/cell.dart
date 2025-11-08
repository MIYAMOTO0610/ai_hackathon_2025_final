import 'dart:typed_data';

import 'package:flutter/material.dart' hide Canvas;

class Cell extends StatelessWidget {
  const Cell({super.key, this.image, required this.onTap});

  final Uint8List? image;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black),
        ),
        width: 100,
        height: 100,
        child: image != null ? Image.memory(image!) : null,
      ),
    );
  }
}
