import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_sudoku/api/sudoku_record_api.dart';
import 'package:flutter_sudoku/common/context_extension.dart';
import 'package:flutter_sudoku/common/list_extension.dart';
import 'package:flutter_sudoku/common/stream_list.dart';
import 'package:flutter_sudoku/component/appbar_back_button.dart';
import 'package:flutter_sudoku/component/center_progress_indicator.dart';
import 'package:flutter_sudoku/component/empty_widget.dart';
import 'package:flutter_sudoku/component/svg_action_icon.dart';
import 'package:flutter_sudoku/component/text_icon.dart';
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

class _SudokuRecordListScreenState extends State<SudokuRecordListScreen> {
  final StreamList<SudokuRecord> streamList = StreamList();

  @override
  void initState() {
    super.initState();
    streamList.addRequestListener((pageKey) => _fetchPage(pageKey));
  }

  Future<void> _fetchPage(int pageKey) async {
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
            name: "delete",
            onPressed: () {
              context.showCommDialog(
                callback: () async {
                  await GetIt.I<SudokuRecordApi>().deleteAll();
                  streamList.reset([]);
                },
                title: '清空记录',
                content: '你确定清空数独记录?',
              );
            },
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
                      padding: EdgeInsets.zero,
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

  @override
  void dispose() {
    streamList.dispose();
    super.dispose();
  }
}
