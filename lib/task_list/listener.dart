import 'package:too_many_tasks/common/models/task.dart';

typedef PageListener = ({
  void Function(int index) onCheckTask,
  void Function(int index) onPinTask,
  void Function(int index, Task task) onEditTask,
  void Function(int index) onRemoveTask,
  void Function(Task task) onAddTask,
});

extension ExtendedPageListener on PageListener {
  PageListener copy({
    void Function(int index)? onCheckTask,
    void Function(int index)? onPinTask,
    void Function(int index, Task task)? onEditTask,
    void Function(int index)? onRemoveTask,
    void Function(Task task)? onAddTask,
  }) => (
    onCheckTask: onCheckTask ?? this.onCheckTask,
    onPinTask: onPinTask ?? this.onPinTask,
    onEditTask: onEditTask ?? this.onEditTask,
    onRemoveTask: onRemoveTask ?? this.onRemoveTask,
    onAddTask: onAddTask ?? this.onAddTask,
  );
}
