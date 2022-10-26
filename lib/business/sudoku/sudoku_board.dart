import 'package:flutter/material.dart';
import 'package:flutter_sudoku/business/sudoku/sudoku_notifier.dart';
import 'package:flutter_sudoku/component/sudoku_cell.dart';
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
            final Point point = Point.from(row, column);
            return TableCell(
              child: InkWell(
                onTap: () => sudokuNotifier.onTapped(point),
                child: SudokuCell(
                  boxBorder: point.border,
                  value: sudokuNotifier.getValue(point),
                  noteValue: sudokuNotifier.getNoteValue(point),
                  color: sudokuNotifier.getColor(point),
                  textColor: sudokuNotifier.getTextColor(point),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
