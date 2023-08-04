import 'package:too_many_tasks/common/models/task.dart';
import 'package:too_many_tasks/common/models/task_preset.dart';

sealed class State {}

final class Loading implements State {
  const Loading();
}

final class Ready implements State {
  final TaskPresets presets;
  final Tasks tasks;

  const Ready({
    required this.presets,
    required this.tasks,
  });

  Ready copy({
    TaskPresets? presets,
    Tasks? tasks,
  }) => Ready(
    presets: presets ?? this.presets,
    tasks: tasks ?? this.tasks,
  );
}