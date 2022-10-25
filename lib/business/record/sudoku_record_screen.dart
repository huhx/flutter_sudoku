import 'package:flutter/material.dart';
import 'package:flutter_sudoku/component/appbar_back_button.dart';
import 'package:flutter_sudoku/component/svg_action_icon.dart';
import 'package:flutter_sudoku/model/sudoku_record.dart';
import 'package:flutter_sudoku/util/comm_util.dart';

import 'sudoku_record_board.dart';

class SudokuRecordScreen extends StatelessWidget {
  final SudokuRecord sudokuRecord;

  const SudokuRecordScreen(this.sudokuRecord, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppbarBackButton(),
        title: const Text("数独记录详情"),
        actions: [
          SvgActionIcon(
            name: "sudoku_share",
            onTap: () => CommUtil.toBeDev(),
          ),
        ],
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("次数: ${sudokuRecord.sudokuInputLog.inputSteps}"),
              Text("错误: ${sudokuRecord.errorCount}"),
              Text("提示: ${sudokuRecord.tipCount}"),
            ],
          ),
          SudokuRecordBoard(sudokuRecord.sudokuInputLog),
        ],
      ),
    );
  }
}
