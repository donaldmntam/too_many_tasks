sealed class State {}

final class BeingAdded implements State {
  final DateTime? startTime;
  final double animationValue;
  
  const BeingAdded({
    this.startTime,
    this.animationValue = 0.0,
  });
}

final class Ready implements State {
  const Ready();
}

final class BeingRemoved implements State {
  final DateTime? startTime;
  final double animationValue;
  final bool shouldRemoveDataWhenAnimationEnd;
  
  const BeingRemoved({
    this.startTime,
    this.animationValue = 0.0,
    this.shouldRemoveDataWhenAnimationEnd = false,
  });
}

final class Removed implements State {
  const Removed();
}