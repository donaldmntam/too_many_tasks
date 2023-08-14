import 'package:too_many_tasks/common/functions/iterable_functions.dart';
import 'package:too_many_tasks/common/models/task.dart';

extension ExtendedTasks on Iterable<Task> {
  double get progress {
    final length = this.length;
    if (length == 0) return 0;
    return countIf((e) => e.done) / length;
  }
}

extension ExtendedTaskStates on Iterable<TaskState> {
  double get progress {
    final length = this.length;
    if (length == 0) return 0;
    return countIf((e) => e.task.done) / length;
  }
}