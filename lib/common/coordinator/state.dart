import 'package:too_many_tasks/common/coordinator/typedefs.dart';
import 'package:too_many_tasks/common/models/loadable.dart';
import 'package:too_many_tasks/common/models/task.dart';
import 'package:too_many_tasks/common/models/task_preset.dart';

class State {
  final Loadable<TaskPresets> taskPresets;
  final Loadable<Tasks> tasks;

  const State({
    required this.taskPresets,
    required this.tasks,
  });

  State copy({
    Loadable<TaskPresets>? taskPresets,
    Loadable<Tasks>? tasks,
  }) => State(
    taskPresets: taskPresets ?? this.taskPresets,
    tasks: tasks ?? this.tasks,
  );
}
