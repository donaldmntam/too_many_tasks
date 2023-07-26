import 'package:too_many_tasks/common/models/task.dart';

// no longer used
bool taskIsPinned({required int index, required int pinnedCount}) {
  return index < pinnedCount;
}