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

List<R> diff<R, T>(
  Iterable<T> oldIterable,
  Iterable<T> newIterable,
  {required bool Function(T oldElement, T newElement) comparator,
  required R Function(T element) onAddition,
  required R Function(T element) onUnchanged,
  required R Function(T element) onDeletion}
) {
  final oldIterator = oldIterable.iterator;
  final newIterator = newIterable.iterator;

  final list = List<R>.empty(growable: true);
  var oldStart = 0;
  while (newIterator.moveNext()) {
    final newElement = newIterator.current;
    var oldIndex = oldStart;
    while (oldIterator.moveNext()) {
      final oldElement = oldIterator.current;
      final equal = comparator(oldElement, newElement);
      if (equal) {
        for (var i = oldStart; i < oldIndex - 1; i++) {
          list.add(onDeletion(oldElement));
        }
        list.add(onUnchanged(newElement));
        oldStart = oldIndex + 1;
        break;
      } else if (oldIndex == oldIterable.length) {
        list.add(onAddition(newElement));
        break;
      } else {
        oldIndex++;
      }
    }
  }
  return list;
}

