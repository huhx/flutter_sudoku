import 'package:app_common_flutter/app_common_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sudoku/api/sudoku_record_api.dart';
import 'package:flutter_sudoku/common/context_extension.dart';
import 'package:flutter_sudoku/model/sudoku.dart';
import 'package:get_it/get_it.dart';

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
              name: 'delete',
              onPressed: () {
                context.showCommDialog(
                  callback: () async {
                    await GetIt.I<SudokuRecordApi>().deleteAll();
                  },
                  title: '清空记录',
                  content: '你确定清空数独记录?',
                );
              },
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
