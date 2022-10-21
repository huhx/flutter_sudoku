import 'package:flutter/material.dart';
import 'package:flutter_sudoku/business/sudoku/sudoku_notifier.dart';
import 'package:flutter_sudoku/model/sudoku_point.dart';

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
            return TableCell(child: SudokuCell(row, column, sudokuNotifier));
          }),
        ),
      ),
    );
  }
}

class SudokuCell extends StatelessWidget {
  final int row;
  final int column;
  final SudokuNotifier sudokuNotifier;

  const SudokuCell(this.row, this.column, this.sudokuNotifier, {super.key});

  @override
  Widget build(BuildContext context) {
    final SudokuPoint sudokuPoint = SudokuPoint(x: row, y: column);
    final List<int>? noteValue = sudokuNotifier.noteValue(row, column);
    final int number = sudokuNotifier.content[row][column];

    return InkWell(
      onTap: () => sudokuNotifier.onTapped(row, column),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(border: sudokuPoint.border, color: sudokuNotifier.getColor(row, column)),
          alignment: Alignment.center,
          child: sudokuNotifier.enableNotes && noteValue != null && noteValue.isNotEmpty
              ? Text("$noteValue", style: const TextStyle(fontSize: 8), textAlign: TextAlign.start)
              : Text(
                  number == 0 ? "" : number.toString(),
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: sudokuNotifier.getTextColor(row, column)),
                ),
        ),
      ),
    );
  }
}
