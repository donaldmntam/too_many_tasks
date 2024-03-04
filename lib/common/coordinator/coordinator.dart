import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:too_many_tasks/common/functions/error_functions.dart';
import 'package:too_many_tasks/common/models/loadable.dart';
import 'package:too_many_tasks/common/models/task.dart';
import 'package:too_many_tasks/common/monads/result.dart';
import 'package:too_many_tasks/common/services/app_cycle_message_stream.dart';
import 'package:too_many_tasks/common/services/services.dart';
import 'package:too_many_tasks/common/services/shared_preferences.dart';
import 'package:too_many_tasks/task_list/models/message.dart' as task_list;
import 'package:too_many_tasks/task_list/page.dart' as task_list;
import 'functions.dart';
import 'state.dart';

class Coordinator extends flutter.StatefulWidget {
  final SharedPreferences sharedPrefs;

  const Coordinator({
    super.key,
    required SharedPreferences sharedPreferences,
  }) : sharedPrefs = sharedPreferences;

  static Coordinator of(flutter.BuildContext context) {
    final result = context.findAncestorWidgetOfExactType<Coordinator>();
    assert(result != null, 'No Services found in context');
    return result!;
  }
  
  @override
  flutter.State<flutter.StatefulWidget> createState() => _WidgetState();
}

class _WidgetState extends flutter.State<Coordinator> {
  late State _state;

  @override
  void initState() {
    _state = const State(
      taskPresets: Loading(),
      taskStates: Loading(),
    );
    super.initState();
    _loadTasks();
  }

  Future<void> _saveTasksToSharedPrefs() async {
    final state = _state;
    final taskStates = state.taskStates;
    if (taskStates is! Ready<TaskStates>) return;
    final result = await widget.sharedPrefs
      .setTasksWithTaskStates(taskStates.value);
    print('result here! ${result.toPrettyString()}');
  }

  void _loadTasks() async {
    final state = _state;
    final tasksState = state.taskStates;
    if (tasksState is! Loading) illegalState(state, "_loadTasks");
    (await widget.sharedPrefs.getTasks()).match(
      ok: _tasksDidLoad,
      err: _tasksDidFailToLoad
    );
  }
  
  void _tasksDidLoad(IList<Task> loadedTasks) {
    print('tasks did load here! ${loadedTasks.length}');
    final state = _state;
    final tasks = state.taskStates;
    if (tasks is! Loading) illegalState(state, "_tasksDidLoad");
    // final newTasksState = tasks.TasksReady(tasks: loadedTasks);
    final newTasksHardcoded = Ready(
      <Task>[
        (name: "Task 1", dueDate: DateTime.now(), done: false, pinned: false),
        (name: "Task 2", dueDate: DateTime.now(), done: false, pinned: false),
        (name: "Task 3", dueDate: DateTime.now(), done: false, pinned: false),
        // (name: "Task 4", dueDate: DateTime.now(), done: false, pinned: false),
        // (name: "Task 5", dueDate: DateTime.now(), done: false, pinned: false),
        // (name: "Task 6", dueDate: DateTime.now(), done: false, pinned: false),
        // (name: "Task 7", dueDate: DateTime.now(), done: false, pinned: false),
        // (name: "Task 8", dueDate: DateTime.now(), done: false, pinned: false),
      ].map<TaskState>((task) => (task: task, removed: false)).toIList(),
    );
    final newTasks = loadedTasks
      .map<TaskState>((t) => (task: t, removed: false))
      .toIList();
    final newState = state.copy(
      taskStates: Ready(newTasks),
    );
    _state = newState;
    setState(() {});
  }

  void _tasksDidFailToLoad(Object? error) {
    final state = _state;
    final tasks = state.taskStates;
    if (tasks is! Loading) {
      illegalState(state, "_tasksDidFailToLoad");
    }
    final newTasks = Error(error);
    final newState = state.copy(
      taskStates: newTasks,
    );    
    _state = newState;
    setState(() {});
  }

  // void _loadTasks() {
  //   final encodedTasks = await 
  //   if (encodedTasks == null) {

  //   }
  //   // final presets = state.presets;
  //   // if (presets == null) {
  //   //   final encoded = await widget.sharedPreferences.getString("task_presets");
  //   //   encoded!; // TODO: error handling
  //   //   final decoded = tryJsonDecode(encoded).unwrap();
  //   //   t
  //   // }
  //   _state.taskListMasterPort.transmit(
  //     task_list.DataInitialized(
  //       (
  //         presets: <({String name})>[
  //           // (name: "Preset1")
  //         ].lock,
  //         tasks: [
  //           (name: "Task 1", dueDate: DateTime.now(), done: false, pinned: false),
  //           (name: "Task 2", dueDate: DateTime.now(), done: false, pinned: false),
  //           (name: "Task 3", dueDate: DateTime.now(), done: false, pinned: false),
  //           (name: "Task 4", dueDate: DateTime.now(), done: false, pinned: false),
  //           (name: "Task 5", dueDate: DateTime.now(), done: false, pinned: false),
  //           (name: "Task 6", dueDate: DateTime.now(), done: false, pinned: false),
  //           (name: "Task 7", dueDate: DateTime.now(), done: false, pinned: false),
  //           (name: "Task 8", dueDate: DateTime.now(), done: false, pinned: false),
  //         ].lock,
  //       )
  //     )
  //   );
  // }

