import 'package:too_many_tasks/common/models/task.dart';

typedef PageListener = ({
  void Function(int index) onCheckTask,
  void Function(int index) onPinTask,
  void Function(int index, Task task) onEditTask,
  void Function(int index) onRemoveTask,
  void Function(Task task) onAddTask,
});