import 'package:flutter/material.dart';
import 'package:flutter_sudoku/business/sudoku/sudoku_notifier.dart';
import 'package:flutter_sudoku/model/sudoku.dart';

class SudokuBoard extends StatelessWidget {
  final SudokuNotifier sudokuNotifier;

  const SudokuBoard(this.sudokuNotifier, {Key? key}) : super(key: key);

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
    final int number = sudokuNotifier.valueFromPoint(point);

    return InkWell(
      onTap: () => sudokuNotifier.onTapped(point),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(border: sudokuNotifier.getBorder(point), color: sudokuNotifier.getColor(point)),
          alignment: Alignment.center,
          child: sudokuNotifier.enableNotes && noteValue != null && noteValue.isNotEmpty
              ? Text("$noteValue", style: const TextStyle(fontSize: 8), textAlign: TextAlign.start)
              : Text(
                  number == 0 ? "" : number.toString(),
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: sudokuNotifier.getTextColor(point)),
                ),
        ),
      ),
    );
  }
}
