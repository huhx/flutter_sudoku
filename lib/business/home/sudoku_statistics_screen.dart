import 'package:app_common_flutter/constant.dart';
import 'package:app_common_flutter/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sudoku/api/sudoku_record_api.dart';
import 'package:flutter_sudoku/common/context_extension.dart';
import 'package:flutter_sudoku/model/sudoku.dart';
import 'package:get_it/get_it.dart';

import 'sudoku_statistics_detail_screen.dart';

class SudokuStatisticsScreen extends StatefulWidget {
  const SudokuStatisticsScreen({super.key});

  @override
  State<SudokuStatisticsScreen> createState() => _SudokuStatisticsScreenState();
}

class _SudokuStatisticsScreenState extends State<SudokuStatisticsScreen> {
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
              package: Comm.package,
              name: 'delete',
              onPressed: () {
                context.showCommDialog(
                  callback: () async {
                    await GetIt.I<SudokuRecordApi>().deleteAll();
                    setState(() {});
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
