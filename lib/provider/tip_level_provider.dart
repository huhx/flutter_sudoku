import 'package:flutter_sudoku/model/sudoku_tip.dart';
import 'package:flutter_sudoku/util/prefs_util.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TipLevelNotifier extends StateNotifier<TipLevel> {
  TipLevelNotifier() : super(PrefsUtil.getTipLevel());

  void set(TipLevel tipLevel) {
    PrefsUtil.setTipLevel(tipLevel);

    state = tipLevel;
  }
}

final tipLevelProvider = StateNotifierProvider<TipLevelNotifier, TipLevel>((ref) {
  return TipLevelNotifier();
});
