import 'package:ai_hackathon_2025_final/common/constants.dart';
import 'package:ai_hackathon_2025_final/domain/cell.dart';
import 'package:ai_hackathon_2025_final/presentation/game/widgets/canvas.dart';
import 'package:ai_hackathon_2025_final/presentation/game/widgets/grid.dart';
import 'package:flutter/material.dart' hide Canvas;

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final _cells = List<Cell>.filled(kRow * kColumn, Cell());
  int? _currentIndex;
  List<int> _winningIndices = [];

  bool get _isWinning => _winningIndices.isNotEmpty;

  void _onCellTap(int index) async {
    setState(() {
      _currentIndex = index;
    });

    await showDialog(
      context: context,
      builder: (context) => Canvas(onCanvasExported: _onCanvasExported),
    );

    _winningIndices = _checkWin(_currentIndex!);

    if (_winningIndices.isEmpty) return;
    setState(() {});
  }

  void _onCanvasExported(Cell cell) {
    if (_currentIndex == null) return;
    setState(() {
      _cells[_currentIndex!] = cell;
    });
  }

  // 判定ロジック
  // 揃ったときindexのリスト, 揃っていないときから配列を返す
  List<int> _checkWin(int lastIndex) {
    final row = lastIndex ~/ kColumn;
    final col = lastIndex % kColumn;

    // 行
    final rowIndices = List<int>.generate(kColumn, (i) => row * kColumn + i);
    final sumRow = rowIndices.fold(
      0,
      (sum, idx) => sum + (_cells[idx].strokeCount ?? 0),
    );
    if (sumRow == 9) return rowIndices;

    // 列
    final colIndices = List<int>.generate(kRow, (i) => i * kColumn + col);
    final sumCol = colIndices.fold(
      0,
      (sum, idx) => sum + (_cells[idx].strokeCount ?? 0),
    );
    if (sumCol == 9) return colIndices;

    // 左上→右下 の対角線
    if (row == col) {
      final mainDiagIndices = List<int>.generate(kRow, (i) => i * kColumn + i);
      final sumMainDiag = mainDiagIndices.fold(
        0,
        (sum, idx) => sum + (_cells[idx].strokeCount ?? 0),
      );
      if (sumMainDiag == 9) return mainDiagIndices;
    }

    // 右上→左下 の対角線
    if (row + col == kRow - 1) {
      final subDiagIndices = List<int>.generate(
        kRow,
        (i) => i * kColumn + (kColumn - 1 - i),
      );
      final sumSubDiag = subDiagIndices.fold(
        0,
        (sum, idx) => sum + (_cells[idx].strokeCount ?? 0),
      );
      if (sumSubDiag == 9) return subDiagIndices;
    }

    return [];
  }

  // TODO: ゲーム終了時に全部
  void _onGameEnd() {
    setState(() {
      for (var i = 0; i < _cells.length; i++) {
        _cells[i] = Cell();
      }
      _currentIndex = null;
      _winningIndices.clear();
    });
  }

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
                    Image.asset(
                      _isWinning
                          ? 'assets/images/game_page_win.png'
                          : 'assets/images/game_page_1.png',
                      width: 299,
                    ),
                    Grid(
                      cells: _cells,
                      winningIndices: _winningIndices,
                      onCellTap: _onCellTap,
                    ),
                  ],
                ),
              ),
            ),
            if (_isWinning)
              GestureDetector(
                onTap: _onGameEnd,
                child: Image.asset(
                  'assets/images/game_page_retry.png',
                  width: double.infinity,
                ),
              )
            else
              Stack(
                children: [
                  Image.asset(
                    'assets/images/game_page_bottom.png',
                    width: double.infinity,
                  ),
                  Positioned(
                    top: 40,
                    left: 32,
                    child: Image.asset('assets/images/kaeru.gif', width: 80),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
