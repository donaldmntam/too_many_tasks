import 'package:flutter/widgets.dart';
import 'package:too_many_tasks/common/functions/error_functions.dart';
import 'package:too_many_tasks/common/functions/number_functions.dart';
import 'package:too_many_tasks/common/models/task.dart';
import 'package:too_many_tasks/common/widgets/proportion_box/proportion_box.dart';
import 'package:too_many_tasks/task_list/data/widget_data.dart';
import 'package:too_many_tasks/task_list/widgets/task_card/state.dart' as task_card;
import 'package:too_many_tasks/task_list/widgets/task_card/task_card.dart' as task_card;

enum _TaskType {
  pinned,
  unpinned,
}

List<Widget> pinnedTasksBuilders(
  TaskStates taskStates,
  List<task_card.State> cardStates,
  task_card.Listener listener,
) => _taskBuilders(
  _TaskType.pinned,
  taskStates,
  cardStates,
  listener
);

List<Widget> unpinnedTasksBuilders(
  TaskStates taskStates,
  List<task_card.State> cardStates,
  task_card.Listener listener,
) => _taskBuilders(
  _TaskType.unpinned,
  taskStates,
  cardStates,
  listener
);

List<Widget> _taskBuilders(
  _TaskType type,
  TaskStates taskStates,
  List<task_card.State> cardStates,
  task_card.Listener listener,
) {
  require(
    cardStates.length == taskStates.length,
    "cardStates(length: ${cardStates.length}) and "
      "taskStates(length: ${taskStates.length}) do not have the same length!",
  );

  final builders = List<Widget>.empty(growable: true);

  for (var index = 0; index < cardStates.length; index++) {
    final task = taskStates[index].task;
    final cardState = cardStates[index]; 
    // TODO: check type for visibility for the rest of the switch branches
    final visibility = switch (cardState) {
      task_card.BeingAdded() => cardState.animationValue,
      task_card.BeingUnpinned() => switch (type) {
        _TaskType.pinned => 1 - cardState.animationValue,
        _TaskType.unpinned => cardState.animationValue,
      },
      task_card.Unpinned() => switch (type) {
        _TaskType.pinned => null,
        _TaskType.unpinned => 1.0,
      },
      task_card.BeingRemoved() => 1 - cardState.animationValue,
      task_card.BeingPinned() => 1 - cardState.animationValue,
      task_card.Removed() => null,
      task_card.Pinned() => switch (type) {
        _TaskType.pinned => 1.0,
        _TaskType.unpinned => null,
      },
    };
    if (visibility == null) continue;
    final heightProportion = visibility.coerceAtMost(0.2) / 0.2;
    final opacity = (visibility.coerceAtLeast(0.2) - 0.2) / 0.8;
    builders.add(
      ProportionSize(
        heightProportion: heightProportion,
        child: Opacity(
          opacity: opacity,
          child: Padding(
            // todo: index is incorrect
            padding: taskItemPadding(taskStates.length, index),
            child: task_card.TaskCard(index, task, listener),
          ),
        )
      ),
    );
  }

  return builders;
}

EdgeInsets taskItemPadding(int length, int index) {
  if (index == 0) {
    return startTaskListItemEdgeInsets;
  } else if (index == length - 1) {
    return middleTaskListItemEdgeInsets;
  } else {
    return endTaskListItemEdgeInsets;
  }
}