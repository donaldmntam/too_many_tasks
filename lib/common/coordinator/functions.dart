import 'dart:convert';

import 'package:too_many_tasks/common/functions/json_functions.dart';
import 'package:too_many_tasks/common/models/task.dart';
import 'package:too_many_tasks/common/monads/result.dart';
import 'package:too_many_tasks/common/services/shared_preferences.dart';

Future<Result<List<Task>>> loadTasksFromSharedPrefs(
  SharedPreferences sharedPrefs, 
) async {
  final string = await sharedPrefs.getString("tasks");
  if (string == null) return const Ok([]);
  final result = tryJsonDecode(string)
    .flatMap(tasksFromJson);
  return result;
}