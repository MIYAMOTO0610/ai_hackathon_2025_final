import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Canvas extends StatefulWidget {
  const Canvas({super.key, required this.onCanvasExported});

  final void Function(Uint8List) onCanvasExported;

  @override
  State<Canvas> createState() => _CanvasState();
}

class _CanvasState extends State<Canvas> {
  final GlobalKey _repaintKey = GlobalKey();
  final List<Offset?> _points = [];

  void _onPanStart(DragStartDetails details) {
    final box = _repaintKey.currentContext!.findRenderObject() as RenderBox;
    final localPosition = box.globalToLocal(details.globalPosition);
    setState(() {
      _points.add(localPosition);
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final box = _repaintKey.currentContext!.findRenderObject() as RenderBox;
    final localPosition = box.globalToLocal(details.globalPosition);
    setState(() {
      _points.add(localPosition);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    // 線の区切りとして null を入れておく
    setState(() {
      _points.add(null);
    });
  }

  void _clear() {
    setState(() {
      _points.clear();
    });
  }

  Future<void> _exportAsImage() async {
    try {
      final boundary =
          _repaintKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;

      // pixelRatio は解像度。必要に応じて上げる（3〜4 くらい）
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) return;

      final pngBytes = byteData.buffer.asUint8List();

      widget.onCanvasExported(pngBytes);

      if (context.mounted) Navigator.of(context).pop();
    } catch (e, s) {
      debugPrint('export error: $e\n$s');
      if (context.mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        // 手書きキャンバス
        Center(
          child: RepaintBoundary(
            key: _repaintKey,
            child: Container(
              width: 300,
              height: 300,
              color: Colors.white,
              child: GestureDetector(
                onPanStart: _onPanStart,
                onPanUpdate: _onPanUpdate,
                onPanEnd: _onPanEnd,
                child: CustomPaint(painter: _KanjiPainter(points: _points)),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(onPressed: _clear, child: const Text('クリア')),
            const SizedBox(width: 16),
            FilledButton(onPressed: _exportAsImage, child: const Text('画像にする')),
          ],
        ),
      ],
    );
  }
}

class _KanjiPainter extends CustomPainter {
  _KanjiPainter({required this.points});

  final List<ui.Offset?> points; // ← ui.Offset に変更

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    // ← ui.Canvas と ui.Size
    final paint = ui.Paint()
      ..color = Colors.black
      ..strokeWidth = 6.0
      ..strokeCap = ui.StrokeCap.round
      ..style = ui.PaintingStyle.stroke;

    for (int i = 0; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];
      if (p1 != null && p2 != null) {
        canvas.drawLine(p1, p2, paint); // ← ここはOK
      }
    }
  }

  @override
  bool shouldRepaint(covariant _KanjiPainter oldDelegate) {
    return true;
  }
}
