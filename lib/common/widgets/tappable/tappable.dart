import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart' hide State;
import 'package:flutter/widgets.dart' as widgets show State;
import 'package:too_many_tasks/common/services/services.dart';

const _durationMillis = 300;
double _opacityRate(double minOpacity, double maxOpacity) => 
  (maxOpacity - minOpacity) / _durationMillis;
double _calcOpacity({
  required double maxOpacity,
  required double minOpacity,
  required DateTime reference,
  required DateTime now
}) {
  return (now.millisecondsSinceEpoch - reference.millisecondsSinceEpoch) * 
    _opacityRate(minOpacity, maxOpacity) + minOpacity;
}

class Tappable extends StatefulWidget {
  final double minOpacity;
  final double maxOpacity;
  final void Function()? onPressed;
  final Widget child;

  const Tappable({
    super.key,
    this.minOpacity = 0.2,
    this.maxOpacity = 1.0,
    required this.onPressed,
    required this.child,
  });

  @override
  widgets.State<StatefulWidget> createState() => _State();
}

class _State extends widgets.State<Tappable> with SingleTickerProviderStateMixin {
  late final Ticker ticker;
  State state = const Up();
  late double opacity;

  @override
  void initState() {
    super.initState();
    final ticker = createTicker(onTick);
    this.ticker = ticker;

    opacity = widget.maxOpacity;
  }

  @override
  void dispose() {
    ticker.dispose();
    super.dispose();
  }

  void onTick(Duration duration) {
    final now = Services.of(context).calendar.now();
    switch (state) {
      case GoingUp(reference: final reference):
        final currentDurationMillis = now.millisecondsSinceEpoch - 
          reference.millisecondsSinceEpoch;
        final isUp = currentDurationMillis >= _durationMillis;
        if (isUp) {
          setState(() => opacity = widget.maxOpacity);
          state = const Up();
          ticker.stop();
        } else {
          setState(() => opacity = _calcOpacity(
            minOpacity: widget.minOpacity,
            maxOpacity: widget.maxOpacity,
            reference: reference,
            now: now
          ));
        }
      // case Down():
      //   setState(() => opacity = _minOpacity);
      // case Up():
      //   setState(() => opacity = _maxOpacity);
      default:
        throw "Illegal state when onTick was called: $state";
    }
  }

  void onTapDown() {
    switch (state) {
      case Up():
      case GoingUp():
        ticker.stop();
        setState(() => opacity = widget.minOpacity);
        state = const Down();
      default:
        break;
    }
  }

  void onTapUp({required bool cancelled}) {
    final now = Services.of(context).calendar.now();
    switch (state) {
      case Down():
        state = GoingUp(now);
        if (!cancelled) widget.onPressed?.call();
        ticker.start();
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: switch (state) {
        Down() => widget.minOpacity,
        GoingUp() => opacity,
        Up() => 1.0,
      },
      child: GestureDetector(
        onTapDown: (_) => switch (widget.onPressed) {
          null => null,
          _ => onTapDown
        },
        onTapUp: (_) => onTapUp(cancelled: false),
        onTapCancel: () => onTapUp(cancelled: true), 
        child: widget.child,
      )
    );
  }
}

sealed class State {
  const State();
}

class Down implements State {
  const Down();
}

class GoingUp implements State {
  final DateTime reference;

  const GoingUp(this.reference);
}

class Up implements State {
  const Up();
}
