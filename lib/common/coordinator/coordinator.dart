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
import 'package:too_many_tasks/common/widgets/task_dialog/types.dart' as task_dialog;
import 'package:too_many_tasks/common/monads/optional.dart';
import 'package:too_many_tasks/common/functions/iterable_functions.dart';

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
  late int _nextAvailableTaskId;

  @override
  void initState() {
    _state = const State(
      taskPresets: Loading(),
      taskStates: Loading(),
    );
    super.initState();
    _loadDataFromSharedPrefs();
  }

  Future<void> _persistData() async {
    final state = _state;
    final taskStates = state.taskStates;
    if (taskStates is! Ready<TaskStates>) return;
    await widget.sharedPrefs
      .setTasksWithTaskStates(taskStates.value);
    await widget.sharedPrefs
      .setNextAvailableTaskId(_nextAvailableTaskId);
  }

  void _loadDataFromSharedPrefs() async {
    final state = _state;
    final tasksState = state.taskStates;
    if (tasksState is! Loading) illegalState(state, "_loadTasks");
      
    final loadTasksResult = await widget.sharedPrefs.getTasks();
    if (loadTasksResult is Err) {
      _didFailToLoadFromSharedPrefs(loadTasksResult.value);
      return;
    }

    final loadNextAvailableTaskIdResult = await widget.sharedPrefs
      .getNextAvailableTaskId();
    if (loadNextAvailableTaskIdResult is Err) {
      _didFailToLoadFromSharedPrefs(loadNextAvailableTaskIdResult.value);
    }

    _didLoadDataFromSharedPrefs(
      loadNextAvailableTaskIdResult.unwrap().fold(() => 0),
      loadTasksResult.unwrap(),
    );
  }
  
  void _didLoadDataFromSharedPrefs(
    int nextAvailableTaskId,
    IList<Task> loadedTasks,
  ) {
    final state = _state;
    final tasks = state.taskStates;
    if (tasks is! Loading) illegalState(state, "_tasksDidLoad");
    final newTasks = loadedTasks
      .map<TaskState>((t) => (task: t, removed: false))
      .toIList();
    final newState = state.copy(
      taskStates: Ready(newTasks),
    );
    _state = newState;
    _nextAvailableTaskId = nextAvailableTaskId;
    setState(() {});
  }

  void _didFailToLoadFromSharedPrefs(Object? error) {
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

  void _addTask(task_dialog.Result dialogResult) {
    final state = _state;
    final taskStates = state.taskStates; 
    final Task task = (
      id: _nextAvailableTaskId,
      name: dialogResult.name,
      dueDate: dialogResult.dueDate,
      done: dialogResult.done,
      pinned: dialogResult.pinned,
    );
    if (taskStates is! Ready<TaskStates>) illegalState(state, "_addTask");
    final newTaskStates = taskStates.copy(
      taskStates.value.add((task: task, removed: false))
    );
    final newState = state.copy(
      taskStates: newTaskStates,
    );
    _state = newState;
    setState(() {});
    _nextAvailableTaskId += 1;
    _persistData();
  }

  void _editTask(int id, task_dialog.Result dialogResult) {
    final state = _state;
    final taskStates = state.taskStates;
    if (taskStates is! Ready<TaskStates>) illegalState(state, "_editTask");
    final findResult = taskStates.value.find((t) => t.task.id == id);
    if (findResult is None) illegalState(state, "_editTask");
    final (_, taskState) = findResult.unwrap();
    if (taskState.removed) {
      illegalState(state, "_editTask");
    }
    final Task task = (
      id: _nextAvailableTaskId,
      name: dialogResult.name,
      dueDate: dialogResult.dueDate,
      done: dialogResult.done,
      pinned: dialogResult.pinned,
    );
    final newTaskStates = taskStates.copy(
      taskStates.value.replace(
        id, 
        (task: task, removed: false)
      )
    );
    final newState = state.copy(
      taskStates: newTaskStates,
    );
    _state = newState;
    setState(() {});
    _nextAvailableTaskId += 1;
    _persistData();
  }

  void _removeTask(int id) {
    final state = _state;
    final taskStates = state.taskStates;
    if (taskStates is! Ready<TaskStates>) illegalState(state, "_removeTask");
    final findResult = taskStates.value.find((t) => t.task.id == id);
    if (findResult is None) illegalState(state, "_removeTask");
    final (index, taskState) = findResult.unwrap();
    if (taskState.removed) illegalState(state, "_removeTask");
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
    _persistData();
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
    _persistData();
  }

  void _pinTask(int id) {
    final state = _state;
    final taskStates = state.taskStates;
    if (taskStates is! Ready<TaskStates>) illegalState(state, "_pinTask");
    final findResult = taskStates.value.find((t) => t.task.id == id);
    if (findResult is None) illegalState(state, "_pinTask");
    final (index, taskState) = findResult.unwrap();
    if (taskState.removed) illegalState(state, "_pinTask");
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
    _state = newState;
    setState(() {});
    _persistData();
  }

  void _bitch() {}

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
