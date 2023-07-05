import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:too_many_tasks/common/functions/scope_functions.dart';

sealed class State {}

final class Idling implements State {
  const Idling();
}

final class Dragging implements State {
  final double initialOffset;
  final double currentOffset;

  double relativeOffset(double threshold) => (threshold - currentOffset) 
    / (threshold - initialOffset);

  const Dragging(this.initialOffset, this.currentOffset);
}

final class Released implements State {
  final double initialOffset;
  final double currentOffset;
  final double releasedOffset;

  double relativeOffset(double threshold) => (threshold - currentOffset) 
    / (threshold - initialOffset);
  bool thresholdReached(double threshold) => releasedOffset >= threshold;

  const Released(
    this.initialOffset,
    this.currentOffset,
    this.releasedOffset,
  );
}

extension ExtendedState on State {
  double get translationOffset {
    return switch (this) {
      Idling() => 0,
      Dragging(
        initialOffset: final initialOffset,
        currentOffset: final currentOffset,
      ) => currentOffset - initialOffset,
      Released(
        initialOffset: final initialOffset,
        currentOffset: final currentOffset,
      ) => currentOffset - initialOffset,
    };
  }
}