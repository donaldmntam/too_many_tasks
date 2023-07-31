import 'package:too_many_tasks/common/models/task.dart';

sealed class State {}

final class Loading implements State {
  const Loading();
}

final class Ready implements State {
  final List<Task> tasks;

  const Ready({
    required this.tasks
  });

  Ready copy() => Ready(
    tasks: tasks.toList(),
  );
}

final class Saving implements State {
  final List<Task> tasks;
  final List<Task> taskBeingSaved;
  final List<Task> tasksToSave;

  const Saving({
    required this.tasks,
    required this.taskBeingSaved,
    required this.tasksToSave,
  });

  Saving copy() => Saving(
    tasks: tasks.toList(),
    taskBeingSaved: taskBeingSaved,
    tasksToSave: tasksToSave.toList(),
  );
}
