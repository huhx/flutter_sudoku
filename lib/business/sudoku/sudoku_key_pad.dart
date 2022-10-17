import 'package:flutter/material.dart';
import 'package:flutter_sudoku/business/sudoku/sudoku_notifier.dart';

class SudokuKeyPad extends StatelessWidget {
  final SudokuNotifier sudokuNotifier;

  const SudokuKeyPad(this.sudokuNotifier, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 9,
      crossAxisSpacing: 4,
      children: List.generate(
        9,
        (index) => NumberItem(index + 1, (int num) => sudokuNotifier.onInput(num)),
      ),
    );
  }
}

class NumberItem extends StatelessWidget {
  final int number;
  final Function(int) onPressed;

  const NumberItem(this.number, this.onPressed, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPressed(number),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            border: Border.all(width: 1, color: Colors.grey),
          ),
          alignment: Alignment.center,
          child: Text(
            number.toString(),
            style: const TextStyle(fontSize: 24, color: Colors.green),
          ),
        ),
      ),
    );
  }
}
