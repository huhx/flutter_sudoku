extension ListExtension<T> on List<T> {
  T? get firstOrNull {
    return isEmpty ? null : first;
  }

  T? get lastOrNull {
    return isEmpty ? null : last;
  }

  List<T> addOrRemove(T value) {
    if (contains(value)) {
      remove(value);
    } else {
      add(value);
    }
    return this;
  }

  Map<K, List<T>> groupBy<K>(K Function(T element) keyOf) {
    var result = <K, List<T>>{};
    for (final T element in this) {
      (result[keyOf(element)] ??= []).add(element);
    }
    return result;
  }

  Iterable<R> mapIndexed<R>(R Function(int index, T element) convert) sync* {
    for (int index = 0; index < length; index++) {
      yield convert(index, this[index]);
    }
  }
}
