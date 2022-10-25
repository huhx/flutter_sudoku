import 'package:flutter/material.dart';
import 'package:flutter_sudoku/component/appbar_back_button.dart';
import 'package:flutter_sudoku/model/sudoku_record.dart';

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
      ),
      body: Container(
        alignment: Alignment.center,
        child: SudokuRecordBoard(sudokuRecord.sudokuInputLog),
      ),
    );
  }
}
