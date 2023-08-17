import 'package:flutter/material.dart' hide Theme;
import 'package:too_many_tasks/common/functions/error_functions.dart';
import 'package:too_many_tasks/common/functions/number_functions.dart';
import 'package:too_many_tasks/common/functions/scope_functions.dart';
import 'package:too_many_tasks/common/models/task.dart';
import 'package:too_many_tasks/common/theme/theme.dart';
import 'package:too_many_tasks/common/widgets/proportion_box/proportion_box.dart';
import 'package:too_many_tasks/task_list/data/widget_data.dart';
import 'package:too_many_tasks/task_list/widgets/task_card/state.dart' as task_card;
import 'package:too_many_tasks/task_list/widgets/task_card/task_card.dart' as task_card;

// enum _TaskType {
//   pinned,
//   unpinned,
// }

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

// TODO: support removing pinned items
// TODO: support divider animation
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

  // pinned tasks
  final pinnedWidgets = List<Widget>.empty(growable: true);
  for (var index = 0; index < cardStates.length; index++) {
    final cardState = cardStates[index];
    final task = taskStates[index].task;
    final double visibility = switch (cardState) {
      task_card.Pinned() => 1,
      task_card.BeingPinned() => cardState.animationValue,
      task_card.BeingUnpinned() => (1 - cardState.animationValue).also((it) => print("visibility here $it")),
      _ => 0,
    };
    if (visibility <= 0.0) continue;
    if (pinnedWidgets.isNotEmpty) {
      pinnedWidgets.add(const SizedBox(height: taskListItemSpacing));
    }
    pinnedWidgets.add(
      _taskItemWidget(
        index: index, 
        task: task,
        listener: listener, 
        visibility: visibility,
      )
    );
  }

  // if (pinnedCount > 0) {
  //   widgets.add(
  //     Padding(
  //       padding: middleTaskListItemEdgeInsets,
  //       child: Divider(
  //         color: theme.colors.onBackground400,
  //       )
  //     )
  //   );
  // }

  // unpinned tasks
  var unpinnedWidgets = List<Widget>.empty(growable: true);
  for (var index = 0; index < cardStates.length; index++) {
    final cardState = cardStates[index];
    final task = taskStates[index].task;
    final double visibility = switch (cardState) {
      task_card.Pinned() => 0,
      task_card.BeingPinned() => 1 - cardState.animationValue,
      task_card.BeingUnpinned() => cardState.animationValue,
      task_card.Unpinned() => 1,
      task_card.BeingAdded() => cardState.animationValue,
      task_card.BeingRemoved() => 1 - cardState.animationValue,
      task_card.Removed() => 0,
    };
    if (visibility <= 0.0) continue;
    if (unpinnedWidgets.isNotEmpty) {
      unpinnedWidgets.add(const SizedBox(height: taskListItemSpacing));
    }
    unpinnedWidgets.add(
      _taskItemWidget(
        index: index, 
        task: task,
        listener: listener, 
        visibility: visibility,
      )
    );
  }

  final widgets = List<Widget>.empty(growable: true);
  widgets.add(const SizedBox(height: taskListPadding));
  widgets.addAll(pinnedWidgets);
  if (pinnedWidgets.isNotEmpty && unpinnedWidgets.isNotEmpty) {
    widgets.add(
      Padding(
        padding: const EdgeInsets.symmetric(
          vertical: taskListItemSpacing,
          horizontal: taskListPadding,
        ),
        child: Divider(
          color: theme.colors.onBackground900,
        )
      )
    );
  }
  widgets.addAll(unpinnedWidgets);
  widgets.add(
    SizedBox(
      height: bottomPadding + taskListPadding,
    ),
  );
  return widgets;
}

Widget _taskItemWidget({
  required int index,
  required Task task,
  required task_card.Listener listener,
  required double visibility,
}) {
  final heightProportion = visibility.coerceAtMost(0.2) / 0.2;
  final opacity = (visibility.coerceAtLeast(0.2) - 0.2) / 0.8;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: taskListPadding),
    child: ProportionSize(
      heightProportion: heightProportion,
      child: Opacity(
        opacity: opacity,
        child: task_card.TaskCard(index, task, listener),
      )
    ),
  );
}

// EdgeInsets _taskItemPadding(int length, int index) {
//   if (index == 0) {
//     return startTaskListItemEdgeInsets;
//   } else if (index == length - 1) {
//     return middleTaskListItemEdgeInsets;
//   } else {
//     return endTaskListItemEdgeInsets;
//   }
// }