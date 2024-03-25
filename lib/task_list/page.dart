import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart' hide BottomSheet, Theme;
import 'package:too_many_tasks/common/functions/error_functions.dart';
import 'package:too_many_tasks/common/functions/tasks_functions.dart';
import 'package:too_many_tasks/common/models/task.dart';
import 'package:too_many_tasks/common/widgets/task_dialog/task_dialog.dart';
import 'package:too_many_tasks/task_list/listener.dart';
import 'package:too_many_tasks/task_list/widgets/clipboard.dart';
import 'package:too_many_tasks/task_list/widgets/button.dart';
import 'package:too_many_tasks/task_list/widgets/top/top.dart';
import '../common/models/loadable.dart';
import 'widgets/ready_content/ready_content.dart' as ready;
import './widgets/loading_content.dart'as loading;
import 'package:too_many_tasks/common/models/filter.dart';
import 'package:too_many_tasks/common/overlay/bottom_sheet.dart';
import './widgets/menu/filter_menu.dart';
import 'package:too_many_tasks/common/overlay/service.dart';
import 'package:too_many_tasks/common/theme/theme.dart';
import 'dart:async';
import 'package:too_many_tasks/common/widgets/task_dialog/types.dart' as task_dialog;
import 'package:too_many_tasks/common/functions/iterable_functions.dart';
import 'package:too_many_tasks/common/monads/optional.dart';
import './widgets/menu/sort_menu.dart';
import 'package:too_many_tasks/common/models/sort.dart';

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

  final Loadable<TaskStates> taskStates;
  final PageListener listener;

  const Page({
    super.key,
    required this.taskStates,
    required this.listener,
  });

  @override
  State<Page> createState() => _State();
}

class _State extends State<Page> {
  Filter? filter;
  Sort sort = const DueDate();

  @override
  void initState() {
    super.initState();
  }

  void onFabTap() {
    final tasks = widget.taskStates;
    if (tasks is! Ready<TaskStates>) illegalState(widget.taskStates, "onFabTap");
    showDialog(
      context: context,
      builder: (_) => const TaskDialog(task: null, presets: IListConst([]))
    ).then((task) {
      if (task == null) return;
      widget.listener.onAddTask(task);
    });
  }

  void onEditTask(int id) async {
    final taskStates = widget.taskStates;
    if (taskStates is! Ready<TaskStates>) illegalState(widget.taskStates, "onEditTask");
    final (_, taskState) = taskStates.value.find((t) => t.task.id == id).unwrap();

    final newTask = (
      await showDialog(
        context: context,
        builder: (_) => TaskDialog(
          task: taskState.task,
          presets: const IListConst([]),
        ),
      )
    ) as task_dialog.Result?;
    if (newTask == null) return;
    widget.listener.onEditTask(id, newTask);
  }

  void openFilterMenu() async {
    final overlay = OverlayService.of(context);
    final theme = Theme.of(context);

    final completer = Completer<Filter?>();
    overlay.openBottomSheet(
      BottomSheet(builder: (context) =>
        Container(
          width: double.infinity,
          decoration: theme.bottomSheetDecoration,
          child: FilterMenu(
            initialChosenFilter: filter,
            shouldUpdateFilter: completer.complete,
          ),
        ),
        onTapBackdrop: () => overlay.closeBottomSheet(),
      ),
    );
    final newChosenFilter = await completer.future;
    overlay.closeBottomSheet();
    filter = newChosenFilter;
    setState(() {});
  }

  void openSortMenu() async {
    final overlay = OverlayService.of(context);
    final theme = Theme.of(context);

    final completer = Completer<Sort>();
    overlay.openBottomSheet(
      BottomSheet(builder: (context) =>
        Container(
          width: double.infinity,
          decoration: theme.bottomSheetDecoration,
          child: SortMenu(
            initialChosenSort: sort,
            shouldUpdateSort: completer.complete,
          ),
        ),
        onTapBackdrop: () => overlay.closeBottomSheet(),
      ),
    );
    final newChosenSort = await completer.future;
    overlay.closeBottomSheet();
    sort = newChosenSort;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final tasks = widget.taskStates;
    final theme = Theme.of(context);
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
                    progress: switch (tasks) {
                      Loading() => null,
                      Ready(value: final tasks) => tasks.progress,
                      Error(error: final error) => throw error!,
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
                  topLeftChild: switch (tasks) {
                    Loading() => null,
                    Ready() => _CornerButton(
                      alignment: Alignment.centerLeft,
                      child: SortButton(onTap: openSortMenu),
                    ),
                    Error() => todo(),
                  },
                  topRightChild: switch (tasks) {
                    Loading() => null,
                    Ready() => _CornerButton(
                      alignment: Alignment.centerRight,
                      child: FilterButton(onTap: openFilterMenu),
                    ),
                    Error() => todo(),
                  },
                  child: switch (tasks) {
                    Loading() => const loading.Content(),
                    Ready(value: final taskStates) => ready.Content(
                      taskStates: taskStates,
                      filter: filter,
                      listener: (
                        onEditPressed: onEditTask,
                        onCheckMarkPressed: widget.listener.onCheckTask,
                        onPinPressed: widget.listener.onPinTask,
                        onRemove: widget.listener.onRemoveTask,
                      ),
                      fabClearance: _fabSize + _fabPadding.bottom,
                    ),
                    Error() => todo(),
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
                      shape: const CircleBorder(),
                      backgroundColor: theme.colors.secondary,
                      foregroundColor: theme.colors.onSecondary,
                      onPressed: onFabTap,
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

class _CornerButton extends StatelessWidget {
  final Alignment alignment;
  final Widget child;

  const _CornerButton({
    required this.alignment,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 12,
        left: Page.clipboardBorderRadius,
        right: Page.clipboardBorderRadius,
      ),
      child: FittedBox(
        fit: BoxFit.contain,
        alignment: alignment,
        child: child,
      )
    );
  }
}
