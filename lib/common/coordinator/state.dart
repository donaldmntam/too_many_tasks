import 'package:too_many_tasks/common/coordinator/typedefs.dart';
import 'tasks_state.dart' as tasks;
import 'presets_state.dart' as presets;

class State {
  // TODO: add preset before presets are loaded?
  presets.State presetsState;
  tasks.State tasksState;
  final TaskListMasterPort taskListMasterPort;
  TaskListSlavePort taskListSlavePort;

  State({
    required this.presetsState,
    required this.tasksState,
    required this.taskListMasterPort,
    required this.taskListSlavePort,
  });

  State copy() => State(
    presetsState: presetsState.copy(),
    tasksState: tasksState.copy(),
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