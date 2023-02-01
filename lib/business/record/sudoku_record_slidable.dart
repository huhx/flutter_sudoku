import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_sudoku/common/context_extension.dart';
import 'package:flutter_sudoku/component/list_tile_trailing.dart';
import 'package:flutter_sudoku/component/text_icon.dart';
import 'package:flutter_sudoku/model/sudoku_record.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'sudoku_record_screen.dart';

class SudokuRecordSlidable extends ConsumerWidget {
  final SudokuRecord sudokuRecord;
  final Function(int) onDelete;

  const SudokuRecordSlidable({
    super.key,
    required this.sudokuRecord,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Slidable(
      key: ValueKey(sudokuRecord.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onDelete(sudokuRecord.id!),
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

class SudokuRecordItem extends StatelessWidget {
  final SudokuRecord sudokuRecord;

  const SudokuRecordItem(this.sudokuRecord, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => context.goto(SudokuRecordScreen(sudokuRecord)),
      leading: CircleAvatar(
        backgroundColor: sudokuRecord.color,
        child: Text("${sudokuRecord.duration}", style: const TextStyle(color: Colors.white)),
      ),
      title: Text(sudokuRecord.startString, style: Theme.of(context).textTheme.bodyMedium),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          children: [
            TextIcon(icon: "game_status", text: sudokuRecord.gameStatus.label),
            const SizedBox(width: 16),
            TextIcon(icon: "user_tips", text: "${sudokuRecord.tipCount}次"),
            const SizedBox(width: 16),
            TextIcon(icon: "error", text: "${sudokuRecord.errorCount}次"),
            const SizedBox(width: 16),
            TextIcon(icon: "difficulty", text: sudokuRecord.difficulty.label),
          ],
        ),
      ),
      trailing: const ListTileTrailing(),
    );
  }
}
