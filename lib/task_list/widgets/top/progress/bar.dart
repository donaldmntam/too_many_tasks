import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:too_many_tasks/common/theme/theme.dart';

const _barFillColor = Color(0x70FFFFFF); // TODO: from theme?
const _duration = Duration(milliseconds: 1000);
const _curve = Curves.easeOut;

class Bar extends StatefulWidget {
  final double progress;  

  const Bar(
    this.progress,
    {super.key}
  );

  @override
  State<Bar> createState() => _WidgetState();
}

class _WidgetState extends State<Bar> with SingleTickerProviderStateMixin {
  late final Ticker ticker;

  late _State state;

  @override
  void initState() {
    ticker = createTicker(onTick);    

    state = _Idling(progress: widget.progress);

    super.initState();
  }

  @override
  void dispose() {
    ticker.dispose();

    super.dispose();
  }

  // state check?
  @override
  void didUpdateWidget(Bar oldWidget) {
    if (widget.progress != oldWidget.progress) {
      didUpdateProgress(widget.progress);
    }
    super.didUpdateWidget(oldWidget);
  }

  void didUpdateProgress(
    double newProgress,
  ) {
    final state = this.state;
    switch (state) {
      case _Idling(progress: final lastProgress):
        this.state = _Animating(
          animationValue: 0,
          lastProgress: lastProgress,
          targetProgress: newProgress,
        );
        setState(() {});
        ticker.start();
      case _Animating():
        this.state = _Animating(
          animationValue: 0,
          lastProgress: state.animatedProgress,
          targetProgress: newProgress,
        );
        setState(() {});
        ticker.stop();
        ticker.start();
    }
  }

  void onTick(Duration duration) {
    final state = this.state;

    switch (state) {
      case _Idling():
        break;
      case _Animating(
        lastProgress: final lastProgress,
        targetProgress: final targetProgress,
      ):
        final value = duration.inMilliseconds / _duration.inMilliseconds;
        if (value >= 1.0) {
          this.state = _Idling(progress: targetProgress);
          setState(() {});
          ticker.stop();
        } else {
          this.state = _Animating(
            lastProgress: lastProgress,
            targetProgress: targetProgress,
            animationValue: value,
          );
          setState(() {});
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = this.state;
    return Container(
      decoration: ShapeDecoration(
        color: theme.colors.primary,
        shape: StadiumBorder(
          side: BorderSide(color: theme.colors.onPrimary)
        ),
      ),
      child: CustomPaint(
        size: Size.infinite,
        painter: _Painter(
          switch (state) {
            _Idling() => state.progress,
            _Animating() => state.animatedProgress,
          },
          _barFillColor
        ),
      ),
    );
  }
}

class _Painter extends CustomPainter {
  final double progress;
  final Color color;

  const _Painter(
    this.progress,
    this.color,
  );

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width * progress, size.height),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(_Painter oldDelegate) {
    return progress != oldDelegate.progress ||
      color != oldDelegate.color;
  }
}

sealed class _State {}

final class _Idling implements _State {
  final double progress;

  const _Idling({required this.progress});
}

final class _Animating implements _State {
  final double lastProgress;
  final double targetProgress;
  final double animationValue;

  double get animatedProgress => lastProgress 
    + (targetProgress - lastProgress) * _curve.transform(animationValue);

  const _Animating({
    required this.lastProgress,
    required this.targetProgress,
    required this.animationValue,
  });
}