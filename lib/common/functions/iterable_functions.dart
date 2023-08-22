import 'package:too_many_tasks/common/monads/result.dart';

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
