import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:too_many_tasks/common/models/task.dart';

sealed class State {}

class Loading implements State {
  const Loading();

  Loading copy() => const Loading(); 
}

class Ready implements State {
  final List<TaskPreset> presets;
  final List<Task> tasks;

  Ready({
    required this.presets,
    required this.tasks,
  });

  Ready copy() => Ready(
    presets: presets,
    tasks: tasks.toList(growable: true),
  );
}