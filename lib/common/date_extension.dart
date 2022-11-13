import 'package:intl/intl.dart';

extension DateExtension on DateTime {
  String toDateString({String pattern = "yyyy-MM-dd"}) {
    return DateFormat(pattern).format(this);
  }

  bool isSameDay(DateTime dateTime) {
    return year == dateTime.year && month == dateTime.month && day == dateTime.day;
  }

  DateTime get toDate => DateTime(year, month, day);

  String get toDateTimeString {
    return DateFormat("yyyy-MM-dd hh:mm:ss").format(this);
  }

  DateTime get previous => add(const Duration(days: -1));

  DateTime get next => add(const Duration(days: 1));
}
