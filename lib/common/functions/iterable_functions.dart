import 'package:too_many_tasks/common/monads/result.dart';
import 'package:too_many_tasks/common/monads/optional.dart';

extension ExtendedIterable<T> on Iterable<T> {
  int countIf(bool Function(T e) predicate) {
    int count = 0;
    for (final e in this) {
      if (predicate(e)) count++;
    }
    return count;
  }

  Iterable<TT> mapIndexed<TT>(TT Function(T e, int i) transform) {
    var i = 0;
    return map((e) { 
      final transformed = transform(e, i);
      i++;
      return transformed;
    });
  }

  Optional<(int, T)> find(bool Function(T e) predicate) {
    var i = 0;
    for (final e in this) {
      if (predicate(e)) return Optional.some((i, e));
      i++;
    }
    return Optional.none;
  }
}

extension ExtendedResultIterable<T> on Iterable<Result<T>> {
  Result<List<T>> flattenResults() {
    final list = List<T>.empty(growable: true);
    for (final result in this) {
      switch (result) {
        case Ok():
          list.add(result.value);
        case Err():
          return result;
      }
    }
    return Result.ok(list);
  }
}
