sealed class Loadable<T> {}

final class Loading implements Loadable<Never> {
  const Loading();
}

final class Error implements Loadable<Never> {
  final Object? error;

  const Error(this.error);

  Error copy([Object? error]) => Error(error ?? this.error);
}

final class Ready<T> implements Loadable<T> {
  final T value;

  const Ready(this.value);

  Ready<T> copy([T? value]) => Ready(value ?? this.value);
}
