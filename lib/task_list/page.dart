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
import 'package:too_many_tasks/task_list/functions/task_functions.dart';
import 'package:too_many_tasks/task_list/models/data.dart';
import 'package:too_many_tasks/task_list/models/message.dart';
import 'package:too_many_tasks/task_list/widgets/clipboard.dart';
import 'package:too_many_tasks/task_list/widgets/filter_button.dart';
import 'package:too_many_tasks/task_list/widgets/task_card/task_card.dart' as task_card;
import 'package:too_many_tasks/task_list/widgets/top/top.dart';
import 'state.dart' as page;
import 'widgets/ready_content/ready_content.dart' as ready;
import './widgets/loading_content.dart'as loading;

// TODO: animation when task is updated
// TODO: loading state

const _fabPadding = EdgeInsets.symmetric(horizontal: 24, vertical: 36);
const _fabSize = 54.0;
const _fabInnerPadding = 12.0;

class Page extends StatefulWidget {
  static topHeight(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return 150.0 + topPadding;
  }
  static const clipboardClipHeight = 60.0;
  static const clipboardClipOverlapHeight = 26.0;
  static const clipboardClipDanglingHeight = clipboardClipHeight 
    - clipboardClipOverlapHeight;
  static const clipboardBorderRadius = 24.0;
  static const clipboardOverlapHeight = clipboardClipHeight
    - clipboardClipOverlapHeight
    + clipboardBorderRadius;
  static const clipboardTopWidgetsHeight = 36.0;
  static const clipboardTopClearance = 
    clipboardClipOverlapHeight > clipboardTopWidgetsHeight
      ? clipboardOverlapHeight
      : clipboardTopWidgetsHeight;

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
  void onCheckMarkPressed(int index) {
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
        final taskToPin = newState.tasks[index];
        final newTask = taskToPin.copy(pinned: !taskToPin.pinned);
        newState.tasks[index] = newTask;
        this.state = newState;
        setState(() {});
      case page.Loading():
        badTransition(state, "onPinPressed");
    }
  }

  @override
  void onRemove(int index) {
    // final state = this.state;
    // switch (state) {
    //   case page.Ready():
    //     final newState = state.copy();
    //     if (taskIsPinned(index: index, pinnedCount: state.pinnedCount)) {
    //       newState.pinnedCount--;
    //     }
    //     print("removing at $index from list of length ${newState.tasks.length}");
    //     newState.tasks.removeAt(index);
    //     this.state = newState;
    //     setState(() {});
    //   case page.Loading():
    //     badTransition(state, "onRemove");
    // }
  }

  void onDataLoaded(Data data) {
    final state = this.state;
    switch (state) {
      case page.Loading():
        final newState = page.Ready(
          tasks: data.tasks.unlock,
          presets: data.presets.unlock,
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

  void _onFabTap() {
    final state = this.state;
    switch (state) {
      case page.Ready():
        showDialog(
          context: context,
          builder: (_) => TaskDialog(task: null, presets: state.presets.lock)
        ).then((task) => _onAddTask(task));
      case page.Loading():
        badTransition(state, "_onFabTap");
    }
  }

  void _onAddTask(Task task) {
    final state = this.state;
    switch (state) {
      case page.Ready():
        final newState = state.copy();
        newState.tasks.add(task);
        this.state = newState;
        setState(() {});
      case page.Loading():
        badTransition(state, "_onAddTask");
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = this.state;
    return Scaffold(
      body: LayoutBuilder(
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
                child: Clipboard(
                  height: constraints.maxHeight 
                    - Page.topHeight(context) 
                    + Page.clipboardOverlapHeight,
                  topRightChild: switch (state) {
                    page.Loading() => null,
                    page.Ready() => Padding(
                      padding: const EdgeInsets.only(
                        top: 12,
                        left: Page.clipboardBorderRadius,
                        right: Page.clipboardBorderRadius,
                      ),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        alignment: Alignment.centerRight,
                        child: FilterButton()
                      )
                    ),
                  },
                  child: switch (state) {
                    page.Loading() => loading.Content(state: state),
                    page.Ready() => ready.Content(
                      state: state,
                      listener: this,
                      fabClearance: _fabSize + _fabPadding.bottom,
                    ),
                  }
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: _fabPadding,
                  child: SizedBox.square(
                    dimension: _fabSize,
                    child: FloatingActionButton(
                      onPressed: _onFabTap,
                      child: const Icon(
                        Icons.add,
                        size: _fabSize - _fabInnerPadding
                      ),
                    )
                  ),
                )
              )
            ],
          );
        }
      )
    );
  }
}
