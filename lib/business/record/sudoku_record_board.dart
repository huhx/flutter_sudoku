import 'package:flutter/material.dart';
import 'package:flutter_sudoku/component/sudoku_cell.dart';
import 'package:flutter_sudoku/model/sudoku_point.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'data/sudoku_record_notifier.dart';

class SudokuRecordBoard extends HookConsumerWidget {
  final SudokuRecordNotifier sudokuRecordModel;

  const SudokuRecordBoard(this.sudokuRecordModel, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Table(
      children: List.generate(
        9,
        (row) => TableRow(
          children: List.generate(9, (column) {
            final Point point = Point.from(row, column);

            return TableCell(
              child: SudokuCell(
                boxBorder: point.border,
                value: sudokuRecordModel.getValue(point),
                noteValue: sudokuRecordModel.getNoteValue(point),
                color: sudokuRecordModel.getColor(point),
                textColor: sudokuRecordModel.getTextColor(point),
              ),
            );
          }),
        ),
      ),
    );
  }
}
