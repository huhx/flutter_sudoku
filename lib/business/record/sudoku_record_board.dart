import 'package:flutter/material.dart';
import 'package:flutter_sudoku/component/sudoku_cell.dart';
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

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const SvgIcon(name: 'sudoku_retry', color: Colors.green),
              onPressed: () async {
                final GameStatus gameStatus = await sudokuRecordModel.resetPlay();
                if (gameStatus == GameStatus.success) {
                  CommUtil.toast(message: "恭喜你成功过关");
                } else if (gameStatus == GameStatus.failed) {
                  CommUtil.toast(message: "已达到最大错误次数，游戏失败");
                }
              },
            ),
          ],
        ),
        Table(
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
        )
      ],
    );
  }
}
