import 'package:flutter/material.dart';
import 'package:flutter_sudoku/business/sudoku/sudoku_notifier.dart';
import 'package:flutter_sudoku/common/context_extension.dart';
import 'package:flutter_sudoku/component/svg_icon.dart';
import 'package:flutter_sudoku/model/sudoku_config.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SudokuFailedScreen extends ConsumerWidget {
  final SudokuNotifier sudokuNotifier;

  const SudokuFailedScreen(this.sudokuNotifier, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SvgIcon(name: "sudoku_failed", size: 64),
          const Text("挑战失败", style: TextStyle(fontSize: 24, color: Colors.amber)),
          Text(sudokuNotifier.difficulty.label),
          Text(sudokuNotifier.dateString),
          Text("错误：${sudokuNotifier.retryCount}/${sudokuConfig.retryCount}"),
          TextButton(
            onPressed: () async {
              await sudokuNotifier.reset();
              context.pop();
            },
            child: const Text("再次挑战"),
          ),
        ],
      ),
    );
  }
}
