import 'dart:math';

import 'package:flutter/material.dart' hide Theme;
import 'package:lottie/lottie.dart';
import 'package:too_many_tasks/common/functions/date_functions.dart';
import 'package:too_many_tasks/common/functions/scope_functions.dart';
import 'package:too_many_tasks/common/models/task.dart';
import 'package:too_many_tasks/common/services/services.dart';
import 'package:too_many_tasks/common/theme/theme.dart';
import 'package:too_many_tasks/common/widgets/swipeable/details.dart';
import 'package:too_many_tasks/common/widgets/swipeable/swipeable.dart';

import 'check_mark/check_mark.dart';

const _headerWidth = 32.0;
final _borderRadius = BorderRadius.circular(12);
const _padding = EdgeInsets.all(14);

abstract interface class Listener {
  void onPinPressed(int index);
  void onEditPressed(int index);
  void onCheckMarkPressed(int index);
  void onRemove(int index);
}

typedef Data = ({int index, Task task, bool pinned});

class TaskCard extends StatelessWidget {
  final Data data;
  final Listener listener;

  const TaskCard(
    this.data,
    this.listener,
    {super.key}
  );

  @override
  Widget build(BuildContext context) {
    return _Background(        
      data: data,
      listener: listener,
      child: Padding(
        padding: _padding,
        child: Row(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: _Body(data, listener),
            ),
            CheckMark(data, listener),
          ]
        ),
      )
    );   
  }
}

class _Background extends StatelessWidget {
  final Data data;
  final Listener listener;
  final Widget child;

  const _Background({
    required this.data,
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
          onThresholdReached: () => listener.onRemove(data.index),
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
  final Data data;
  final Listener listener;

  const _Body(
    this.data,
    this.listener,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Title(data, listener),
        const SizedBox(height: 8),
        _DueDate(data),
      ]
    );
  }
}

class _Title extends StatelessWidget {
  final Data data;
  final Listener listener;

  const _Title(
    this.data,
    this.listener,
  );
  
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final theme = Theme.of(context);
    return Row(
      children: [
        GestureDetector(
          onTap: () => listener.onPinPressed(data.index),
          child: Transform.rotate(
            angle: data.pinned ? 0 : pi * 0.5 * 3.5,
            child: Icon(
              Icons.push_pin_outlined,
              size: 18 * media.textScaleFactor,
              color: data.pinned
                ? theme.colors.onBackground400
                : theme.colors.onBackground100,
            ),
          ),
        ),
        SizedBox(width: 4 * media.textScaleFactor),
        Text(
          data.task.name,
          style: theme.textStyle(
            size: 16,
            weight: FontWeight.w400,
            color: theme.colors.onBackground400,
          ),
        ),
        SizedBox(width: 4 * media.textScaleFactor),
        GestureDetector(
          onTap: () => listener.onEditPressed(data.index),
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
  final Data data;

  const _DueDate(this.data);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final theme = Theme.of(context);
    final services = Services.of(context);
    final overdue = data.task.dueDate.isAfter(services.clock.now());
    final text = switch (overdue) {
      true => "Overdue", // TODO: localization!
      false => data.task.dueDate.toFormattedString(),
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
