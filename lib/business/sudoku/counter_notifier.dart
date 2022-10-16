import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CounterNotifier extends ChangeNotifier {
  bool isStart = false;
  int initSeconds = 0;
  final Stopwatch stopwatch = Stopwatch();
  Timer? timer;

  void init(int initSeconds) {
    this.initSeconds = initSeconds;

    stopwatch.reset();
  }

  void toggleStart() {
    isStart = !isStart;

    if (isStart) {
      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        initSeconds = initSeconds + 1;
        notifyListeners();
      });
    } else {
      timer?.cancel();
      notifyListeners();
    }
  }

  String get secondsString {
    final int seconds = initSeconds + (stopwatch.elapsedMilliseconds / 1000).floor();
    final int second = seconds % 60;
    final int minute = (seconds / 60).floor();

    final String secondString = second < 10 ? "0$second" : "$second";
    final String minuteString = minute < 10 ? "0$minute" : "$minute";
    return "$minuteString:$secondString";
  }
}

final counterProvider = ChangeNotifierProvider.autoDispose.family<CounterNotifier, int>((ref, seconds) {
  final CounterNotifier counterNotifier = CounterNotifier();
  counterNotifier.init(seconds);
  return counterNotifier;
});
