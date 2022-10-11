import 'package:flutter/material.dart';

class SudokuBoard extends StatelessWidget {
  final List<List<int>> questions;

  const SudokuBoard(this.questions, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.grey),
      children: List.generate(
        9,
        (row) => TableRow(
          children: List.generate(9, (column) => SudokuCell(row, column, questions[row][column])),
        ),
      ),
    );
  }
}

class SudokuCell extends StatelessWidget {
  final int row;
  final int column;
  final int number;

  const SudokuCell(this.row, this.column, this.number, {super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        alignment: Alignment.center,
        child: Text(number == 0 ? "" : number.toString()),
      ),
    );
  }
}

