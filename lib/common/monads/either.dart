sealed class Either<L, R> {}

final class Left<T> implements Either<T, Never> {
  final T value;
  
  const Left(this.value);
}

final class Right<T> implements Either<Never, T> {
  final T value;

  const Right(this.value);
}