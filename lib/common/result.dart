class ResultState {
  ResultState._();

  factory ResultState.loading() = _Loading;

  factory ResultState.error(String errorTest) = _Error;

  factory ResultState.success() = _Success;

  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(String errorTest) error,
    required TResult Function() success,
  }) =>
      throw UnsupportedError("Class extends ResultState must implement when method");
}

class _Loading extends ResultState {
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

class _Error extends ResultState {
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

class _Success extends ResultState {
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
