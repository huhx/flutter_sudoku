class Result {
  Result._();

  factory Result.loading() = _Loading;

  factory Result.error(String errorTest) = _Error;

  factory Result.success() = _Success;

  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(String errorTest) error,
    required TResult Function() success,
  }) {
    throw UnsupportedError("Class extends ResultState must implement when method");
  }
}

class _Loading extends Result {
  _Loading() : super._();

  @override
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(String errorTest) error,
    required TResult Function() success,
  }) {
    return loading();
  }
}

class _Error extends Result {
  final String errorTest;

  _Error(this.errorTest) : super._();

  @override
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(String errorTest) error,
    required TResult Function() success,
  }) {
    return error(errorTest);
  }
}

class _Success extends Result {
  _Success() : super._();

  @override
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(String errorTest) error,
    required TResult Function() success,
  }) {
    return success();
  }
}
