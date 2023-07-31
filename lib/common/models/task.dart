import 'package:too_many_tasks/common/functions/error_functions.dart';
import 'package:too_many_tasks/common/monads/result.dart';
import 'package:too_many_tasks/common/typedefs/json.dart';

typedef Task = ({
  String name,
  DateTime dueDate,
  bool done,
  bool pinned,
});

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

  Json toJson() => {
    "name": name,
    "dueDate": dueDate,
    "done": done,
    "pinned": pinned,
  };
}

Result<Task> taskFromJson(Json json) {
  if (
    json case {
      "name": String name,
      "dueDate": DateTime dueDate,
      "done": bool done,
      "pinned": bool pinned,
    }
  ) {
    return Ok((
      name: name,
      dueDate: dueDate,
      done: done,
      pinned: pinned,
    ));
  }
  return Err(jsonErrorMessage("Task", json));
}

Result<List<Task>> tasksFromJson(Json json) {
  if (json is! List) {
    return Err(jsonErrorMessage("List<Task>", json));
  }
  final tasks = List<Task>.empty(growable: true);
  for (final element in json) {
    final task = taskFromJson(element);
    switch (task) {
      case Ok(value: final task):
        tasks.add(task);
      case Err(value: final error): 
        return Err(jsonErrorMessage("List<Task>", json, [error]));
    }
  }
  return Ok(tasks);
}

typedef TaskPreset = ({
  String name,
});