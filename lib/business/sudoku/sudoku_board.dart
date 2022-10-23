import 'package:flutter/material.dart';
import 'package:flutter_sudoku/business/sudoku/sudoku_notifier.dart';
import 'package:flutter_sudoku/model/sudoku_point.dart';

class SudokuBoard extends StatelessWidget {
  final SudokuNotifier sudokuNotifier;

  const SudokuBoard(this.sudokuNotifier, {super.key});

  @override
  Widget build(BuildContext context) {
    return Table(
      children: List.generate(
        9,
        (row) => TableRow(
          children: List.generate(9, (column) {
            return TableCell(child: SudokuCell(Point.from(row, column), sudokuNotifier));
          }),
        ),
      ),
    );
  }
}

class SudokuCell extends StatelessWidget {
  final Point point;
  final SudokuNotifier sudokuNotifier;

  const SudokuCell(this.point, this.sudokuNotifier, {super.key});

  @override
  Widget build(BuildContext context) {
    final List<int>? noteValue = sudokuNotifier.noteValue(point);
    final int number = sudokuNotifier.getValue(point);

    return InkWell(
      onTap: () => sudokuNotifier.onTapped(point),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(border: point.border, color: sudokuNotifier.getColor(point)),
          alignment: Alignment.center,
          child: noteValue != null && noteValue.isNotEmpty
              ? SudokuNoteCell(noteValue)
              : SudokuNormalCell(number, sudokuNotifier.getTextColor(point)),
        ),
      ),
    );
  }
}

class SudokuNoteCell extends StatelessWidget {
  final List<int> values;

  const SudokuNoteCell(this.values, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "$values",
      style: const TextStyle(fontSize: 8),
      textAlign: TextAlign.start,
    );
  }
}

class SudokuNormalCell extends StatelessWidget {
  final int value;
  final Color? color;

  const SudokuNormalCell(this.value, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      value == 0 ? "" : value.toString(),
      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: color),
    );
  }
}
