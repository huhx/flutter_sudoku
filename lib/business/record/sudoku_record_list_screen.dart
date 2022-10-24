import 'package:flutter/material.dart';
import 'package:flutter_sudoku/api/sudoku_record_api.dart';
import 'package:flutter_sudoku/common/context_extension.dart';
import 'package:flutter_sudoku/common/stream_list.dart';
import 'package:flutter_sudoku/component/appbar_back_button.dart';
import 'package:flutter_sudoku/component/center_progress_indicator.dart';
import 'package:flutter_sudoku/component/empty_widget.dart';
import 'package:flutter_sudoku/component/svg_action_icon.dart';
import 'package:flutter_sudoku/model/sudoku_record.dart';
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

          return SmartRefresher(
            controller: streamList.refreshController,
            onRefresh: () => streamList.onRefresh(),
            onLoading: () => streamList.onLoading(),
            enablePullUp: true,
            child: ListView.builder(
              itemCount: sudokuRecords.length,
              itemBuilder: (_, index) {
                final SudokuRecord sudokuRecord = sudokuRecords[index];
                return ListTile(
                  leading: CircleAvatar(child: Text("${sudokuRecord.duration}")),
                  title: Text(sudokuRecord.dateString),
                  subtitle: Text("${sudokuRecord.startString} ~ ${sudokuRecord.endString}"),
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
