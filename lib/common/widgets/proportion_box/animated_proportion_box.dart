import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:too_many_tasks/common/widgets/proportion_box/proportion_box.dart';

class AnimatedProportionBox extends StatefulWidget {
  final Widget child;

  const AnimatedProportionBox({
    super.key,
    required this.child,
  });

  @override
  State<AnimatedProportionBox> createState() => _State();
}

class _State extends State<AnimatedProportionBox>
  with SingleTickerProviderStateMixin {
  double proportion = 1.0;

  late final Ticker ticker;

  @override
  void initState() {
    ticker = createTicker(onTick);
    ticker.start();
    super.initState();
  }

  @override
  void dispose() {
    ticker.dispose();
    super.dispose();
  }

  void onTick(Duration duration) {
    final proportion = (duration.inMilliseconds % 1000) / 1000;
    print("proportion $proportion");
    setState(() => this.proportion = proportion);
  }

  @override
  Widget build(BuildContext context) {
    return ProportionSize(
      heightProportion: proportion,
      child: widget.child,
    );
  }
}