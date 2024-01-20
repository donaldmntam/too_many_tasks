sealed class Result<T> {
  const factory Result.ok(T value) = Ok;
  const factory Result.err(Object? value) = Err;  
}

final class Ok<T> implements Result<T> {
  final T value;
  
  const Ok(this.value);
}

final class Err implements Result<Never> {
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

  Result<R> map<R>(R Function(T) transform) {
    final result = this;
    switch (result) {
      case Ok(value: final value):
        return Result.ok(transform(value));
      case Err():
        return result;
    }
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

  R match<R>({required R Function(T) ok, required R Function(Object?) err}) {
    return switch (this) {
      Ok(value: final value) => ok(value),
      Err(value: final value) => err(value),
    };
  }

  String toPrettyString() {
    return switch (this) {
      Ok(value: final value) => 'Ok { $value }',
      Err(value: final value) => 'Err { $value }',
    };
  }
}
