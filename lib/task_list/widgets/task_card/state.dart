import 'package:too_many_tasks/common/typedefs/json.dart';

sealed class State {}

final class BeingAdded implements State {
  final DateTime? startTime;
  final double animationValue;
  
  const BeingAdded({
    this.startTime,
    this.animationValue = 0.0,
  });
}

final class Unpinned implements State {
  const Unpinned();
}

final class BeingRemoved implements State {
  final DateTime? startTime;
  final double animationValue;
  final bool shouldRemoveDataWhenAnimationEnds;
  
  const BeingRemoved({
    this.startTime,
    this.animationValue = 0.0,
    this.shouldRemoveDataWhenAnimationEnds = false,
  });
}

final class Removed implements State {
  const Removed();
}

final class BeingPinned implements State {
  final DateTime? startTime;
  final double animationValue;
  final bool shouldEditDataWhenAnimationEnds;

  const BeingPinned({
    this.startTime,
    this.animationValue = 0.0,
    this.shouldEditDataWhenAnimationEnds = false,
  });
}

final class Pinned implements State {
  const Pinned();
}

final class BeingUnpinned implements State {
  final DateTime? startTime;
  final double animationValue;
  final bool shouldEditDataWhenAnimationEnds;

  const BeingUnpinned({
    this.startTime,
    this.animationValue = 1.0,
    this.shouldEditDataWhenAnimationEnds = false,
  });
}
