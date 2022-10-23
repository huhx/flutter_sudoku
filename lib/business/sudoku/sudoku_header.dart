import 'package:flutter/material.dart';
import 'package:flutter_sudoku/business/sudoku/sudoku_notifier.dart';

import 'sudoku_counter.dart';

class SudokuHeader extends StatelessWidget {
  final SudokuNotifier sudokuNotifier;

  const SudokuHeader(this.sudokuNotifier, {super.key});

  @override
  Widget build(BuildContext context) {
    final Color? color = sudokuNotifier.retryCount == 0 ? null : Colors.red;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(sudokuNotifier.difficulty.label),
          const SudokuCounter(initSeconds: 0),
          Text(sudokuNotifier.retryString, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}
