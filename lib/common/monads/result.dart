sealed class Result<T> {}

final class Ok<T> implements Result<T> {
  final T value;
  
  const Ok(this.value);
}

final class Err<T> implements Result<Never> {
  final Object? value;

  const Err(this.value);
}

extension ExtendedResult<T> on Result<T> {
  T unwrap() {
    return switch (this) {
      Ok(value: final value) => value,
      Err(value: final value) => throw "Result was unwrapped when it was"
        " an Err. The wrapped value was: $value"
    };
  }

  Result<R> flatMap<R>(Result<R> Function(T) transform) {
    final result = this;
    switch (result) {
      case Ok(value: final value):
        return transform(value);
      case Err():
        return result;
    }
  }

  void then(Object? )
}