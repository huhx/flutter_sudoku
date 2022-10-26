import 'package:shared_preferences/shared_preferences.dart';

class PrefsUtil {
  static late SharedPreferences prefs;
  static const isLightTheme = "app.theme.light";
  static const cookieKey = "cookie";
  static const startTimeKey = "start.time";
  static const playSoundKey = "play_sound";

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
  

  static void saveIsPlaySound(bool isPlaySound) {
    prefs.setBool(playSoundKey, isPlaySound);
  }

  static bool getIsPlaySound() {
    return prefs.getBool(playSoundKey) ?? true;
  }
}
