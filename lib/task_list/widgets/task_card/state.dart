import 'package:too_many_tasks/common/models/task.dart';

sealed class State {
  final Task task;

  const State({required this.task});
}

final class BeingAdded extends State {
  final DateTime? startTime;
  final double animationValue;
  
  const BeingAdded({
    required super.task,
    this.startTime,
    this.animationValue = 0.0,
  });
}

final class Ready extends State {
  const Ready({required super.task});
}

final class BeingRemoved extends State {
  final DateTime? startTime;
  final double animationValue;
  final bool shouldRemoveDataWhenAnimationEnd;
  
  const BeingRemoved({
    required super.task,
    this.startTime,
    this.animationValue = 0.0,
    this.shouldRemoveDataWhenAnimationEnd = false,
  });
}

final class Removed extends State {
  const Removed({
    required super.task,
  });
}