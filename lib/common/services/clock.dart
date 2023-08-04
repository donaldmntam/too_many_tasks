abstract interface class Calendar {
  DateTime now();
  DateTime today();
}

class DefaultCalendar implements Calendar {
  const DefaultCalendar();

  @override
  DateTime now() => DateTime.now();

  @override
  DateTime today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }
}