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