import 'package:flutter_sudoku/util/prefs_util.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TipCountNotifier extends StateNotifier<int> {
  TipCountNotifier() : super(PrefsUtil.getTipCount());

  void set(int tipCount) {
    PrefsUtil.setTipCount(tipCount);

    state = tipCount;
  }
}

final tipCountProvider = StateNotifierProvider<TipCountNotifier, int>((ref) {
  return TipCountNotifier();
});
