import 'package:too_many_tasks/common/models/task.dart';

sealed class TasksState {
  TasksState copy();
}

final class TasksStart implements TasksState {
  const TasksStart();

  @override
  TasksStart copy() => const TasksStart();
}

final class TasksLoading implements TasksState {
  const TasksLoading();

  @override
  TasksLoading copy() => const TasksLoading();
}

final class TasksReady implements TasksState {
  final List<Task> tasks;

  const TasksReady({
    required this.tasks
  });

  @override
  TasksReady copy() => TasksReady(
    tasks: tasks.toList(),
  );
}

final class TasksFailedToLoad implements TasksState {
  const TasksFailedToLoad();

  @override
  TasksFailedToLoad copy() => const TasksFailedToLoad();
}
