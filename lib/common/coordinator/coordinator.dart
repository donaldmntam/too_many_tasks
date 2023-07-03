import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:too_many_tasks/common/functions/error_functions.dart';
import 'package:too_many_tasks/common/models/task.dart';
import 'package:too_many_tasks/common/services/shared_preferences.dart';
import 'package:too_many_tasks/common/util_classes/channel/ports.dart';
import 'package:too_many_tasks/task_list/models/message.dart' as task_list;
import 'package:too_many_tasks/task_list/page.dart' as task_list;
import 'state.dart';

class Coordinator extends flutter.StatefulWidget {
  final SharedPreferences sharedPreferences;

  const Coordinator({
    super.key,
    required this.sharedPreferences,
  });

  static Coordinator of(flutter.BuildContext context) {
    final result = context.findAncestorWidgetOfExactType<Coordinator>();
    assert(result != null, 'No Services found in context');
    return result!;
  }
  
  @override
  flutter.State<flutter.StatefulWidget> createState() => _WidgetState();
}

class _WidgetState extends flutter.State<Coordinator> {
  late State state;

  @override
  void initState() {
    final (taskListMasterPort, taskListSlavePort) =
      ports<task_list.MasterMessage, task_list.SlaveMessage>();
    state = State(
      presets: null,
      taskListMasterPort: taskListMasterPort,
      taskListSlavePort: taskListSlavePort,
    );
    super.initState();
    loadPresets();
  }

  void loadPresets() async {
    await Future.delayed(const Duration(seconds: 2));
    // final presets = state.presets;
    // if (presets == null) {
    //   final encoded = await widget.sharedPreferences.getString("task_presets");
    //   encoded!; // TODO: error handling
    //   final decoded = tryJsonDecode(encoded).unwrap();
    //   t
    // }
    state.taskListMasterPort.transmit(
      task_list.DataInitialized(
        (
          presets: [
            (name: "Preset1")
          ].lock,
          tasks: [
            (name: "Task 1", dueDate: DateTime.now(), done: false),
            (name: "Task 1", dueDate: DateTime.now(), done: false),
            (name: "Task 1", dueDate: DateTime.now(), done: false),
            (name: "Task 1", dueDate: DateTime.now(), done: false),
            (name: "Task 1", dueDate: DateTime.now(), done: false),
            (name: "Task 1", dueDate: DateTime.now(), done: false),
            (name: "Task 1", dueDate: DateTime.now(), done: false),
            (name: "Task 1", dueDate: DateTime.now(), done: false),
            (name: "Task 1", dueDate: DateTime.now(), done: false),
            (name: "Task 1", dueDate: DateTime.now(), done: false),
            (name: "Task 1", dueDate: DateTime.now(), done: false),
            (name: "Task 1", dueDate: DateTime.now(), done: false),
            (name: "Task 1", dueDate: DateTime.now(), done: false),
            (name: "Task 1", dueDate: DateTime.now(), done: false),
            (name: "Task 1", dueDate: DateTime.now(), done: false),
            (name: "Task 1", dueDate: DateTime.now(), done: false),
            (name: "Task 1", dueDate: DateTime.now(), done: false),
            (name: "Task 1", dueDate: DateTime.now(), done: false),
            (name: "Task 1", dueDate: DateTime.now(), done: false),
            (name: "Task 1", dueDate: DateTime.now(), done: false),
          ].lock,
        )
      )
    );
  }

  void handleTaskListMessage(task_list.SlaveMessage message) {
    switch (message) {
      case task_list.AddPreset(preset: final preset):
        final presets = state.presets;
        if (presets == null) {
          badTransition(
            state,
            "task_list.AddPreset"
          );
        }
        presets.add(preset);
        setState(() {});
    }
  }

  void addPreset(TaskPreset preset) {
    final state = this.state;
    
  }

  @override
  flutter.Widget build(flutter.BuildContext context) {
    return task_list.Page(
      slavePort: state.taskListSlavePort,
    );
  }
}