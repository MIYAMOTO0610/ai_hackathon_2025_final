import 'dart:typed_data';

import 'package:ai_hackathon_2025_final/common/constants.dart';
import 'package:ai_hackathon_2025_final/presentation/game/widgets/canvas.dart';
import 'package:ai_hackathon_2025_final/presentation/game/widgets/cell.dart';
import 'package:flutter/material.dart' hide Canvas;

class Grid extends StatefulWidget {
  const Grid({super.key});

  @override
  State<Grid> createState() => _GridState();
}

class _GridState extends State<Grid> {
  final _images = List<Uint8List?>.filled(kRow * kColumn, null);

  int? _currentIndex;

  void _onCellTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    showDialog(
      context: context,
      builder: (context) => Canvas(onCanvasExported: _onCanvasExported),
    );
  }

  void _onCanvasExported(Uint8List bytes) {
    if (_currentIndex == null) return;
    setState(() {
      _images[_currentIndex!] = bytes;
    });
  }

  // TODO: ゲーム終了時に全部
  void _onGameEnd() {
    setState(() {
      for (var i = 0; i < _images.length; i++) {
        _images[i] = null;
      }
      _currentIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
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
              width: 2,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: kRow * kColumn,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: kColumn,
            ),
            itemBuilder: (context, index) =>
                Cell(image: _images[index], onTap: () => _onCellTap(index)),
          ),
        ),
      ),
    );
  }
}
