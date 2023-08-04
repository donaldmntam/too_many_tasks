// no longer used
import 'dart:math';

import 'package:too_many_tasks/common/functions/list_functions.dart';
import 'package:too_many_tasks/common/models/task.dart';
import 'package:too_many_tasks/task_list/widgets/task_card/state.dart' as task_card;

bool taskIsPinned({required int index, required int pinnedCount}) {
  return index < pinnedCount;
}

List<task_card.State> cardStates(
  Tasks oldTasks,
  Tasks newTasks,
) {
  final length = min(oldTasks.length, newTasks.length);
  final list = List<task_card.State>.empty(growable: true);
  for (var i = 0; i < length; i++) {
    final oldTask = oldTasks[i];
    final newTask = newTasks[i];
    // TODO: implement task changing
    list.add(const task_card.Ready());
  }

  final change = tasksChange(oldTasks, newTasks);
  switch (change) {
    case > 0:
      list.addMultiple(
        change,
        (_) => const task_card.BeingAdded()
      );
    case < 0:
      list.addMultiple(
        -change,
        (index) => const task_card.BeingRemoved()
      );
    default:
      break;
  }

  return list;
}

int tasksChange(Tasks oldTasks, Tasks newTasks) {
  return newTasks.length - oldTasks.length;
}
