import 'package:flutter/material.dart';
import 'package:flutter_sudoku/component/cancel_confirm_dialog.dart';

extension ContextExtensions on BuildContext {
  Future<T?> goto<T extends Object?>(Widget widget) async {
    return Navigator.push(this, MaterialPageRoute<T>(builder: (_) => widget));
  }

  Future<T?> replace<T extends Object?>(Widget widget) async {
    return Navigator.pushReplacement(this, MaterialPageRoute<T>(builder: (_) => widget));
  }

  void pop<T extends Object?>([T? result]) {
    Navigator.pop<T>(this, result);
  }

  void showCommDialog({
    required VoidCallback callback,
    title = '删除',
    content = '确定要删除?',
  }) {
    showDialog(
      context: this,
      builder: (_) => CancelConfirmDialog(
        title: title,
        content: content,
        callback: callback,
      ),
    );
  }
}
