import 'dart:math';

import 'package:flutter/material.dart' hide Theme, State;
import 'package:too_many_tasks/common/functions/date_functions.dart';
import 'package:too_many_tasks/common/models/task.dart';
import 'package:too_many_tasks/common/services/services.dart';
import 'package:too_many_tasks/common/theme/theme.dart';
import 'package:too_many_tasks/common/widgets/swipeable/details.dart';
import 'package:too_many_tasks/common/widgets/swipeable/swipeable.dart';
import 'package:flutter_gen/gen_l10n/strings.dart';

import '../check_mark/check_mark.dart';

const _headerWidth = 32.0;
final _borderRadius = BorderRadius.circular(12);
const _padding = EdgeInsets.all(14);

typedef Listener = ({
  void Function(int index) onPinPressed,
  void Function(int index) onEditPressed,
  void Function(int index) onCheckMarkPressed,
  void Function(int index) onRemove,
});

class TaskCard extends StatelessWidget {
  final int index;
  final Task task;
  final Listener listener;

  const TaskCard(
    this.index,
    this.task,
    this.listener,
    {super.key}
  );

  @override
  Widget build(BuildContext context) {
    return _Background(   
      index: index,     
      task: task,
      listener: listener,
      child: Padding(
        padding: _padding,
        child: Row(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: _Body(index, task, listener),
            ),
            CheckMark(index, task, listener),
          ]
        ),
      )
    );   
  }
}

class _Background extends StatelessWidget {
  final int index;
  final Task task;
  final Listener listener;
  final Widget child;

  const _Background({
    required this.index,
    required this.task,
    required this.listener,
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IntrinsicHeight(
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: _borderRadius,
          boxShadow: [theme.boxShadow()],
        ),
        child: Swipeable(
          leftBackgroundBuilder: _SwipeableBackground.new,
          onThresholdReached: () => listener.onRemove(index),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: theme.colors.surface,
              boxShadow: [theme.boxShadow()],
            ),
            child: Row(
              children: [
                Container(
                  color: theme.colors.secondary,
                  height: double.infinity,
                  width: _headerWidth,
                ),
                Flexible(flex: 1, child: child),
              ]
            ),
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final int index;
  final Task task;
  final Listener listener;

  const _Body(
    this.index,
    this.task,
    this.listener,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Title(index, task, listener),
        const SizedBox(height: 8),
        _DueDate(index, task),
      ]
    );
  }
}

class _Title extends StatelessWidget {
  final int index;
  final Task task;
  final Listener listener;

  const _Title(
    this.index,
    this.task,
    this.listener,
  );
  
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final theme = Theme.of(context);
    return Row(
      children: [
        GestureDetector(
          onTap: () => listener.onPinPressed(index),
          child: Transform.rotate(
            angle: task.pinned ? 0 : pi * 0.5 * 3.5,
            child: Icon(
              Icons.push_pin_outlined,
              size: 18 * media.textScaleFactor,
              color: task.pinned
                ? theme.colors.onBackground400
                : theme.colors.onBackground100,
            ),
          ),
        ),
        SizedBox(width: 4 * media.textScaleFactor),
        Text(
          task.name,
          style: theme.textStyle(
            size: 16,
            weight: FontWeight.w400,
            color: theme.colors.onBackground400,
          ),
        ),
        SizedBox(width: 4 * media.textScaleFactor),
        GestureDetector(
          onTap: () => listener.onEditPressed(index),
          child: Icon(
            Icons.edit_outlined,
            size: 18 * media.textScaleFactor,
            color: theme.colors.onBackground400,
          ),
        )
      ],
    );
  }
}

class _DueDate extends StatelessWidget {
  final int number;
  final Task task;

  const _DueDate(this.number, this.task);

  @override
  Widget build(BuildContext context) {
    final strings = Strings.of(context);
    final media = MediaQuery.of(context);
    final theme = Theme.of(context);
    final services = Services.of(context);
    final overdue = services.calendar.today().isAfter(task.dueDate);
    final text = switch (overdue) {
      true => strings.task_card_overdue,
      false => task.dueDate.toFormattedString(),
    };
    final textColor = switch (overdue) {
      true => theme.colors.error,
      false => theme.colors.onBackground400,
    };

    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.schedule,
            color: theme.colors.onBackground400,
            size: 14 * media.textScaleFactor,
          ),
          SizedBox(width: 4 * media.textScaleFactor),
          Text(
            text,
            style: theme.textStyle(
              size: 12,
              weight: FontWeight.w400,
              color: textColor,
            )
          ),
        ]
      ),
    );
  }
}

class _SwipeableBackground extends StatelessWidget {
  final BackgroundBuilderDetails details;

  const _SwipeableBackground(this.details);

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
