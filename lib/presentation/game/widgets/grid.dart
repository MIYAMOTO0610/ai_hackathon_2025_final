import 'dart:typed_data';

import 'package:ai_hackathon_2025_final/common/constants.dart';
import 'package:ai_hackathon_2025_final/domain/cell.dart';
import 'package:ai_hackathon_2025_final/presentation/game/widgets/canvas.dart';
import 'package:ai_hackathon_2025_final/presentation/game/widgets/cell_widget.dart';
import 'package:flutter/material.dart' hide Canvas;

class Grid extends StatefulWidget {
  const Grid({super.key});

  @override
  State<Grid> createState() => _GridState();
}

class _GridState extends State<Grid> {
  final _cells = List<Cell>.filled(kRow * kColumn, Cell());

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
      _cells[_currentIndex!] = Cell(image: bytes);
    });
  }

  // TODO: ゲーム終了時に全部
  void _onGameEnd() {
    setState(() {
      for (var i = 0; i < _cells.length; i++) {
        _cells[i] = Cell();
      }
      _currentIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
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
              width: 4,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: GridView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: kRow * kColumn,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: kColumn,
            ),
            itemBuilder: (context, index) =>
                CellWidget(cell: _cells[index], onTap: () => _onCellTap(index)),
          ),
        ),
      ),
    );
  }
}
