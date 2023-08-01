import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:too_many_tasks/common/models/task.dart';
import 'package:too_many_tasks/task_list/models/data.dart';

sealed class MasterMessage {}

final class DataInitialized implements MasterMessage {
  final Data data;

  const DataInitialized(this.data);
}

sealed class SlaveMessage {}

final class AddTask implements SlaveMessage {
  final Task task;

  const AddTask(this.task);
}

final class AddPreset implements SlaveMessage {
  final TaskPreset preset;

  const AddPreset(this.preset);
}