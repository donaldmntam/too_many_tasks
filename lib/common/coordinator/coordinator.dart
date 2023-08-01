import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:too_many_tasks/common/functions/error_functions.dart';
import 'package:too_many_tasks/common/functions/json_functions.dart';
import 'package:too_many_tasks/common/models/task.dart';
import 'package:too_many_tasks/common/monads/result.dart';
import 'package:too_many_tasks/common/services/shared_preferences.dart';
import 'package:too_many_tasks/common/util_classes/channel/ports.dart';
import 'package:too_many_tasks/task_list/models/message.dart' as task_list;
import 'package:too_many_tasks/task_list/page.dart' as task_list;
import 'functions.dart';
import 'state.dart';
import 'tasks_state.dart' as tasks;
import 'presets_state.dart' as presets;

class Coordinator extends flutter.StatefulWidget {
  final SharedPreferences _sharedPrefs;

  const Coordinator({
    super.key,
    required SharedPreferences sharedPreferences,
  }) : _sharedPrefs = sharedPreferences;

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
    final (taskListMasterPort, taskListSlavePort) =
      ports<task_list.MasterMessage, task_list.SlaveMessage>();
    _state = State(
      presetsState: const presets.Start(),
      tasksState: const tasks.TasksStart(),
      taskListMasterPort: taskListMasterPort,
      taskListSlavePort: taskListSlavePort,
    );
    super.initState();
    _loadTasks();
  }

  void _loadTasks() async {
    final state = _state;
    final tasksState = state.tasksState;
    if (tasksState is! tasks.TasksStart) illegalState(state, "_loadTasks");
    const newTasksState = tasks.TasksLoading();
    final newState = state.copy();
    newState.tasksState = newTasksState;
    _state = newState;
    (await loadTasksFromSharedPrefs(widget._sharedPrefs)).match(
      ok: _tasksDidLoad,
      err: _tasksDidFailToLoad
    );
  }
  
  void _tasksDidLoad(List<Task> loadedTasks) {
    final state = _state;
    final tasksState = state.tasksState;
    if (tasksState is! tasks.TasksLoading) illegalState(state, "_tasksDidLoad");
    final newTasksState = tasks.TasksReady(tasks: loadedTasks);
    // final newTasksState = tasks.TasksReady(
    //   tasks: [
    //     (name: "Task 1", dueDate: DateTime.now(), done: false, pinned: false),
    //     (name: "Task 2", dueDate: DateTime.now(), done: false, pinned: false),
    //     (name: "Task 3", dueDate: DateTime.now(), done: false, pinned: false),
    //     (name: "Task 4", dueDate: DateTime.now(), done: false, pinned: false),
    //     (name: "Task 5", dueDate: DateTime.now(), done: false, pinned: false),
    //     (name: "Task 6", dueDate: DateTime.now(), done: false, pinned: false),
    //     (name: "Task 7", dueDate: DateTime.now(), done: false, pinned: false),
    //     (name: "Task 8", dueDate: DateTime.now(), done: false, pinned: false),
    //   ]
    // );
    final newState = state.copy();
    newState.tasksState = newTasksState;
    _state = newState;
    setState(() {});
  }

  void _tasksDidFailToLoad(Object? error) {
    final state = _state;
    final tasksState = state.tasksState;
    if (tasksState is! tasks.TasksLoading) {
      illegalState(state, "_tasksDidFailToLoad");
    }
    const newTasksState = tasks.TasksFailedToLoad();
    final newState = state.copy();
    newState.tasksState = newTasksState;
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
    final tasksState = state.tasksState;
    if (tasksState is! tasks.TasksReady) illegalState(state, "_addTask");
    final newTasksState = tasksState.copy();
    newTasksState.tasks.add(task);
    final newState = state.copy();
    newState.tasksState = newTasksState;
    _state = newState;
    setState(() {});
  }

  @override
  flutter.Widget build(flutter.BuildContext context) {
    return task_list.Page(
      // slavePort: _state.taskListSlavePort,
      tasksState: _state.tasksState,
      listener: (
        onAddTask: _addTask,
      ),
    );
  }
}