  // void handleTaskListMessage(task_list.SlaveMessage message) {
  //   switch (message) {
  //     case task_list.AddPreset():
  //       _addPreset(message);
  //     case task_list.AddTask():
  //       _addTask(message);
  //   }
  // }

  void _addPreset(task_list.AddPreset message) {
    // final state = this._state;
    
  }

  void _addTask(Task task) {
    final state = _state;
    final taskStates = state.taskStates; 
    if (taskStates is! Ready<TaskStates>) illegalState(state, "_addTask");
    final newTaskStates = taskStates.copy(
      taskStates.value.add((task: task, removed: false))
    );
    final newState = state.copy(
      taskStates: newTaskStates,
    );
    _state = newState;
    setState(() {});
    _saveTasksToSharedPrefs();
  }

  void _editTask(int index, Task task) {
    final state = _state;
    final taskStates = state.taskStates;
    if (taskStates is! Ready<TaskStates>) illegalState(state, "_editTask");
    if (taskStates.value[index].removed) illegalState(state, "_editTask");
    final newTaskStates = taskStates.copy(
      taskStates.value.replace(
        index, 
        (task: task, removed: false)
      )
    );
    final newState = state.copy(
      taskStates: newTaskStates,
    );
    _state = newState;
    setState(() {});
    _saveTasksToSharedPrefs();
  }

  void _removeTask(int index) {
    final state = _state;
    final taskStates = state.taskStates;
    if (taskStates is! Ready<TaskStates>) illegalState(state, "_removeTask");
    if (taskStates.value[index].removed) illegalState(state, "_removeTask");
    final newTaskStates = taskStates.copy(
      taskStates.value.replaceBy(
        index,
        (taskState) => taskState.copy(removed: true),
      )
    );
    final newState = state.copy(
      taskStates: newTaskStates,
    );
    _state = newState;
    setState(() {});
    _saveTasksToSharedPrefs();
  }

  void _checkTask(int index) {
    final state = _state;
    final taskStates = state.taskStates;
    if (taskStates is! Ready<TaskStates>) illegalState(state, "_checkTask");
    if (taskStates.value[index].removed) illegalState(state, "_checkTask");
    final newState = state.copy(
      taskStates: taskStates.copy(
        taskStates.value.replaceBy(
          index,
          (taskState) => taskState.copyBy(
            task: (task) => task.copyBy(
              done: (done) => !done
            )
          )
        )
      ),
    );
    _state = newState;
    setState(() {});
    _saveTasksToSharedPrefs();
  }

  void _pinTask(int index) {
    final state = _state;
    final taskStates = state.taskStates;
    if (taskStates is! Ready<TaskStates>) illegalState(state, "_pinTask");
    if (taskStates.value[index].removed) illegalState(state, "_pinTask");
    print("tasks before pinning ${taskStates.value.join(",")}");
    final newState = state.copy(
      taskStates: taskStates.copy(
        taskStates.value.replaceBy(
          index,
          (taskState) => taskState.copyBy(
            task: (task) => task.copyBy(
              pinned: (pinned) => !pinned,
            )
          )
        )
      ),
    );
    print("tasks after pinning ${(newState.taskStates as Ready<TaskStates>).value.join(",")}");
    _state = newState;
    setState(() {});
    _saveTasksToSharedPrefs();
  }

  void _bitch() {
    final state = _state;
    final taskStates = state.taskStates;
    if (taskStates is! Ready<TaskStates>) illegalState(state, "_checkTask");
    final newState = state.copy(
      taskStates: taskStates.copy(
        taskStates.value.addAll(
          <TaskState>[
            (task: (name: "Task 1", dueDate: DateTime.now(), done: false, pinned: false), removed: true),
            (task: (name: "Task 2", dueDate: DateTime.now(), done: false, pinned: false), removed: true),
            (task: (name: "Task 3", dueDate: DateTime.now(), done: false, pinned: false), removed: true),
            (task: (name: "Task 4", dueDate: DateTime.now(), done: false, pinned: false), removed: true),
            (task: (name: "Task 5", dueDate: DateTime.now(), done: false, pinned: false), removed: true),
            (task: (name: "Task 6", dueDate: DateTime.now(), done: false, pinned: false), removed: true),
            (task: (name: "Task 7", dueDate: DateTime.now(), done: false, pinned: false), removed: true),
            (task: (name: "Task 8", dueDate: DateTime.now(), done: false, pinned: false), removed: true),
          ],
        )
      ),
    );
    _state = newState;
    setState(() {});
  }

  @override
  flutter.Widget build(flutter.BuildContext context) {
    return task_list.Page(
      taskStates: _state.taskStates,
      listener: (
        onAddTask: _addTask,
        onEditTask: _editTask,
        onRemoveTask: _removeTask,
        onCheckTask: _checkTask,
        onPinTask: _pinTask,
        bitch: _bitch,
      ),
    );
  }
}
