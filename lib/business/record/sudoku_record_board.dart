import 'package:flutter/material.dart';
import 'package:flutter_sudoku/business/sudoku/sudoku_board.dart';
import 'package:flutter_sudoku/component/svg_icon.dart';
import 'package:flutter_sudoku/model/sudoku.dart';
import 'package:flutter_sudoku/model/sudoku_input_log.dart';
import 'package:flutter_sudoku/model/sudoku_point.dart';
import 'package:flutter_sudoku/util/comm_util.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'data/sudoku_record_notifier.dart';

class SudokuRecordBoard extends HookConsumerWidget {
  final SudokuInputLog sudokuInputLog;

  const SudokuRecordBoard(this.sudokuInputLog, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sudokuRecordModel = ref.watch(sudokuRecordNotifier(sudokuInputLog));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          IconButton(
            icon: const SvgIcon(name: 'delete', color: Colors.red),
            onPressed: () async {
              final GameStatus gameStatus = await sudokuRecordModel.startPlay();
              if (gameStatus == GameStatus.success) {
                CommUtil.toast(message: "恭喜你成功过关");
              } else if (gameStatus == GameStatus.failed) {
                CommUtil.toast(message: "已达到最大错误次数，游戏失败");
              }
            },
          ),
          Table(
            children: List.generate(
              9,
              (row) => TableRow(
                children: List.generate(9, (column) {
                  return TableCell(child: SudokuRecordCell(Point.from(row, column), sudokuRecordModel));
                }),
              ),
            ),
          )
        ],
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
