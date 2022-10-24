import 'package:flutter/material.dart';
import 'package:flutter_sudoku/business/home/sudoku_calendar_screen.dart';
import 'package:flutter_sudoku/business/sudoku/sudoku_board.dart';
import 'package:flutter_sudoku/business/sudoku/sudoku_header.dart';
import 'package:flutter_sudoku/business/sudoku/sudoku_key_pad.dart';
import 'package:flutter_sudoku/business/sudoku/sudoku_notifier.dart';
import 'package:flutter_sudoku/business/sudoku/sudoku_operate.dart';
import 'package:flutter_sudoku/common/context_extension.dart';
import 'package:flutter_sudoku/common/date_extension.dart';
import 'package:flutter_sudoku/component/appbar_back_button.dart';
import 'package:flutter_sudoku/component/center_progress_indicator.dart';
import 'package:flutter_sudoku/component/svg_action_icon.dart';
import 'package:flutter_sudoku/model/sudoku.dart';
import 'package:flutter_sudoku/util/comm_util.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'sudoku_setting_screen.dart';

class SudokuScreen extends HookConsumerWidget {
  final DateTime dateTime;
  final Difficulty difficulty;

  const SudokuScreen(this.dateTime, this.difficulty, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sudokuModel = ref.watch(sudokuProvider(SudokuRequest(dateTime: dateTime, difficulty: difficulty)));

    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          child: Text(dateTime.toDateString()),
          onTap: () async {
            final DateTime? selectedDateTime = await context.goto(SudokuCalendarScreen(dateTime));
            if (selectedDateTime != null && !selectedDateTime.isSameDay(dateTime)) {
              await sudokuModel.refresh(selectedDateTime, difficulty);
            }
          },
        ),
        leading: const AppbarBackButton(),
        actions: [
          SvgActionIcon(
            name: "sudoku_color",
            onTap: () => CommUtil.toBeDev(),
          ),
          SvgActionIcon(
            name: "sudoku_setting",
            onTap: () => context.goto(const SudokuSettingScreen()),
          )
        ],
      ),
      body: sudokuModel.state.when(
        loading: () => const CenterProgressIndicator(),
        error: (errorText) => const CenterProgressIndicator(),
        success: () {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                SudokuHeader(sudokuModel),
                SudokuBoard(sudokuModel),
                SudokuOperate(sudokuModel),
                SudokuKeyPad(sudokuModel),
              ],
            ),
          );
        },
      ),
    );
  }
}
