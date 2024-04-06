import 'package:too_many_tasks/common/models/task.dart';
import 'package:too_many_tasks/common/functions/error_functions.dart';

sealed class Sort {}
class CreationDate implements Sort {
  const CreationDate();
}
class DueDate implements Sort {
  const DueDate();
}
class AscendingTaskName implements Sort {
  const AscendingTaskName();
}
class DescendingTaskName implements Sort {
  const DescendingTaskName();
}

extension ExtendedSort on Sort {
  bool isSameSortAs(Sort other) {
    switch (this) {
      case CreationDate():
        return other is CreationDate;
      case DueDate():
        return other is DueDate;
      case AscendingTaskName():
        return other is AscendingTaskName;
      case DescendingTaskName():
        return other is DescendingTaskName;
      default:
        return false;
    }
  }

  int Function(Task a, Task b) get comparator {
    switch (this) {
      case CreationDate():
        todo('need to add creation date to every task');
      case DueDate():
        return (Task a, Task b) => a.dueDate.millisecondsSinceEpoch
          - b.dueDate.millisecondsSinceEpoch;
      case AscendingTaskName():
        return (Task a, Task b) => 
          a.name.toLowerCase().compareTo(b.name.toLowerCase());
      case DescendingTaskName():
        return (Task a, Task b) => 
          b.name.toLowerCase().compareTo(a.name.toLowerCase());
    }
  }
}
