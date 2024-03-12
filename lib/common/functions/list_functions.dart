extension ExtendedList<T> on List<T> {
  @Deprecated("Use addBetween instead")
  void insertInBetween(T Function(int index) builder) {
    final length = this.length;
    for (var i = 0; i < length - 1; i++) {
      insert(i * 2 + 1, builder(i));
    }
  }

  void addMultiple(int count, T Function(int index) builder) {
    for (var i = 0; i < count; i++) {
      add(builder(i));
    }
  }

  List<T> surroundEach(T Function(int index) builder) {
    final length = this.length;
    final newList = List<T>.empty(growable: true);
    for (var i = 0; i < length; i++) {
      if (i == 0) newList.add(builder(i));
      newList.add(this[i]);
      newList.add(builder(i + 1));
    }
    return newList;
  }
}
