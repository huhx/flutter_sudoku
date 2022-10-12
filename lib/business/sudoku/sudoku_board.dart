import 'package:flutter/material.dart';

class SudokuBoard extends StatelessWidget {
  final List<List<int>> questions;

  const SudokuBoard(this.questions, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
      children: List.generate(
        9,
        (row) => TableRow(
          children: List.generate(9, (column) => TableCell(child: SudokuCell(row, column, questions[row][column]))),
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
        decoration: BoxDecoration(border: _buildBorder(row, column), color: _buildColor(row, column)),
        alignment: Alignment.center,
        child: Text(number == 0 ? "" : number.toString()),
      ),
    );
  }

  Color? _buildColor(int row, int column) {
    if ((row + column) % 2 == 0) {
      return Colors.greenAccent.withOpacity(0.6);
    }
    return null;
  }

  BoxBorder _buildBorder(int row, int column) {
    const BorderSide borderSide = BorderSide(color: Colors.blue, width: 2.0);
    final List<int> columnIndexes = [0, 3, 6];
    final List<int> rowIndexes = [0, 3, 6];
    BorderSide top = BorderSide.none, bottom = BorderSide.none, left = BorderSide.none, right = BorderSide.none;

    if (columnIndexes.contains(column)) {
      left = borderSide;
    } else {
      left = const BorderSide(color: Colors.grey);
    }

    if (rowIndexes.contains(row)) {
      top = borderSide;
    } else {
      top = const BorderSide(color: Colors.grey);
    }

    if (column == 8) {
      right = borderSide;
    }

    if (row == 8) {
      bottom = borderSide;
    }

    return Border(top: top, bottom: bottom, left: left, right: right);
  }
}
