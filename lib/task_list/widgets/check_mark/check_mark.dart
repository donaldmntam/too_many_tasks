import 'package:flutter/widgets.dart' hide Listener, Widget;
import 'package:flutter/widgets.dart' as widgets show Widget;
import 'package:lottie/lottie.dart';
import 'package:too_many_tasks/common/theme/theme.dart';
import 'package:too_many_tasks/task_list/widgets/task_card.dart';

const _checkboxSize = 42.0;

class CheckMark extends StatefulWidget {
  final Data data;
  final Listener listener;

  const CheckMark(
    this.data,
    this.listener,
    {super.key}
  );

  @override
  State<CheckMark> createState() => _CheckMarkState();
}

class _CheckMarkState extends State<CheckMark> with TickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    final done = widget.data.task.done;

    controller = AnimationController(
      vsync: this,
      upperBound: 0.6,
    );
    controller.duration = const Duration(milliseconds: 1000);

    if (done) {
      controller.value = controller.upperBound;
    } else {
      controller.value = controller.lowerBound;
    }

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  void didUpdateWidget(CheckMark oldWidget) {
    final newDone = widget.data.task.done;
    if (newDone != oldWidget.data.task.done) {
      if (newDone) {
        controller.forward();
      } else {
        controller.reverse();
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  widgets.Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => widget.listener.onCheckMarkPressed(widget.data.index),
      child: SizedBox(
        width: _checkboxSize,
        height: _checkboxSize,
        // decoration: BoxDecoration(
        //   shape: BoxShape.circle,
        //   color: theme.colors.secondary,
        // ),
        child: widget.data.task.done || true ? Center(
          child: Lottie.asset(          
            'assets/lottie/task_card_check_mark_check.json',
            controller: controller,
            width: _checkboxSize,
            height: _checkboxSize,
          )
        ) : Padding(
          padding: const EdgeInsets.all(6),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration( 
              shape: BoxShape.circle,
              color: theme.colors.surface,
            )
          ),
        )
      ),
    );
  }
}
