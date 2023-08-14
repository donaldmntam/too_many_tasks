import 'package:too_many_tasks/common/models/task.dart';

bool validTask({
  required String name,
  required DateTime? dueDate,
}) {
  return name.isNotEmpty && dueDate != null;
}