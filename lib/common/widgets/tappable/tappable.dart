import 'dart:math';

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart' hide State;
import 'package:flutter/widgets.dart' as widgets show State;
import 'package:too_many_tasks/common/services/services.dart';

const _minOpacity = 0.0;
const _maxOpacity = 1.0;
const _durationMillis = 300;
const _opacityRate = (_maxOpacity - _minOpacity) / _durationMillis;

class Tappable extends StatefulWidget {
  final void Function() onPressed;
  final Widget child;

  const Tappable({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  widgets.State<StatefulWidget> createState() => _State();
}

class _State extends widgets.State<Tappable> with SingleTickerProviderStateMixin {
  late final Ticker ticker;
  State state = const Up();
  double opacity = _maxOpacity;

  @override
  void initState() {
    super.initState();
    final ticker = createTicker(onTick);
    this.ticker = ticker;
  }

  @override
  void dispose() {
    ticker.dispose();
    super.dispose();
  }

  void onTick(Duration duration) {
    final now = Services.of(context).clock.now();
    switch (state) {
      case GoingUp(reference: final reference):
        final currentDurationMillis = now.millisecondsSinceEpoch - 
          reference.millisecondsSinceEpoch;
        final isUp = currentDurationMillis >= _durationMillis;
        if (isUp) {
          setState(() => opacity = _maxOpacity);
          state = const Up();
          ticker.stop();
        } else {
          setState(() => opacity = calcOpacity(reference, now));
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
        setState(() => opacity = _minOpacity);
        state = const Down();
      default:
        break;
    }
  }

  void onTapUp() {
    final now = Services.of(context).clock.now();
    switch (state) {
      case Down():
        state = GoingUp(now);
        widget.onPressed();
        ticker.start();
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: switch (state) {
        Down() => _minOpacity,
        GoingUp() => opacity,
        Up() => 1.0,
      },
      child: GestureDetector(
        onTapDown: (_) => onTapDown(),
        onTapUp: (_) => onTapUp(),
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

double calcOpacity(DateTime reference, DateTime now) {
  return (now.millisecondsSinceEpoch - reference.millisecondsSinceEpoch) * 
    _opacityRate + _minOpacity;
}