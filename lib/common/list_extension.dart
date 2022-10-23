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
}
