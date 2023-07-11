sealed class BackgroundBuilderDetails {}

final class DraggingBackgroundBuilderDetails 
  implements BackgroundBuilderDetails {
  final double animationValue;

  const DraggingBackgroundBuilderDetails({
    required this.animationValue,
  });
}

final class ReleasedBackgroundBuilderDetails
  implements BackgroundBuilderDetails {
  final double animationValue;
  final bool thresholdReached;

  const ReleasedBackgroundBuilderDetails({
    required this.animationValue,
    required this.thresholdReached,
  });
}