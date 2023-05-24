import 'package:app_common_flutter/extension.dart';
import 'package:app_common_flutter/pagination.dart';
import 'package:app_common_flutter/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_sudoku/api/sudoku_record_api.dart';
import 'package:flutter_sudoku/business/home/sudoku_statistics_screen.dart';
import 'package:flutter_sudoku/common/context_extension.dart';
import 'package:flutter_sudoku/model/sudoku_record.dart';
import 'package:flutter_sudoku/util/date_util.dart';
import 'package:get_it/get_it.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sticky_headers/sticky_headers.dart';

import 'sudoku_record_slidable.dart';

class SudokuRecordListScreen extends StatefulWidget {
  const SudokuRecordListScreen({super.key});

  @override
  State<SudokuRecordListScreen> createState() => _SudokuRecordListScreenState();
}

class _SudokuRecordListScreenState extends StreamState<SudokuRecordListScreen, SudokuRecord> {
  @override
  Future<void> fetchPage(int pageKey) async {
    if (streamList.isOpen) {
      final List<SudokuRecord> sudokuRecords = await GetIt.I<SudokuRecordApi>().querySudokuRecords(pageKey);
      streamList.fetch(sudokuRecords, pageKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppbarBackButton(),
        title: const Text("数独记录"),
        actions: [
          SvgActionIcon(
            name: "item_analyze",
            onPressed: () => context.goto(const SudokuStatisticsScreen()),
          )
        ],
      ),
      body: StreamBuilder(
        stream: streamList.stream,
        builder: (context, snap) {
          if (!snap.hasData) return const CenterProgressIndicator();
          final List<SudokuRecord> sudokuRecords = snap.data as List<SudokuRecord>;

          if (sudokuRecords.isEmpty) {
            return const EmptyWidget(message: "数独记录为空");
          }

          final Map<String, List<SudokuRecord>> recordLogMap =
              sudokuRecords.groupBy((readLog) => readLog.createTimeString);

          return SlidableAutoCloseBehavior(
            child: SmartRefresher(
              controller: streamList.refreshController,
              onRefresh: () => streamList.onRefresh(),
              onLoading: () => streamList.onLoading(),
              enablePullUp: true,
              child: ListView.builder(
                itemCount: recordLogMap.length,
                itemBuilder: (_, index) {
                  final String dateString = recordLogMap.keys.elementAt(index);
                  final List<SudokuRecord> recordLogItems = recordLogMap[dateString]!;

                  return StickyHeader(
                    header: Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SimpleTextIcon(icon: "sudoku_log", text: dateString),
                          SimpleTextIcon(icon: "weekday", text: DateUtil.getWeekFromString(dateString)),
                        ],
                      ),
                    ),
                    content: ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return SudokuRecordSlidable(
                          key: ValueKey(recordLogItems[index].id),
                          sudokuRecord: recordLogItems[index],
                          onDelete: (id) async {
                            streamList.reset(sudokuRecords.where((element) => element.id != id).toList());
                            await GetIt.I<SudokuRecordApi>().delete(id);
                          },
                        );
                      },
                      itemCount: recordLogItems.length,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
