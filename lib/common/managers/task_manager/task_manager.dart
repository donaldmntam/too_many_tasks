import 'dart:convert';

import 'package:too_many_tasks/common/functions/error_functions.dart';
import 'package:too_many_tasks/common/managers/task_manager/interface.dart';
import 'package:too_many_tasks/common/managers/task_manager/message.dart';
import 'package:too_many_tasks/common/models/task.dart';
import 'package:too_many_tasks/common/monads/result.dart';
import 'package:too_many_tasks/common/services/shared_preferences.dart';

import 'state.dart';
import 'typedefs.dart';

class TaskManagerImpl implements TaskManager {
  final SharedPreferences _sharedPrefs;

  final _listeners = List<Listener>.empty(growable: true);
  State _state = const Loading();

  TaskManagerImpl({
    required SharedPreferences sharedPrefs,
  }) : _sharedPrefs = sharedPrefs;

  void listen(Listener listener) {
    _listeners.add(listener);
  }

  void loadTasks() {
    final state = _state;
    if (state is! Start) badTransition(state, "loadTasks");
    const newState = Loading();
    _state = newState;
    _sharedPrefs.getString("tasks").then((string) {
      if (string == null) return _tasksDidLoad([]);
      final tasks = tasksFromJson(jsonDecode(string));
      switch (tasks) {
        case Ok(value: final tasks): _tasksDidLoad(tasks);
        case Err(value: final error): _tasksDidFailToLoad(error);
      }
    });
  }

  void _tasksDidLoad(List<Task> tasks) {
    final state = _state;
    if (state is! Loading) badTransition(state, "_tasksDidLoad");
    final newState = Ready(tasks: tasks);
    _state = newState;
    _listeners.send(const TasksDidLoad());
  }

  void _tasksDidFailToLoad(Object? error) {
    final state = _state;
    if (state is! Loading) badTransition(state, "_tasksDidFailToLoad");
    const newState = FailedToLoad();
    _state = newState;
    _listeners.send(const TasksDidFailToLoad());
    print(error);
  }
}

extension ExtendedListeners on List<Listener> {
  void send(Message message) {
    for (final listener in this) {
      listener(message);
    }
  }
}