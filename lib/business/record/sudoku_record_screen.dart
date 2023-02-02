import 'package:flutter/material.dart';
import 'package:flutter_sudoku/component/appbar_back_button.dart';
import 'package:flutter_sudoku/component/svg_icon.dart';
import 'package:flutter_sudoku/model/sudoku.dart';
import 'package:flutter_sudoku/model/sudoku_record.dart';
import 'package:flutter_sudoku/util/comm_util.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'data/sudoku_record_notifier.dart';
import 'sudoku_record_board.dart';

class SudokuRecordScreen extends HookConsumerWidget {
  final SudokuRecord sudokuRecord;

  const SudokuRecordScreen(this.sudokuRecord, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sudokuRecordModel = ref.watch(sudokuRecordProvider(sudokuRecord.sudokuInputLog));

    return Scaffold(
      appBar: AppBar(
        leading: const AppbarBackButton(),
        title: const Text("数独记录详情"),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("时间：${sudokuRecord.dateString}"),
              Text("难度: ${sudokuRecord.difficulty.label}"),
              Text("用时: ${sudokuRecord.secondsString}"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
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
              IconButton(
                icon: const SvgIcon(name: 'sudoku_answer', color: Colors.green),
                onPressed: () => sudokuRecordModel.showAnswer(),
              ),
            ],
          ),
          SudokuRecordBoard(sudokuRecordModel),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("输入: ${sudokuRecord.sudokuInputLog.inputSteps}次"),
              Text("笔记: ${sudokuRecord.sudokuInputLog.noteSteps}次"),
              Text("错误: ${sudokuRecord.errorCount}次"),
              Text("提示: ${sudokuRecord.tipCount}次"),
            ],
          ),
        ],
      ),
    );
  }
}
