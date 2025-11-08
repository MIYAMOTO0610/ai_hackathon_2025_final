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
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          width: 100,
          height: 100,
          child: image != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(image!, fit: BoxFit.cover),
                )
              : null,
        ),
      ),
    );
  }
}
