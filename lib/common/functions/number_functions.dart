extension ExtendedDouble on double {
  double coerceAtLeast(double limit) {
    if (this < limit) return limit;
    return this;
  }

  double coerceAtMost(double limit) {
    if (this > limit) return limit;
    return this;
  }
}