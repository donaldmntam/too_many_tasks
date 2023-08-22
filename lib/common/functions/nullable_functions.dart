import 'package:too_many_tasks/common/monads/optional.dart';

extension ExtendedNullable<T> on T? {
  R? map<R>(R Function(T) transform) {
    final value = this;
    if (value == null) return null;
    return transform(value);
  }

  Optional<T> toOptional() {
    final value = this;
    if (value == null) return Optional.none;
    return Optional.some(value);
  }
}