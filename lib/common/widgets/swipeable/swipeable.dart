import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart' hide State;
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart' as widgets show State;
import 'package:too_many_tasks/common/functions/scope_functions.dart';
import 'package:too_many_tasks/common/widgets/swipeable/swipeable_clipper.dart';
import 'package:too_many_tasks/common/widgets/swipeable/details.dart';
import 'package:too_many_tasks/common/widgets/swipeable/state.dart';

typedef WidgetBuilder = Widget Function(BackgroundBuilderDetails details);

class Swipeable extends StatefulWidget {
  final Duration duration;
  final Curve curve;
  final double swipeDistance;
  final double swipeThreshold;
  final WidgetBuilder leftBackgroundBuilder;
  final Widget child;

  const Swipeable({
    super.key,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeOut,
    this.swipeThreshold = 75.0,
    this.swipeDistance = 80.0,
    required this.leftBackgroundBuilder,
    required this.child,
  });

  @override
  widgets.State<Swipeable> createState() => _State();
}

class _State extends widgets.State<Swipeable> 
  with SingleTickerProviderStateMixin {
  late State state;
  late Ticker ticker;

  @override
  void initState() {
    state = const Idling();

    ticker = createTicker(onTick);

    super.initState();
  }

  @override
  void dispose() {
    ticker.dispose();

    super.dispose();
  }

  void onDragStart(DragStartDetails details) {
    final state = this.state;
    switch (state) {
      case Idling():
        final newState = Dragging(
          details.localPosition.dx,
          details.localPosition.dx
        );
        this.state = newState;
        setState(() {});
      case Released(initialOffset: final initialOffset):
        final newState = Dragging(
          initialOffset,
          details.localPosition.dx
        );
        this.state = newState;
        setState(() {});
        ticker.stop();
      case Dragging():
        break;
    }
  }

  void onDragUpdate(DragUpdateDetails details) {
    final state = this.state;
    switch (state) {
      case Dragging(initialOffset: final initialOffset):
        final currentOffset = clampDouble(
          details.localPosition.dx,
          0, // initialOffset - widget.threshold,
          initialOffset + widget.swipeDistance,
        );
        final newState = Dragging(initialOffset, currentOffset);
        this.state = newState;
        setState(() {});
      case Idling():
      case Released():
        break;
    }
  }

  void onDragEnd(DragEndDetails _) {
    final state = this.state;
    switch (state) {
      case Dragging(
        initialOffset: final initialPosition,
        currentOffset: final currentPosition,
      ):
        final newState = Released(
          initialPosition,
          currentPosition,
          currentPosition,
        );
        this.state = newState;
        setState(() {});
        ticker.start();
      case Idling():
      case Released():
        break;
    }
  }
  
  void onTick(Duration duration) {
    final state = this.state;
    switch (state) {
      case Released(
        initialOffset: final initialPosition,
        releasedOffset: final releasedPosition,
      ):
        if (duration > widget.duration) {
          const newState = Idling();
          this.state = newState;
          setState(() {});
          ticker.stop();
          break;
        }
        final newState = Released(
          initialPosition,
          _releasedOffset(
            state: state,
            currentDuration: duration,
            duration: widget.duration,
            curve: Curves.easeOut,
          ),
          releasedPosition,
        );
        this.state = newState;
        setState(() {});
      case Idling():
      case Dragging():
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = this.state;
    return GestureDetector(
      onHorizontalDragStart: onDragStart,
      onHorizontalDragUpdate: onDragUpdate,
      onHorizontalDragEnd: onDragEnd,
      child: IntrinsicHeight(
        child: Stack(
          children: [
            ClipRect(
              clipper: SwipeableClipper(offset: state.translationOffset),
              child: SizedBox(
                width: 80,
                height: double.infinity,
                child: switch (state) {
                  Idling() => null,
                  Dragging() => widget.leftBackgroundBuilder(
                    DraggingBackgroundBuilderDetails(
                      animationValue: state.animationValue(widget.swipeThreshold)
                    ),
                  ),
                  Released() => widget.leftBackgroundBuilder(
                    ReleasedBackgroundBuilderDetails(
                      animationValue: state.animationValue(widget.swipeThreshold),
                      thresholdReached: state.thresholdReached(
                        widget.swipeThreshold
                      ),
                    )
                  )
                }
              ),
            ),
            Transform.translate(
              offset: Offset(state.translationOffset, 0),
              child: widget.child
            ),
          ],
        ),
      ),
    );
  }
}

double _releasedOffset({
  required Released state,
  required Duration currentDuration,
  required Duration duration,
  required Curve curve,
}) {
  return lerpDouble(
    state.releasedOffset,
    state.initialOffset,
    curve.transform(
      min(currentDuration.inMilliseconds / duration.inMilliseconds, 1.0)
    )
  )!;
}
