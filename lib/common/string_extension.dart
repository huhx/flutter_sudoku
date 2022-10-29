import 'package:intl/intl.dart';

extension StringExtension on String {
  int toInt({int? defaultValue}) {
    return int.tryParse(this) ?? defaultValue!;
  }

   DateTime toDate({String pattern = "yyyy-MM-dd"}) {
    return DateFormat(pattern).parse(this);
  }

  List<String> chunk(int chunkSize) {
    assert(chunkSize > 0);
    final int chunkCount = (length / chunkSize).ceil();

    return List<String>.generate(chunkCount, (index) {
      final sliceStart = index * chunkSize;
      final sliceEnd = sliceStart + chunkSize;
      return substring(sliceStart, (sliceEnd < length) ? sliceEnd : length);
    });
  }
}
