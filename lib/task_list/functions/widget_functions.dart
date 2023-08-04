import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';
import 'package:too_many_tasks/common/functions/number_functions.dart';
import 'package:too_many_tasks/common/models/task.dart';
import 'package:too_many_tasks/common/widgets/proportion_box/proportion_box.dart';
import 'package:too_many_tasks/task_list/data/widget_data.dart';
import 'package:too_many_tasks/task_list/listener.dart';
import 'package:too_many_tasks/task_list/widgets/task_card/state.dart' as task_card;
import 'package:too_many_tasks/task_list/widgets/task_card/task_card.dart' as task_card;

enum _TaskType {
  pinned,
  unpinned,
}

List<Widget Function()> pinnedTasksBuilders(
  IList<Task> tasks,
  List<task_card.State> cardStates,
  task_card.Listener listener,
) => _taskBuilders(
  _TaskType.pinned,
  tasks,
  cardStates,
  listener
);

List<Widget Function()> unpinnedTasksBuilders(
  IList<Task> tasks,
  List<task_card.State> cardStates,
  task_card.Listener listener,
) => _taskBuilders(
  _TaskType.unpinned,
  tasks,
  cardStates,
  listener
);

List<Widget Function()> _taskBuilders(
  _TaskType type,
  IList<Task> tasks,
  List<task_card.State> cardStates,
  task_card.Listener listener,
) {
  final builders = List<Widget Function()>.empty(growable: true);

  for (var index = 0; index < cardStates.length; index++) {
    final task = tasks[index];
    final shouldInclude = 
      task.pinned && type == _TaskType.pinned ||
      !task.pinned && type == _TaskType.unpinned;
    if (!shouldInclude) continue;
    final cardState = cardStates[index]; 
    final visibility = switch (cardState) {
      task_card.BeingAdded(animationValue: final animationValue) =>
        animationValue,
      task_card.Ready() => 1.0,
      task_card.BeingRemoved(animationValue: final animationValue) =>
        1 - animationValue,
      task_card.Removed() => null,
    };
    if (visibility == null) continue;
    final heightProportion = visibility.coerceAtMost(0.2) / 0.2;
    final opacity = (visibility.coerceAtLeast(0.2) - 0.2) / 0.8;
    builders.add(
      () => ProportionSize(
        heightProportion: heightProportion,
        child: Opacity(
          opacity: opacity,
          child: Padding(
            padding: taskItemPadding(tasks.length, index),
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