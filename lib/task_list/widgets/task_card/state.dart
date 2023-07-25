import 'package:too_many_tasks/task_list/widgets/task_card/task_card.dart';

sealed class State {}

final class Ready implements State {
  final Data data;
  const Ready({required this.data});
}

final class BeingRemoved implements State {
  final DateTime startTime;
  final Data data;
  final double animationValue;
  const BeingRemoved({
    required this.startTime,
    required this.data,
    required this.animationValue,
  });
}

final class Removed implements State {
  const Removed();
}