import 'package:flutter/material.dart';
import 'package:flutter_sudoku/component/appbar_back_button.dart';
import 'package:flutter_sudoku/component/svg_action_icon.dart';
import 'package:flutter_sudoku/model/sudoku.dart';
import 'package:flutter_sudoku/util/comm_util.dart';

import 'sudoku_statistics_detail_screen.dart';

class SudokuStatisticsScreen extends StatelessWidget {
  const SudokuStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: Difficulty.values.length,
      child: Scaffold(
        appBar: AppBar(
          leading: const AppbarBackButton(),
          title: const Text("统计"),
          actions: [
            SvgActionIcon(
              name: 'reset',
              onPressed: () => CommUtil.toBeDev(),
            ),
          ],
          bottom: TabBar(
            tabs: Difficulty.values.map((difficulty) => Tab(text: difficulty.label)).toList(),
            indicatorColor: Colors.white,
            indicatorWeight: 1,
          ),
        ),
        body: TabBarView(
          children: Difficulty.values.map((difficulty) => SudokuStatisticsDetailScreen(difficulty)).toList(),
        ),
      ),
    );
  }
}
