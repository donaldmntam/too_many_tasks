extension ExtendedObject<T> on T {
  T also(void Function(T it) block) {
    block(this);
    return this;
  }

  R let<R>(R Function(T it) block) {
    return block(this);
  }
}