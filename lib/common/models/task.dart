import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:too_many_tasks/common/functions/error_functions.dart';
import 'package:too_many_tasks/common/monads/result.dart';
import 'package:too_many_tasks/common/typedefs/json.dart';

typedef Task = ({
  String name,
  DateTime dueDate,
  bool done,
  bool pinned,
});

typedef TaskState = ({
  Task task,
  bool removed,
});

typedef Tasks = IList<Task>;

typedef TaskStates = IList<TaskState>;

extension ExtendedTask on Task {
  Task copy({
    String? name,
    DateTime? dueDate,
    bool? done,
    bool? pinned,
  }) => (
    name: name ?? this.name,
    dueDate: dueDate ?? this.dueDate,
    done: done ?? this.done,
    pinned: pinned ?? this.pinned,
  );

  Task copyBy({
    String Function(String)? name,
    DateTime Function(DateTime)? dueDate,
    bool Function(bool)? done,
    bool Function(bool)? pinned,
  }) => (
    name: name?.call(this.name) ?? this.name,
    dueDate: dueDate?.call(this.dueDate) ?? this.dueDate,
    done: done?.call(this.done) ?? this.done,
    pinned: pinned?.call(this.pinned) ?? this.pinned,
  );

  Json toJson() => taskToJson(this);
}

extension ExtendedTaskState on TaskState {
  TaskState copy({
    Task? task,
    bool? removed,
  }) => (
    task: task ?? this.task,
    removed: removed ?? this.removed,
  );

  TaskState copyBy({
    Task Function(Task)? task,
    bool Function(bool)? removed,
  }) => (
    task: task?.call(this.task) ?? this.task,
    removed: removed?.call(this.removed) ?? this.removed,
  );

  Json toJson() => {
    "task": task.toJson(),
    "removed": removed,
  };
}

Json taskToJson(Task task) {
  return {
    "name": task.name,
    "dueDate": task.dueDate.toIso8601String(),
    "done": task.done,
    "pinned": task.pinned,
  };
}

Result<Task> jsonToTask(Json json) {
  if (
    json case {
      "name": String name,
      "dueDate": String dueDateEncoded,
      "done": bool done,
      "pinned": bool pinned,
    }
  ) {
    final dueDate = DateTime.tryParse(dueDateEncoded);
    if (dueDate == null) {
      return Err(jsonErrorMessage("Task", json));
    }
    return Ok((
      name: name,
      dueDate: dueDate,
      done: done,
      pinned: pinned,
    ));
  }
  return Err(jsonErrorMessage("Task", json));
}

Result<IList<Task>> jsonToTasks(Json json) {
  if (json is! JsonArray) {
    return Err(jsonErrorMessage("IList<Task>", json));
  }
  final list = List<Task>.empty(growable: true);
  for (final e in json) {
    final result = jsonToTask(e);
    if (result is Err) return result;
    list.add(result.unwrap());
  }
  return Result.ok(list.lock);
}

// Result<IList<Task>> tasksFromJson(Json json) {
//   if (json is! List) {
//     return Err(jsonErrorMessage("List<Task>", json));
//   }
//   final tasks = List<Task>.empty(growable: true);
//   for (final element in json) {
//     final task = jsonToTask(element);
//     switch (task) {
//       case Ok(value: final task):
//         tasks.add(task);
//       case Err(value: final error): 
//         return Err(jsonErrorMessage("List<Task>", json, [error]));
//     }
//   }
//   return Ok(tasks.lock);
// }
