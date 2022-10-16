import 'package:flutter/material.dart';
import 'package:flutter_sudoku/business/sudoku/sudoku_notifier.dart';
import 'package:flutter_sudoku/component/svg_icon.dart';
import 'package:flutter_sudoku/util/comm_util.dart';

class SudokuHeader extends StatelessWidget {
  final SudokuNotifier sudokuNotifier;

  const SudokuHeader(this.sudokuNotifier, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color? color = sudokuNotifier.retryCount == 0 ? null : Colors.red;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(sudokuNotifier.difficulty.label),
        Text(sudokuNotifier.retryString, style: TextStyle(color: color)),
        Row(
          children: [
            IconButton(
              onPressed: () => CommUtil.toBeDev(),
              icon: const SvgIcon(name: "sudoku_stop"),
            ),
            Text(sudokuNotifier.durationString),
          ],
        )
      ],
    );
  }
}
