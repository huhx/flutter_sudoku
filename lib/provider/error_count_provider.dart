import 'package:flutter_sudoku/util/prefs_util.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ErrorCountNotifier extends StateNotifier<int> {
  ErrorCountNotifier() : super(PrefsUtil.getErrorCount());

  void set(int errorCount) {
    PrefsUtil.setErrorCount(errorCount);

    state = errorCount;
  }
}

final errorCountProvider = StateNotifierProvider<ErrorCountNotifier, int>((ref) {
  return ErrorCountNotifier();
});
