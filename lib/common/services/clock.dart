abstract interface class Calendar {
  DateTime now();
  DateTime today();
}

class DefaultClock implements Calendar {
  const DefaultClock();

  @override
  DateTime now() => DateTime.now();

  @override
  DateTime today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }
}