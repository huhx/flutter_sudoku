import 'package:flutter_sudoku/model/sudoku_config.dart';
import 'package:flutter_sudoku/model/sudoku_tip.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsUtil {
  static late SharedPreferences prefs;
  static const isLightTheme = "app.theme.light";
  static const cookieKey = "cookie";
  static const startTimeKey = "start.time";
  static const playSoundKey = "play_sound";
  static const tipLevelKey = "tip_level";

  static Future init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static void setStartTime(int timestamp) async {
    await prefs.setInt(startTimeKey, timestamp);
  }

  static int? getStartTime() {
    return prefs.getInt(startTimeKey);
  }

  static void saveIsLightTheme(bool isLight) {
    prefs.setBool(isLightTheme, isLight);
  }

  static bool? getIsLightTheme() {
    return prefs.getBool(isLightTheme);
  }

  static Future<void> removeKey(String key) async {
    await prefs.remove(key);
  }

  static void enablePlaySound(bool enable) {
    prefs.setBool(playSoundKey, enable);
  }

  static bool isPlaySound() {
    return prefs.getBool(playSoundKey) ?? true;
  }

  static TipLevel getTipLevel() {
    final String? levelString = prefs.getString(tipLevelKey);
    if (levelString == null) {
      return sudokuConfig.tipLevel;
    }
    return TipLevel.values.byName(levelString);
  }

  static void setTipLevel(TipLevel tipLevel) {
    prefs.setString(tipLevelKey, tipLevel.name);
  }
}
