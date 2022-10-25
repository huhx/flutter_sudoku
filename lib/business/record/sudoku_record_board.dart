import 'package:flutter/material.dart';
import 'package:flutter_sudoku/business/sudoku/sudoku_board.dart';
import 'package:flutter_sudoku/model/sudoku_input_log.dart';
import 'package:flutter_sudoku/model/sudoku_point.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'data/sudoku_record_notifier.dart';

class SudokuRecordBoard extends HookConsumerWidget {
  final SudokuInputLog sudokuInputLog;

  const SudokuRecordBoard(this.sudokuInputLog, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sudokuRecordModel = ref.watch(sudokuRecordNotifier(sudokuInputLog));
    
    return Table(
      children: List.generate(
        9,
        (row) => TableRow(
          children: List.generate(9, (column) {
            return TableCell(child: SudokuRecordCell(Point.from(row, column), sudokuRecordModel));
          }),
        ),
      ),
    );
  }
}

class SudokuRecordCell extends StatelessWidget {
  final Point point;
  final SudokuRecordNotifier sudokuRecordModel;

  const SudokuRecordCell(this.point, this.sudokuRecordModel, {super.key});

  @override
  Widget build(BuildContext context) {
    final List<int>? noteValue = sudokuRecordModel.getNoteValue(point);
    final int number = sudokuRecordModel.getValue(point);

    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(border: point.border, color: sudokuRecordModel.getColor(point)),
        alignment: Alignment.center,
        child: noteValue != null && noteValue.isNotEmpty
            ? SudokuNoteCell(noteValue)
            : SudokuNormalCell(number, sudokuRecordModel.getTextColor(point)),
      ),
    );
  }
}
