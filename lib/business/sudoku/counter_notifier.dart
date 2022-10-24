import 'dart:async';

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

  String get secondsString {
    final int second = seconds % 60;
    final int minute = (seconds / 60).floor();

    final String secondString = second < 10 ? "0$second" : "$second";
    final String minuteString = minute < 10 ? "0$minute" : "$minute";
    return "$minuteString:$secondString";
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}

final counterProvider = ChangeNotifierProvider.autoDispose.family<CounterNotifier, int>((ref, seconds) {
  return CounterNotifier()..init(seconds);
});
