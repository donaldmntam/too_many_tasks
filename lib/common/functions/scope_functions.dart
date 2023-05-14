extension ExtendedNullableObject<T> on T {
  T also(void Function(T it) block) {
    block(this);
    return this;
  }
}