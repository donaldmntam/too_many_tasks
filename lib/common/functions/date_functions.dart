extension ExtendedDateTime on DateTime {
  String toFormattedString() {
    final monthString = month.toString().padLeft(2, "0");
    final dayString = day.toString().padLeft(2, "0");
    return "$year-$monthString-$dayString";
  }

  bool isSameDayAs(DateTime other) {
    return year == other.year &&
      month == other.month &&
      day == other.day;
  }
}
