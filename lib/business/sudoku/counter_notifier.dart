import 'dart:async';

import 'package:app_common_flutter/extension.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CounterNotifier extends ChangeNotifier {
  bool isStart = true;
  int seconds = 0;
  Timer? timer;

  void init(int initSeconds) {
    seconds = initSeconds;

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      seconds = seconds + 1;

      notifyListeners();
    });
  }

  void toggle() {
    isStart = !isStart;

    if (isStart) {
      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        seconds = seconds + 1;

        notifyListeners();
      });
    } else {
      timer?.cancel();

      notifyListeners();
    }
  }

  String get secondsString => seconds.timeString;

  void reset() {
    isStart = false;

    timer?.cancel();
    notifyListeners();
  }

  @override
  void dispose() {
    isStart = false;

    timer?.cancel();
    super.dispose();
  }
}

final counterProvider = ChangeNotifierProvider.autoDispose((ref) {
  return CounterNotifier()..init(0);
});
