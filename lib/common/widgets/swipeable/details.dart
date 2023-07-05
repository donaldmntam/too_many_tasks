sealed class BackgroundBuilderDetails {}

final class DraggingBackgroundBuilderDetails 
  implements BackgroundBuilderDetails {
  final double relativeOffset;

  const DraggingBackgroundBuilderDetails({
    required this.relativeOffset,
  });
}

final class ReleasedBackgroundBuilderDetails
  implements BackgroundBuilderDetails {
  final double relativeOffset;
  final bool thresholdReached;

  const ReleasedBackgroundBuilderDetails({
    required this.relativeOffset,
    required this.thresholdReached,
  });
}