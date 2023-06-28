extension ExtendedIterable<T> on Iterable<T> {
  int countIf(bool Function(T e) predicate) {
    int count = 0;
    for (final e in this) {
      if (predicate(e)) count++;
    }
    return count;
  }
}