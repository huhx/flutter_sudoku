import 'package:app_common_flutter/app_common_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sudoku/business/sudoku/sudoku_notifier.dart';
import 'package:flutter_sudoku/common/context_extension.dart';
import 'package:flutter_sudoku/provider/error_count_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SudokuFailedScreen extends ConsumerWidget {
  final SudokuNotifier sudokuNotifier;

  const SudokuFailedScreen(this.sudokuNotifier, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final retryCount = ref.watch(errorCountProvider);

    return Scaffold(
      appBar: AppBar(
        leading: const AppbarBackButton(),
        title: const Text("挑战失败"),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SvgIcon(name: "sudoku_failed", size: 64),
            const SizedBox(height: 16),
            Text(sudokuNotifier.difficulty.label),
            const SizedBox(height: 6),
            Text(sudokuNotifier.dateString),
            const SizedBox(height: 6),
            Text("错误：${sudokuNotifier.retryCount}/$retryCount"),
            const SizedBox(height: 6),
            OutlinedButton(
              onPressed: () async {
                await sudokuNotifier.reset();
                if (context.mounted) context.pop();
              },
              child: const Text("再次挑战"),
            ),
          ],
        ),
      ),
    );
  }
}
