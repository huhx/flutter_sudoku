extension StringExtension on String {
  int toInt({int? defaultValue}) {
    return int.tryParse(this) ?? defaultValue!;
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
