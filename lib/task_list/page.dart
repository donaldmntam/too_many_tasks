import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:too_many_tasks/common/functions/error_functions.dart';
import 'package:too_many_tasks/common/functions/scope_functions.dart';
import 'package:too_many_tasks/common/functions/tasks_functions.dart';
import 'package:too_many_tasks/common/models/task.dart';
import 'package:too_many_tasks/common/util_classes/channel/ports.dart';
import 'package:too_many_tasks/common/widgets/task_dialog/task_dialog.dart';
import 'package:too_many_tasks/task_list/controller.dart' as task_list;
import 'package:too_many_tasks/task_list/models/data.dart';
import 'package:too_many_tasks/task_list/models/message.dart';
import 'package:too_many_tasks/task_list/widgets/clip_board.dart';
import 'package:too_many_tasks/task_list/widgets/task_card.dart' as task_card;
import 'package:too_many_tasks/task_list/widgets/top/top.dart';
import 'state.dart' as page;
import './widgets/ready_content.dart' as ready;
import './widgets/loading_content.dart'as loading;

//  = List.generate(
//     10,
//     (index) => (
//       name: "Task ${index + 1}",
//       dueDate: DateTime(2023, 5, 10 + index),
//       done: true,
//     ),
//   ).lock;

// TODO: animation when task is updated
// TODO: loading state

class Page extends StatefulWidget {
  static topHeight(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return 150.0 + topPadding;
  }
  static const clipBoardClipHeight = 60.0;
  static const clipBoardClipOverlapHeight = 26.0;
  static const clipBoardBorderRadius = 24.0;
  static const clipBoardOverlapHeight = clipBoardClipHeight
    - clipBoardClipOverlapHeight
    + clipBoardBorderRadius;

  final SlavePort<MasterMessage, SlaveMessage> slavePort;

  const Page({
    super.key,
    required this.slavePort,
  });

  @override
  State<Page> createState() => _State();
}

class _State extends State<Page> implements task_card.Listener {
  page.State state = const page.Loading();
  
  @override
  void initState() {
    widget.slavePort.listen(_onMasterMessage);
    super.initState();
  }

  @override
  void onCheckmarkPressed(int index) {
    final state = this.state;
    switch (state) {
      case page.Ready():
        final newState = state.copy();
        final task = newState.tasks[index];
        newState.tasks[index] = task.copy(
          done: !task.done
        );
        this.state = newState;
        setState(() {});
      case page.Loading():
        badTransition(state, "onCheckmarkPressed");
    }
  }
  
  @override
  void onEditPressed(int index) async {
    final state = this.state;
    switch (state) {
      case page.Ready():
        final newTask = await showDialog(
          context: context,
          builder: (context) => TaskDialog(
            presets: state.presets.lock,
            task: state.tasks[index]
          )
        ) as Task?;
        if (newTask == null) break;
        final newState = state.copy();
        newState.tasks[index] = newTask;
        this.state = newState;
        setState(() {});
      case page.Loading():
        badTransition(state, "onEditPressed");
    }
  }
  
  @override
  void onPinPressed(int index) {
    final state = this.state;
    switch (state) {
      case page.Ready():
        final newState = state.copy();
        final taskToPin = newState.tasks.removeAt(index);
        newState.tasks.insert(state.pinnedCount, taskToPin);
        newState.pinnedCount++;
        this.state = newState;
        setState(() {});
      case page.Loading():
        badTransition(state, "onPinPressed");
    }
  }

  void onDataLoaded(Data data) {
    final state = this.state;
    switch (state) {
      case page.Loading():
        final newState = page.Ready(
          tasks: data.tasks.unlock,
          presets: data.presets.unlock,
          pinnedCount: 0,
        );
        setState(() => this.state = newState);
      case page.Ready():
        badTransition(state, "dataDidLoad");
    }
  }

  void _onMasterMessage(MasterMessage message) {
    switch (message) {
      case DataInitialized(data: final data):
        onDataLoaded(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = this.state;
    return Scaffold(
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: double.infinity,
                    height: Page.topHeight(context),
                    child: Top(
                      progress: switch (state) {
                        page.Loading() => null,
                        page.Ready(tasks: final tasks) => tasks.progress,
                      }
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ClipBoard(
                    height: constraints.maxHeight 
                      - Page.topHeight(context) 
                      + Page.clipBoardOverlapHeight,
                    child: switch (state) {
                      page.Loading() => loading.Content(state: state),
                      page.Ready() => ready.Content(state: state, listener: this),
                    }
                  ),
                ),
              ],
            );
          }
        )
      )
    );
  }
}