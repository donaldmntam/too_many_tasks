import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:shared_preferences/shared_preferences.dart' as package;
import 'package:too_many_tasks/common/functions/iterable_functions.dart';
import 'package:too_many_tasks/common/functions/json_functions.dart';
import 'package:too_many_tasks/common/functions/nullable_functions.dart';
import 'package:too_many_tasks/common/functions/scope_functions.dart';
import 'package:too_many_tasks/common/models/task.dart';
import 'package:too_many_tasks/common/models/unit.dart';
import 'package:too_many_tasks/common/monads/optional.dart';
import 'package:too_many_tasks/common/monads/result.dart';
import 'package:too_many_tasks/common/services/shared_preferences_keys.dart';

abstract interface class SharedPreferences {
  Future<Result<Optional<String>>> getString(String key);
  Future<Unit> setString(String key, String value);
  Future<Result<List<String>>> getStrings(String key);
  Future<Unit> setStrings(String key, List<String> value);
}

class DefaultSharedPreferences implements SharedPreferences {
  const DefaultSharedPreferences();

  @override
  Future<Result<Optional<String>>> getString(String key) async {
    try {
      final instance = await package.SharedPreferences.getInstance();
      final string = instance.getString(key);
      if (string == null) return const Result.ok(Optional.none);
      return Result.ok(Optional.some(string));
    } catch (e) {
      return Result.err(e);
    }
  }

  @override
  Future<Unit> setString(String key, String value) async {
    final instance = await package.SharedPreferences.getInstance();
    instance.setString(key, value);
    return unit;
  }

  @override
  Future<Result<List<String>>> getStrings(String key) async {
    try {
      final instance = await package.SharedPreferences.getInstance();
      final list = instance.getStringList(key);
      if (list == null) return const Result.ok([]);
      return Result.ok(list);
    } catch (e) {
      return Result.err(e);
    }
  }

  @override
  Future<Unit> setStrings(String key, List<String> value) async {
    final instance = await package.SharedPreferences.getInstance();
    instance.setStringList(key, value);
    return unit;
  }
}

extension ExtendedSharedPreferences on SharedPreferences {
  Future<Result<IList<Task>>> getTasks() async {
    final stringsResult = await getStrings(SharedPrefsKeys.tasks);
    if (stringsResult is Err) return stringsResult;

    final strings = stringsResult.unwrap();

    final decodedResult = strings.map(tryJsonDecode).flattenResults();
    if (decodedResult is Err) return decodedResult;

    final decoded = decodedResult.unwrap();

    final tasksResult = decoded
      .map(jsonToTask)
      .flattenResults();
    if (tasksResult is Err) return tasksResult;

    return Result.ok(tasksResult.unwrap().lock);
  }

  Future<Result<Unit>> setTasks(
    Tasks tasks
  ) async {
    final json = tasks.toJson(taskToJson);

    final stringResult = tryJsonEncode(json);
    if (stringResult is Err) return stringResult;

    final string = stringResult.unwrap();
    setString(SharedPrefsKeys.tasks, string);
    return const Result.ok(unit);
  }

  Future<Result<Unit>> setTasksWithTaskStates(
    TaskStates taskStates
  ) async {
    final json = taskStates.toJson((state) => taskToJson(state.task));

    final stringResult = tryJsonEncode(json);
    if (stringResult is Err) return stringResult;

    final string = stringResult.unwrap();
    setString(SharedPrefsKeys.tasks, string);
    return const Result.ok(unit);
  }
}