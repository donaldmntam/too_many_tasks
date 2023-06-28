import 'dart:math';

import 'package:flutter/material.dart';
import 'package:funvas/funvas.dart';
import 'package:too_many_tasks/common/data/curves.dart';

// TODO: center bubbles
// TODO: stuttering

class Configuration {
  final double bubbleSize;
  final double gridSize;
  final double speed;
  final Color backgroundColor;
  final Color startColor;
  final Color endColor;
  final Curve curve;

  const Configuration({
    this.bubbleSize = 8,
    this.gridSize = 16,
    this.speed = 1.5,
    this.backgroundColor = Colors.transparent,
    this.startColor = Colors.blue,
    this.endColor = Colors.pink,
    this.curve = Curves.easeOutCubic,
  });

  Configuration copy({
    double? bubbleSize,
    double? gridSize,
    double? speed,
    Color? backgroundColor,
    Color? startColor,
    Color? endColor,
    Curve? curve,
  }) => Configuration(
    bubbleSize: bubbleSize ?? this.bubbleSize,
    gridSize: gridSize ?? this.gridSize,
    speed: speed ?? this.speed,
    backgroundColor: backgroundColor ?? this.backgroundColor, 
    startColor: startColor ?? this.startColor,
    endColor: endColor ?? this.endColor,
    curve: curve ?? this.curve,
  );

  Map<String, Object?> encode() => {
    "bubbleSize": bubbleSize,
    "gridSize": gridSize,
    "speed": speed,
    "backgroundColor": backgroundColor.toString(),
    "startColor": startColor.toString(),
    "endColor": endColor.toString(),
    "curve": curveTitles[curve],
  };
}

class RisingBubbles extends StatelessWidget {
  final Configuration configuration;

  const RisingBubbles({
    super.key,
    this.configuration = const Configuration(),
  });

  @override
  Widget build(BuildContext context) {
    return FunvasContainer(
      funvas: RisingBubblesFunvas(
        configuration: configuration,
      )
    );
  }
}

class RisingBubblesFunvas extends Funvas {
  final Configuration configuration;

  RisingBubblesFunvas({
    this.configuration = const Configuration()
  });

  @override
  void u(double t) {
    final gridSize = configuration.gridSize;
    final bubbleSize = configuration.bubbleSize;
    final interval = 1 / configuration.speed;
    final backgroundColor = configuration.backgroundColor;
    final startColor = configuration.startColor;
    final endColor = configuration.endColor;
    final curve = configuration.curve;
    final width = x.width;
    final height = x.height;
    final rowCount = (height + gridSize - 1) ~/ (gridSize / 2) + 4;
    
    c.drawColor(backgroundColor, BlendMode.srcATop);

    for (var row = 0; row < rowCount; row++) {
      double dx;
      final int columnCount;
      if (row % 2 == 0) {
        dx = 0;
        columnCount = (width + gridSize - 1) ~/ gridSize;
      } else {
        dx = -(gridSize / 2);
        columnCount = (width + gridSize * 3 - 1) ~/ gridSize;
      }

      final animationOffsetY = -(((t % interval) / interval) * gridSize * 2);
      final dy = animationOffsetY + (row * gridSize / 2) - gridSize / 2;
      final intensity = curve.transform(
        min(max(dy / height, 0), 1)
      );

      for (var column = 0; column < columnCount; column++) {
        final paint = Paint()
          ..color = Color.lerp(
            endColor,
            startColor,
            intensity,
          )!;
        c.drawCircle(
          Offset(dx + gridSize / 2, dy + gridSize / 2),
          bubbleSize / 2,
          paint,
        );
        dx += gridSize;
      }
    }
  }
}