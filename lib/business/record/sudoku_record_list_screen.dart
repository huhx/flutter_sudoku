import 'package:flutter/material.dart';
import 'package:flutter_sudoku/api/sudoku_record_api.dart';
import 'package:flutter_sudoku/common/context_extension.dart';
import 'package:flutter_sudoku/common/int_extension.dart';
import 'package:flutter_sudoku/common/list_extension.dart';
import 'package:flutter_sudoku/common/stream_list.dart';
import 'package:flutter_sudoku/component/appbar_back_button.dart';
import 'package:flutter_sudoku/component/center_progress_indicator.dart';
import 'package:flutter_sudoku/component/empty_widget.dart';
import 'package:flutter_sudoku/component/svg_action_icon.dart';
import 'package:flutter_sudoku/component/text_icon.dart';
import 'package:flutter_sudoku/model/sudoku_record.dart';
import 'package:flutter_sudoku/util/date_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
      final List<SudokuRecord> sudokuRecords = await sudokuRecordApi.querySudokuRecords(pageKey);
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
              onTap: () {
                context.showCommDialog(
                  callback: () async {
                    await sudokuRecordApi.deleteAll();
                    streamList.reset([]);
                  },
                  title: '清空记录',
                  content: '你确定清空数独记录?',
                );
              })
        ],
      ),
      body: StreamBuilder(
        stream: streamList.stream,
        builder: (context, snap) {
          if (!snap.hasData) return const CenterProgressIndicator();
          final List<SudokuRecord> sudokuRecords = snap.data as List<SudokuRecord>;

          if (sudokuRecords.isEmpty) {
            return const EmptyWidget(message: "阅读记录为空");
          }

          final Map<String, List<SudokuRecord>> recordLogMap =
              sudokuRecords.groupBy((readLog) => readLog.createTime.toDateString());

          return SmartRefresher(
            controller: streamList.refreshController,
            onRefresh: () => streamList.onRefresh(),
            onLoading: () => streamList.onLoading(),
            enablePullUp: true,
            child: ListView.builder(
              itemCount: recordLogMap.length,
              itemBuilder: (_, index) {
                final String key = recordLogMap.keys.elementAt(index);
                final List<SudokuRecord> recordLogItems = recordLogMap[key]!;

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  primary: false,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SimpleTextIcon(icon: "sudoku_log", text: key),
                                SimpleTextIcon(icon: "weekday", text: DateUtil.getWeekFromString(key)),
                              ],
                            ),
                          ),
                          SudokuRecordItem(recordLogItems[index], key: ValueKey(recordLogItems[index].id)),
                        ],
                      );
                    }
                    return SudokuRecordItem(recordLogItems[index], key: ValueKey(recordLogItems[index].id));
                  },
                  itemCount: recordLogItems.length,
                );
              },
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

class SudokuRecordItem extends StatelessWidget {
  final SudokuRecord sudokuRecord;

  const SudokuRecordItem(this.sudokuRecord, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _buildColor(sudokuRecord),
          child: Text("${sudokuRecord.duration}"),
        ),
        title: Text(sudokuRecord.startString),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              TextIcon(icon: "game_status", text: sudokuRecord.gameStatus.label),
              const SizedBox(width: 16),
              TextIcon(icon: "user_tips", text: "${sudokuRecord.tips}次"),
              const SizedBox(width: 16),
              TextIcon(icon: "difficulty", text: sudokuRecord.difficulty.label),
            ],
          ),
        ),
      ),
    );
  }

  Color _buildColor(SudokuRecord sudokuRecord) {
    final int duration = sudokuRecord.duration;
    if (duration > 15 * 60) {
      return Colors.red;
    } else if (duration > 5 * 60) {
      return Colors.blue;
    } else {
      return Colors.green;
    }
  }
}
