import 'package:flutter/widgets.dart';
import 'package:flutter_sudoku/model/sudoku_tip.dart';
import 'package:flutter_sudoku/util/prefs_util.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final tipLevelProvider = ChangeNotifierProvider((ref) {
  final TipLevel tipLevel = PrefsUtil.getTipLevel();
  return TipLevelState(tipLevel);
});

class TipLevelState extends ChangeNotifier {
  late TipLevel tipLevel;

  TipLevelState(this.tipLevel);

  void setTipLevel(TipLevel tipLevel) {
    PrefsUtil.setTipLevel(tipLevel);
    this.tipLevel = tipLevel;

    notifyListeners();
  }
}
