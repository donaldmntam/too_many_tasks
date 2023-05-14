abstract interface class Clock {
  DateTime now();
}

class DefaultClock implements Clock {
  const DefaultClock();

  @override
  DateTime now() => DateTime.now();
}