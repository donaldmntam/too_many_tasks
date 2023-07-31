import 'package:too_many_tasks/common/models/task.dart';

sealed class Message {}

final class TasksDidLoad implements Message {
  const TasksDidLoad();
}

final class TasksDidFailToLoad implements Message {
  const TasksDidFailToLoad();
}

final class TaskSaved implements Message {
  final Task taskSaved;
  const TaskSaved({required this.taskSaved});
}
