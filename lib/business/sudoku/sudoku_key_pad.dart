import 'package:flutter/material.dart';
import 'package:flutter_sudoku/business/home/sudoku_failed_screen.dart';
import 'package:flutter_sudoku/business/home/sudoku_success_screen.dart';
import 'package:flutter_sudoku/business/sudoku/sudoku_notifier.dart';
import 'package:flutter_sudoku/common/context_extension.dart';
import 'package:flutter_sudoku/model/sudoku.dart';

class SudokuKeyPad extends StatelessWidget {
  final SudokuNotifier sudokuNotifier;

  const SudokuKeyPad(this.sudokuNotifier, {super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 9,
      crossAxisSpacing: 10,
      children: List.generate(
        9,
        (index) => NumberItem(sudokuNotifier.isEnable(index + 1), index + 1, (int num) {
          final GameStatus gameStatus = sudokuNotifier.onInput(num);
          if (gameStatus == GameStatus.success) {
            context.goto(SudokuSuccessScreen(sudokuNotifier));
          } else if (gameStatus == GameStatus.failed) {
            context.goto(SudokuFailedScreen(sudokuNotifier));
          }
        }),
      ),
    );
  }
}

class NumberItem extends StatelessWidget {
  final bool isEnable;
  final int number;
  final Function(int) onPressed;

  const NumberItem(this.isEnable, this.number, this.onPressed, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isEnable ? () => onPressed(number) : null,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: Text(
            number.toString(),
            style: TextStyle(fontSize: 24, color: isEnable ? Colors.green : Colors.grey),
          ),
        ),
      ),
    );
  }
}
