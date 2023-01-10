import 'package:flutter/material.dart';
import 'package:flutter_sudoku/component/cancel_confirm_dialog.dart';
import 'package:share_plus/share_plus.dart';

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

  bool get isDarkMode {
    return MediaQuery.of(this).platformBrightness == Brightness.dark;
  }

  void showSnackBar(
    String content, {
    duration = 1,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(content),
        duration: Duration(seconds: duration),
      ),
    );
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

  Future<void> share({
    required String title,
    required String subject,
  }) async {
    final RenderBox? box = findRenderObject() as RenderBox?;

    await Share.share(
      title,
      subject: subject,
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }
}
