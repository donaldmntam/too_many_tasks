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
    switch (this) {
      case DueToday():
        return other is DueToday;
      case Paused():
        return other is Paused;
      case Overdue():
        return other is Overdue;
      default:
        return false;
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
        return (task) => task.dueDate.isBefore(today);
    }
  }
}
