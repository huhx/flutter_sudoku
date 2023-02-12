import 'package:flutter/material.dart';
import 'package:flutter_sudoku/business/sudoku/sudoku_notifier.dart';
import 'package:flutter_sudoku/common/context_extension.dart';
import 'package:flutter_sudoku/component/appbar_back_button.dart';
import 'package:flutter_sudoku/component/svg_icon.dart';
import 'package:flutter_sudoku/provider/error_count_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SudokuSuccessScreen extends ConsumerWidget {
  final SudokuNotifier sudokuNotifier;

  const SudokuSuccessScreen(this.sudokuNotifier, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final retryCount = ref.watch(errorCountProvider);

    return Scaffold(
      appBar: AppBar(
        leading: const AppbarBackButton(),
        title: const Text("挑战成功"),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SvgIcon(name: "sudoku_success", size: 64),
            const SizedBox(height: 16),
            Text("难度: ${sudokuNotifier.difficulty.label}"),
            const SizedBox(height: 6),
            Text("用时: ${sudokuNotifier.dateString}"),
            const SizedBox(height: 6),
            Text("错误：${sudokuNotifier.retryCount}/$retryCount"),
            const SizedBox(height: 6),
            OutlinedButton(
              onPressed: () async {
                await sudokuNotifier.next();
                if (context.mounted) context.pop();
              },
              child: const Text("下一关"),
            ),
          ],
        ),
      ),
    );
  }
}
