import 'package:flutter/material.dart' hide Theme;
import 'package:too_many_tasks/common/functions/error_functions.dart';
import 'package:too_many_tasks/common/functions/number_functions.dart';
import 'package:too_many_tasks/common/models/task.dart';
import 'package:too_many_tasks/common/theme/theme.dart';
import 'package:too_many_tasks/common/widgets/proportion_box/proportion_box.dart';
import 'package:too_many_tasks/task_list/data/widget_data.dart';
import 'package:too_many_tasks/task_list/widgets/task_card/state.dart' as task_card;
import 'package:too_many_tasks/task_list/widgets/task_card/task_card.dart' as task_card;

enum _TaskType {
  pinned,
  unpinned,
}

// List<Widget> pinnedTasksBuilders(
//   TaskStates taskStates,
//   List<task_card.State> cardStates,
//   task_card.Listener listener,
// ) => _taskBuilders(
//   _TaskType.pinned,
//   taskStates,
//   cardStates,
//   listener
// );

// List<Widget> unpinnedTasksBuilders(
//   TaskStates taskStates,
//   List<task_card.State> cardStates,
//   task_card.Listener listener,
// ) => _taskBuilders(
//   _TaskType.unpinned,
//   taskStates,
//   cardStates,
//   listener
// );

List<Widget> widgets({
  // _TaskType type,
  required double bottomPadding,
  required Theme theme,
  required TaskStates taskStates,
  required List<task_card.State> cardStates,
  required task_card.Listener listener,
}) {
  require(
    cardStates.length == taskStates.length,
    "cardStates(length: ${cardStates.length}) and "
      "taskStates(length: ${taskStates.length}) do not have the same length!",
  );

  final widgets = List<Widget>.empty(growable: true);

  widgets.add(const SizedBox(height: taskListPadding));

  // pinned tasks
  var pinnedCount = 0;
  for (var index = 0; index < cardStates.length; index++) {
    final cardState = cardStates[index];
    final task = taskStates[index].task;
    if (!task.pinned) continue;
    pinnedCount++;
    final visibility = _visibilityForPinned(cardState);
    if (visibility <= 0.0) continue;
    widgets.add(
      _taskItemWidget(
        index: index, 
        task: task,
        listener: listener, 
        visibility: visibility,
        padding: _taskItemPadding(taskStates.length, index),
      )
    );
  }

  if (pinnedCount > 0) {
    widgets.add(
      Padding(
        padding: middleTaskListItemEdgeInsets,
        child: Divider(
          color: theme.colors.onBackground400,
        )
      )
    );
  }

  // unpinned tasks
  for (var index = 0; index < cardStates.length; index++) {
    final cardState = cardStates[index];
    final task = taskStates[index].task;
    if (task.pinned) continue;
    final visibility = _visibilityForUnpinned(cardState);
    if (visibility <= 0.0) continue;
    widgets.add(
      _taskItemWidget(
        index: index, 
        task: task,
        listener: listener, 
        visibility: visibility,
        padding: _taskItemPadding(taskStates.length, index),
      )
    );
  }

  widgets.add(
    SizedBox(
      height: bottomPadding + taskListPadding,
    ),
  );

  return widgets;
}

double _visibilityForPinned(
  task_card.State cardState
) {
  return switch (cardState) {
    task_card.BeingAdded() => cardState.animationValue,
    task_card.BeingUnpinned() => 1 - cardState.animationValue,
    task_card.Unpinned() => 0.0,
    task_card.BeingRemoved() => 1 - cardState.animationValue,
    task_card.BeingPinned() => 1 - cardState.animationValue,
    task_card.Removed() => 0.0,
    task_card.Pinned() => 0.0,
  };
}

double _visibilityForUnpinned(
  task_card.State cardState
) {
  return switch (cardState) {
    task_card.BeingAdded() => cardState.animationValue,
    task_card.BeingUnpinned() => cardState.animationValue,
    task_card.Unpinned() => 1.0,
    task_card.BeingRemoved() => 1 - cardState.animationValue,
    task_card.BeingPinned() => 1 - cardState.animationValue,
    task_card.Removed() => 0.0,
    task_card.Pinned() => 0.0,
  };
}

Widget _taskItemWidget({
  required int index,
  required Task task,
  required task_card.Listener listener,
  required double visibility,
  required EdgeInsets padding,
}) {
  final heightProportion = visibility.coerceAtMost(0.2) / 0.2;
  final opacity = (visibility.coerceAtLeast(0.2) - 0.2) / 0.8;
  return ProportionSize(
    heightProportion: heightProportion,
    child: Opacity(
      opacity: opacity,
      child: Padding(
        // todo: index is incorrect
        padding: padding,
        child: task_card.TaskCard(index, task, listener),
      ),
    )
  );
}

EdgeInsets _taskItemPadding(int length, int index) {
  if (index == 0) {
    return startTaskListItemEdgeInsets;
  } else if (index == length - 1) {
    return middleTaskListItemEdgeInsets;
  } else {
    return endTaskListItemEdgeInsets;
  }
}