import 'package:too_many_tasks/common/models/task.dart';

sealed class Filter {}
class DueToday implements Filter {
  const DueToday();
}
class Paused implements Filter {
  const Paused();
}
class Overdue implements Filter {
  const Overdue();
}

extension ExtendedFilter on Filter {
  bool isSameFilterAs(Filter other) {
    final self = this;
    if (self is DueToday && other is DueToday) return true;
    if (self is Paused && other is Paused) return true;
    if (self is Overdue && other is Overdue) return true;
    switch (this) {
      case DueToday():
        return other is DueToday;
      case Paused():
        return other is Paused;
      case Overdue():
        return other is Overdue;
    }
  }

  // TODO: localization
  String get title {
    switch (this) {
      case DueToday():
        return 'Due Today';
      case Paused():
        return 'Paused';
      case Overdue():
        return 'Overdue';
    }
  }

  bool Function(Task) predicate(DateTime today) {
    switch (this) {
      case DueToday():
        return (task) => task.dueDate.isAtSameMomentAs(today);
      case Paused():
        return (_) => false;
      case Overdue():
        return (task) => task.dueDate.isAfter(today);
    }
  }
}
