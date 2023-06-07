import 'package:too_many_tasks/common/coordinator/typedefs.dart';
import 'package:too_many_tasks/common/models/task.dart';
import 'package:too_many_tasks/common/util_classes/channel/ports.dart';
import 'package:too_many_tasks/task_list/models/message.dart' as task_list;

class State {
  List<TaskPreset>? presets;
  final TaskListMasterPort taskListMasterPort;
  TaskListSlavePort taskListSlavePort;

  State({
    required this.presets,
    required this.taskListMasterPort,
    required this.taskListSlavePort,
  });

  State copy() => State(
    presets: presets?.toList(growable: true),
    taskListMasterPort: taskListMasterPort,
    taskListSlavePort: taskListSlavePort,
  );
}

sealed class Page {
  Page copy();
}

// class TaskListPage implements Page {

//   TaskListPage(
//     this.controller,
//   );

//   @override
//   TaskListPage copy() => TaskListPage(
//     controller,
//   );
// }