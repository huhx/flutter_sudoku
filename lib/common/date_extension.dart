import 'package:intl/intl.dart';

extension DateExtension on DateTime {
  String toDateString({String pattern = "yyyy-MM-dd"}) {
    return DateFormat(pattern).format(this);
  }
}
