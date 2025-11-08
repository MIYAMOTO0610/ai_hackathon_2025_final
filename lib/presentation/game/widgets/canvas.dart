import 'dart:ui' as ui;

import 'package:ai_hackathon_2025_final/common/constants.dart';
import 'package:ai_hackathon_2025_final/domain/cell.dart';
import 'package:ai_hackathon_2025_final/services/kanji_ocr_service.dart';
import 'package:ai_hackathon_2025_final/services/kanji_stroke_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Canvas extends StatefulWidget {
  const Canvas({super.key, required this.onCanvasExported});

  final void Function(Cell) onCanvasExported;

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

  void _cancel() {
    setState(() {
      _points.clear();
    });
    if (context.mounted) Navigator.of(context).pop();
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

      // TODO: 消す
      widget.onCanvasExported(
        Cell(image: pngBytes, kanji: 'test', strokeCount: 3),
      );
      Navigator.of(context).pop();
      return;

      String kanji = '';
      int strokeCount = 0;
      try {
        kanji = await KanjiOcrService().recognizeKanji(pngBytes);
      } catch (e) {
        debugPrint('kanji ocr error: $e');
        Navigator.of(context).pop();
        return;
      }

      try {
        strokeCount = await KanjiStrokeService().fetchStrokeCount(kanji);
      } catch (e) {
        debugPrint('kanji stroke count error: $e');
        Navigator.of(context).pop();
        return;
      }

      widget.onCanvasExported(
        Cell(image: pngBytes, kanji: kanji, strokeCount: strokeCount),
      );

      if (context.mounted) Navigator.of(context).pop();
    } catch (e, s) {
      debugPrint('export error: $e\n$s');
      if (context.mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/canvas_1.png', width: 299),
              const SizedBox(height: 64),
              RepaintBoundary(
                key: _repaintKey,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    color: kCellColor,
                    border: Border.all(color: Color(0xFFDF9427), width: 4),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: GestureDetector(
                    onPanStart: _onPanStart,
                    onPanUpdate: _onPanUpdate,
                    onPanEnd: _onPanEnd,
                    child: CustomPaint(painter: _KanjiPainter(points: _points)),
                  ),
                ),
              ),
              const SizedBox(height: 64),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _cancel,
                    child: Image.asset(
                      'assets/images/canvas_cancel.png',
                      width: 144,
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: _exportAsImage,
                    child: Image.asset(
                      'assets/images/canvas_ok.png',
                      width: 184,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
