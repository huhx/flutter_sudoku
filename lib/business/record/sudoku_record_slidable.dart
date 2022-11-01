import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_sudoku/api/sudoku_record_api.dart';
import 'package:flutter_sudoku/common/context_extension.dart';
import 'package:flutter_sudoku/model/sudoku_record.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'sudoku_record_list_screen.dart';

class SudokuRecordSlidable extends ConsumerWidget {
  final SudokuRecord sudokuRecord;

  const SudokuRecordSlidable(this.sudokuRecord, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Slidable(
      key: ValueKey(sudokuRecord.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) async => await sudokuRecordApi.delete(sudokuRecord.id!),
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
          SlidableAction(
            onPressed: (_) => context.share(title: sudokuRecord.shareTitle, subject: "sudoku"),
            backgroundColor: const Color(0xFF21B7CA),
            foregroundColor: Colors.white,
            icon: Icons.share,
            label: 'Share',
          ),
        ],
      ),
      child: SudokuRecordItem(sudokuRecord),
    );
  }
}
