import 'package:app_common_flutter/extension.dart';
import 'package:app_common_flutter/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sudoku/api/sudoku_record_api.dart';
import 'package:flutter_sudoku/business/home/sudoku_screen.dart';
import 'package:flutter_sudoku/business/statistics/sudoku_statistics.dart';
import 'package:flutter_sudoku/common/context_extension.dart';
import 'package:flutter_sudoku/model/sudoku.dart';
import 'package:get_it/get_it.dart';

class SudokuStatisticsDetailScreen extends StatelessWidget {
  final Difficulty difficulty;

  const SudokuStatisticsDetailScreen(this.difficulty, {super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GetIt.I<SudokuRecordApi>().queryStatistics(difficulty),
      builder: (context, snap) {
        if (!snap.hasData) return const CenterProgressIndicator();
        final SudokuStatistics statistics = snap.data as SudokuStatistics;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
          child: Column(
            children: [
              ListTile(
                title: const Text("总共局数"),
                trailing: Text(statistics.totalCount.toString()),
              ),
              ListTile(
                title: const Text("胜局次数"),
                trailing: Text(statistics.successCount.toString()),
              ),
              ListTile(
                title: const Text("败局次数"),
                trailing: Text(statistics.failedCount.toString()),
              ),
              ListTile(
                title: const Text("最佳时间"),
                trailing: Text(statistics.bestTime.timeString),
              ),
              ListTile(
                title: const Text("最长时间"),
                trailing: Text(statistics.worstTime.timeString),
              ),
              ListTile(
                title: const Text("平均时间"),
                trailing: Text(statistics.avgTime.timeString),
              ),
              ListTile(
                title: const Text("最长连赢"),
                trailing: Text(statistics.straightWins.toString()),
              ),
              ListTile(
                title: const Text("最惨连败"),
                trailing: Text(statistics.straightLose.toString()),
              ),
              Expanded(
                child: Center(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 32)),
                    onPressed: () => context.pushAndRemoveUntil(SudokuScreen(DateTime.now(), difficulty)),
                    child: const Text("开始一局"),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
