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
  void Function(int id) onPinPressed,
  void Function(int id) onEditPressed,
  void Function(int id) onCheckMarkPressed,
  void Function(int id) onRemove,
});

extension ExtendedListener on Listener {
  Listener copy({
    void Function(int id)? onPinPressed,
    void Function(int id)? onEditPressed,
    void Function(int id)? onCheckMarkPressed,
    void Function(int id)? onRemove,
  }) => (
    onPinPressed: onPinPressed ?? this.onPinPressed,
    onEditPressed: onEditPressed ?? this.onEditPressed,
    onCheckMarkPressed: onCheckMarkPressed ?? this.onCheckMarkPressed,
    onRemove: onRemove ?? this.onRemove,
  );
}

class TaskCard extends StatelessWidget {
  final Task task;
  final Listener listener;

  const TaskCard(
    this.task,
    this.listener,
    {super.key}
  );

  @override
  Widget build(BuildContext context) {
    return _Background(   
      task: task,
      listener: listener,
      child: Padding(
        padding: _padding,
        child: Row(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: _Body(task, listener),
            ),
            CheckMark(task, listener),
          ]
        ),
      )
    );   
  }
}

class _Background extends StatelessWidget {
  final Task task;
  final Listener listener;
  final Widget child;

  const _Background({
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
          onFullySwipedLeft: () => listener.onRemove(task.id),
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
  final Task task;
  final Listener listener;

  const _Body(
    this.task,
    this.listener,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Title(task, listener),
        const SizedBox(height: 8),
        _DueDate(task),
      ]
    );
  }
}

class _Title extends StatelessWidget {
  final Task task;
  final Listener listener;

  const _Title(
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
          onTap: () => listener.onPinPressed(task.id),
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
          onTap: () => listener.onEditPressed(task.id),
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
  final Task task;

  const _DueDate(this.task);

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

const opacityCurve = Curves.easeInQuad;
class _SwipeableBackground extends StatelessWidget {
  final BackgroundBuilderDetails details;

  const _SwipeableBackground(this.details);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      // color: switch (details) {
      //   DraggingBackgroundBuilderDetails(
      //     animationValue: final relativeOffset,
      //   ) => Color.fromARGB((255 * relativeOffset).toInt(), 0, 0, 0),
      //   ReleasedBackgroundBuilderDetails(
      //     thresholdReached: final thresholdReached,
      //   ) => thresholdReached ? Colors.green : Colors.red,
      // },
      color: switch (details) {
        DraggingBackgroundBuilderDetails() => theme.colors.surface,
        ReleasedBackgroundBuilderDetails(
          thresholdReached: final thresholdReached,
        ) => thresholdReached ? Colors.red : theme.colors.surface,
      },
      child: Opacity(
        opacity: switch (details) {
          DraggingBackgroundBuilderDetails(
            animationValue: final animationValue
          ) => opacityCurve.transform(animationValue),
          ReleasedBackgroundBuilderDetails(
            animationValue: final animationValue,
            thresholdReached: final thresholdReached,
          ) => thresholdReached ? 1 : opacityCurve.transform(animationValue),
        },
        child: Icon(
          Icons.delete,
          color: switch (details) {
            DraggingBackgroundBuilderDetails() => theme.colors.error,
            ReleasedBackgroundBuilderDetails(
              thresholdReached: final thresholdReached,
            ) => thresholdReached 
              ? theme.colors.onError
              : theme.colors.error,
          },
        )
      )
    );
  }
}
