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
  late bool checked;

  late final AnimationController controller;

  @override
  void initState() {
    final done = widget.data.task.done;
    checked = done;

    controller = AnimationController(vsync: this);
    controller.duration = const Duration(milliseconds: 1000);    

    if (done) {
      controller.forward();
    } else {
      controller.value = controller.upperBound;
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
    final done = widget.data.task.done;
    if (checked != done) {
      setState(() {
        checked = done;
        if (done) {
          controller.forward();
        } else {
          controller.reset();
        }
      });
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  widgets.Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => widget.listener.onCheckMarkPressed(widget.data.index),
      child: Container(
        width: _checkboxSize,
        height: _checkboxSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.colors.secondary,
        ),
        child: checked ? Center(
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
