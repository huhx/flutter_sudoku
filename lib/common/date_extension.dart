import 'package:intl/intl.dart';

extension DateExtension on DateTime {
  String get toDateTimeString {
    return DateFormat("yyyy-MM-dd hh:mm:ss").format(this);
  }
}
