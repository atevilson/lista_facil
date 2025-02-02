sealed class Result<T> {
  const Result();

  const factory Result.ok(T data) = Ok._;

  const factory Result.error(Exception exception) = Error._;
}

final class Ok<T> extends Result<T> {
  const Ok._(this.data);

  final T data;

  @override
  String toString() => 'Result<$T>.ok($data)';
}

final class Error<T> extends Result<T> {
  const Error._(this.exception);

  final Exception exception;

  @override
  String toString() => 'Result<$T>.error($exception)';
}
