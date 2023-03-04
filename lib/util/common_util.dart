import 'package:vibration/vibration.dart';

class CommonUtil {
  static Future<void> vibrateWarn() async {
    final bool? canVibration = await Vibration.hasVibrator();
    if (canVibration != null && canVibration) {
      await Vibration.vibrate(duration: 100);
    }
  }
}
