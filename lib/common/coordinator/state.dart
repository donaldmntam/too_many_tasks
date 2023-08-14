import 'package:too_many_tasks/common/models/loadable.dart';
import 'package:too_many_tasks/common/models/task.dart';
import 'package:too_many_tasks/common/models/task_preset.dart';

class State {
  final Loadable<TaskPresets> taskPresets;
  final Loadable<TaskStates> taskStates;

  const State({
    required this.taskPresets,
    required this.taskStates,
  });

  State copy({
    Loadable<TaskPresets>? taskPresets,
    Loadable<TaskStates>? taskStates,
  }) => State(
    taskPresets: taskPresets ?? this.taskPresets,
    taskStates: taskStates ?? this.taskStates,
  );
}
