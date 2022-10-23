import 'package:flutter/material.dart';
import 'package:flutter_sudoku/business/sudoku/counter_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SudokuCounter extends HookConsumerWidget {
  final int initSeconds;

  const SudokuCounter({super.key, required this.initSeconds});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counterModel = ref.watch(counterProvider(initSeconds));

    return Text(counterModel.secondsString);
  }
}
