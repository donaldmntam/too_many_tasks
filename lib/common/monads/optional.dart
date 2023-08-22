sealed class Optional<T> {
  const factory Optional.some(T value) = Some;  
  static const none = None();
}

final class Some<T> implements Optional<T> {
  final T value;

  const Some(this.value);
}

final class None implements Optional<Never> {
  const None();
}

extension ExtendedOptional<T> on Optional<T> {
  T unwrap() {
    return switch (this) {
      Some(value: final value) => value,
      None() => throw "Optional was unwrapped when it was a None",
    };
  }

  T fold(T Function() onNone) {
    return switch (this) {
      Some(value: final value) => value,
      None() => onNone(),
    };
  }

  Optional<R> map<R>(R Function(T) transform) {
    switch (this) {
      case Some(value: final value):
        return Some(transform(value));
      case None():
        return Optional.none;
    }
  }

  Optional<R> flatMap<R>(Optional<R> Function(T) transform) {
    switch (this) {
      case Some(value: final value):
        return transform(value);
      case None():
        return Optional.none;
    }
  } 
}