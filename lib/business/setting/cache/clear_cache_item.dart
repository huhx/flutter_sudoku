import 'package:app_common_flutter/extension.dart';
import 'package:app_common_flutter/views.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sudoku/api/sudoku_record_api.dart';
import 'package:flutter_sudoku/common/context_extension.dart';
import 'package:get_it/get_it.dart';

class ClearCacheItem extends StatelessWidget {
  const ClearCacheItem({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: Text('清除缓存', style: Theme.of(context).textTheme.bodyLarge),
      trailing: const ListTileTrailing(),
      onTap: () => _showConfirmDialog(context),
    );
  }

  Future<void> _showConfirmDialog(BuildContext context) async {
    context.showCommDialog(
      callback: () async {
        await GetIt.I<SudokuRecordApi>().clear();
        if (context.mounted) context.pop();
      },
      title: '清除缓存',
      content: '你确定清除缓存?',
    );
  }
}
