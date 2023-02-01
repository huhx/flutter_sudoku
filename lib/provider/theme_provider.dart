import 'package:flutter/material.dart';
import 'package:flutter_sudoku/util/prefs_util.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppThemeNotifier extends StateNotifier<ThemeMode> {
  final ThemeMode themeMode;
  AppThemeNotifier(this.themeMode) : super(themeMode);

  void setDark(bool isDark) {
    PrefsUtil.saveIsLightTheme(!isDark);

    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }
}

final themeProvider = StateNotifierProvider<AppThemeNotifier, ThemeMode>((ref) {
  final bool? isLightTheme = PrefsUtil.getIsLightTheme();

  if (isLightTheme == null) {
    return AppThemeNotifier(ThemeMode.system);
  }
  return AppThemeNotifier(isLightTheme ? ThemeMode.light : ThemeMode.dark);
});
