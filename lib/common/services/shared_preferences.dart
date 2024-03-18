import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:shared_preferences/shared_preferences.dart' as package;
import 'package:too_many_tasks/common/functions/json_functions.dart';
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
    final stringResult = await getString(SharedPrefsKeys.tasks);
    if (stringResult is Err) return stringResult;

    final string = stringResult.unwrap();
    if (string is None) return const Result.ok(IListConst([]));

    final decodedResult = tryJsonDecode(string.unwrap());
    if (decodedResult is Err) return decodedResult;

    final tasksResult = jsonToTasks(decodedResult.unwrap());
    if (tasksResult is Err) return tasksResult;

    return tasksResult;
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
    final json = taskStates
      .where((state) => !state.removed)
      .toIList()
      .toJson((state) => taskToJson(state.task));

    final stringResult = tryJsonEncode(json);
    if (stringResult is Err) return stringResult;

    final string = stringResult.unwrap();
    setString(SharedPrefsKeys.tasks, string);
    return const Result.ok(unit);
  }

  Future<Result<Optional<int>>> getNextAvailableTaskId() async {
    final string = await getString(SharedPrefsKeys.nextAvailableTaskId);
    if (string is Err) return string;
    final optional = string.unwrap();
    if (optional is None) return const Result.ok(Optional.none);
    final integer = int.tryParse(optional.unwrap());
    if (integer == null) {
      return Result.err(
        '\'${optional.unwrap()}\' is not a valid integer'
      );
    }
    return Result.ok(Optional.some(integer));
  }

  Future<Result<Unit>> setNextAvailableTaskId(int id) async {
    await setString(SharedPrefsKeys.nextAvailableTaskId, id.toString());
    return const Result.ok(unit);
  }
}
