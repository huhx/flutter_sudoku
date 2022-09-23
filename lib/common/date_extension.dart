import 'package:intl/intl.dart';

extension DateExtension on DateTime {
  String toDateString({String pattern = "yyyy-MM-dd"}) {
    return DateFormat(pattern).format(this);
  }

  bool isSameDay(DateTime dateTime) {
    return year == dateTime.year && month == dateTime.month && day == dateTime.day;
  }

  DateTime toDate() {
    return DateTime(year, month, day);
  }
}