import 'package:flutter/material.dart';
import 'package:flutter_sudoku/api/sudoku_api.dart';
import 'package:flutter_sudoku/business/home/sudoku_calendar_screen.dart';
import 'package:flutter_sudoku/business/sudoku/sudoku_board.dart';
import 'package:flutter_sudoku/business/sudoku/sudoku_header.dart';
import 'package:flutter_sudoku/business/sudoku/sudoku_key_pad.dart';
import 'package:flutter_sudoku/business/sudoku/sudoku_operate.dart';
import 'package:flutter_sudoku/common/context_extension.dart';
import 'package:flutter_sudoku/common/date_extension.dart';
import 'package:flutter_sudoku/component/appbar_back_button.dart';
import 'package:flutter_sudoku/component/center_progress_indicator.dart';
import 'package:flutter_sudoku/component/svg_action_icon.dart';
import 'package:flutter_sudoku/model/sudoku.dart';
import 'package:flutter_sudoku/util/comm_util.dart';

import 'sudoku_setting_screen.dart';

class SudokuScreen extends StatefulWidget {
  final DateTime dateTime;
  final Difficulty difficulty;

  const SudokuScreen(this.dateTime, this.difficulty, {super.key});

  @override
  State<SudokuScreen> createState() => _SudokuScreenState();
}

class _SudokuScreenState extends State<SudokuScreen> {
  late DateTime dateTime;

  @override
  void initState() {
    super.initState();
    dateTime = widget.dateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          child: Text(dateTime.toDateString()),
          onTap: () async {
            final DateTime? selectedDateTime = await context.goto(SudokuCalendarScreen(dateTime));
            if (selectedDateTime != null && !selectedDateTime.isSameDay(dateTime)) {
              setState(() => dateTime = selectedDateTime.toDate());
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
      body: FutureBuilder(
        future: sudokuApi.getSudokuData(dateTime, widget.difficulty),
        builder: (context, snap) {
          if (!snap.hasData) return const CenterProgressIndicator();
          final SudokuResponse sudoku = snap.data as SudokuResponse;
          final List<List<int>> questions = sudoku.fromQuestion();

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                SudokuHeader(sudoku),
                SudokuBoard(questions),
                const SudokuOperate(),
                const SudokuKeyPad(),
              ],
            ),
          );
        },
      ),
    );
  }
}
