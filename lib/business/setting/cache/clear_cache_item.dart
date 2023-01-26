import 'package:flutter/material.dart';
import 'package:flutter_sudoku/api/sudoku_record_api.dart';
import 'package:flutter_sudoku/common/context_extension.dart';

class ClearCacheItem extends StatelessWidget {
  const ClearCacheItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () => _showConfirmDialog(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const <Widget>[
            Text('清除缓存', style: TextStyle(fontSize: 14)),
            IconTheme(data: IconThemeData(color: Colors.grey), child: Icon(Icons.keyboard_arrow_right))
          ],
        ),
      ),
    );
  }

  Future<void> _showConfirmDialog(BuildContext context) async {
    context.showCommDialog(
      callback: () async {
        await sudokuRecordApi.clear();
        if (context.mounted) context.pop();
      },
      title: '清除缓存',
      content: '你确定清除缓存?',
    );
  }
}
