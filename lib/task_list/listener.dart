import 'package:too_many_tasks/common/widgets/task_dialog/types.dart' as task_dialog;

typedef PageListener = ({
  void Function(int id) onCheckTask,
  void Function(int id) onPinTask,
  void Function(int id, task_dialog.Result dialogResult) onEditTask,
  void Function(int id) onRemoveTask,
  void Function(task_dialog.Result dialogResult) onAddTask,
  void Function() bitch,
});

extension ExtendedPageListener on PageListener {
  PageListener copy({
    void Function(int id)? onCheckTask,
    void Function(int id)? onPinTask,
    void Function(int id, task_dialog.Result dialogResult)? onEditTask,
    void Function(int id)? onRemoveTask,
    void Function(task_dialog.Result dialogResult)? onAddTask,
    void Function()? bitch,
  }) => (
    onCheckTask: onCheckTask ?? this.onCheckTask,
    onPinTask: onPinTask ?? this.onPinTask,
    onEditTask: onEditTask ?? this.onEditTask,
    onRemoveTask: onRemoveTask ?? this.onRemoveTask,
    onAddTask: onAddTask ?? this.onAddTask,
    bitch: bitch ?? this.bitch,
  );
}
