import 'package:intl/intl.dart';

extension IntExtension on int {
  String toDateString({String dateFormat = "yyyy-MM-dd"}) {
    return DateFormat(dateFormat).format(DateTime.fromMillisecondsSinceEpoch(this));
  }

  String get toTimeString  {
    final int second = this % 60;
    final int minute = (this / 60).floor();

    final String secondString = second < 10 ? "0$second" : "$second";
    final String minuteString = minute < 10 ? "0$minute" : "$minute";
    return "$minuteString:$secondString";
  }
}
