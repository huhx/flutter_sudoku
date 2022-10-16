import 'package:flutter/material.dart';
import 'package:flutter_sudoku/business/sudoku/sudoku_notifier.dart';

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
            return TableCell(child: SudokuCell(row, column, sudokuNotifier.sudokuResponse.fromQuestion()[row][column], sudokuNotifier));
          }),
        ),
      ),
    );
  }
}

class SudokuCell extends StatelessWidget {
  final int row;
  final int column;
  final int number;
  final SudokuNotifier sudokuNotifier;

  const SudokuCell(this.row, this.column, this.number, this.sudokuNotifier, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => sudokuNotifier.onTapped(row, column),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(border: _buildBorder(row, column), color: sudokuNotifier.getColor(row, column)),
          alignment: Alignment.center,
          child: Text(
            number == 0 ? "" : number.toString(),
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ),
      ),
    );
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
