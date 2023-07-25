import 'package:flutter/material.dart';
import 'package:too_many_tasks/common/widgets/swipeable/details.dart';

class SwipeableBackground extends StatelessWidget {
  final BackgroundBuilderDetails details;

  const SwipeableBackground({
    super.key,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: switch (details) {
        DraggingBackgroundBuilderDetails(
          animationValue: final relativeOffset,
        ) => Color.fromARGB((255 * relativeOffset).toInt(), 0, 0, 0),
        ReleasedBackgroundBuilderDetails(
          thresholdReached: final thresholdReached,
        ) => thresholdReached ? Colors.green : Colors.red,
      },
      child: const Icon(
        Icons.abc,
        color: Colors.black,
      )
    );
  }
}
