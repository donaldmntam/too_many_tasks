// no longer used
import 'dart:math';

import 'package:too_many_tasks/common/functions/list_functions.dart';
import 'package:too_many_tasks/common/models/task.dart';
import 'package:too_many_tasks/task_list/widgets/task_card/state.dart' as task_card;

bool taskIsPinned({required int index, required int pinnedCount}) {
  return index < pinnedCount;
}

List<task_card.State> cardStates(
  TaskStates oldList,
  TaskStates newList,
) {
  if (newList.length < oldList.length) {
    return newList
      .map((taskState) => const task_card.Unpinned())
      .toList();
  }
  
  final list = List<task_card.State>.empty(growable: true);
  for (var i = 0; i < oldList.length; i++) {
    final oldState = oldList[i];
    final newState = newList[i];

    if (oldState.removed) {
      if (newState.removed) {
        list.add(const task_card.Removed());
      } else {
        list.add(const task_card.BeingAdded());
      }
    } else {
      if (newState.removed) {
        list.add(const task_card.Removed());
      } else {
        list.add(const task_card.Unpinned());
      }
    }
  }

  if (newList.length == oldList.length) {
    return list;
  }

  final newTailItemCount = newList.length - oldList.length;
  list.addMultiple(newTailItemCount, (_) => const task_card.BeingAdded());
  return list;
}

int tasksChange(Tasks oldTasks, Tasks newTasks) {
  return newTasks.length - oldTasks.length;
}
