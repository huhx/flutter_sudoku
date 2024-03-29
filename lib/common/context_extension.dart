import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  Future<T?> goto<T extends Object?>(Widget widget) async {
    return Navigator.push(this, MaterialPageRoute<T>(builder: (_) => widget));
  }

  Future<T?> replace<T extends Object?>(Widget widget) async {
    return Navigator.pushReplacement(this, MaterialPageRoute<T>(builder: (_) => widget));
  }

  Future<T?> pushAndRemoveUntil<T extends Object?>(Widget widget) async {
    return Navigator.pushAndRemoveUntil(this, MaterialPageRoute(builder: (_) => widget), (route) => false);
  }

  void pop<T extends Object?>([T? result]) {
    Navigator.pop<T>(this, result);
  }
}
