import 'package:too_many_tasks/common/functions/iterable_functions.dart';
import 'package:too_many_tasks/common/models/task.dart';

extension ExtendedTasks on List<Task> {
  double get progress => countIf((e) => e.done) / length;
}