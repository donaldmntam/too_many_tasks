import 'dart:math';

import 'package:flutter/material.dart' hide Theme, Widget;
import 'package:flutter/widgets.dart' as flutter show Widget;
import 'package:too_many_tasks/common/functions/date_functions.dart';
import 'package:too_many_tasks/common/models/task.dart';
import 'package:too_many_tasks/common/theme/theme.dart';

const _headerWidth = 32.0;
const _checkboxSize = 42.0;
final _borderRadius = BorderRadius.circular(12);
const _padding = EdgeInsets.all(14);

abstract interface class Listener {
  void onPinPressed();
  void onEditPressed();
  void onCheckmarkPressed();
}

class Widget extends StatelessWidget {
  final Task task;
  final Listener listener;

  const Widget(
    this.task,
    this.listener,
    {super.key}
  );

  @override
  flutter.Widget build(BuildContext context) {
    return _Background(
      child: Padding(
        padding: _padding,
        child: Row(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: _Body(task, listener),
            ),
            _CheckMark(task, listener),
          ]
        ),
      )
    );   
  }
}

class _Background extends StatelessWidget {
  final flutter.Widget child;

  const _Background({required this.child});

  @override
  flutter.Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IntrinsicHeight(
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: theme.colors.surface,
          borderRadius: _borderRadius,
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
        )
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
  flutter.Widget build(BuildContext context) {
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
  flutter.Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final theme = Theme.of(context);
    return Row(
      children: [
        GestureDetector(
          onTap: () => listener.onPinPressed(),
          child: Transform.rotate(
            angle: task.pinned ? 0 : pi * 0.5 * 3.5,
            child: Icon(
              Icons.push_pin_outlined,
              size: 18 * media.textScaleFactor,
              color: task.pinned
                ? theme.colors.onSurface400
                : theme.colors.onSurface100,
            ),
          ),
        ),
        SizedBox(width: 4 * media.textScaleFactor),
        Text(
          task.title,
          style: theme.textStyle(
            size: 16,
            weight: FontWeight.w400,
            color: theme.colors.onSurface400,
          ),
        ),
        SizedBox(width: 4 * media.textScaleFactor),
        GestureDetector(
          onTap: () => listener.onEditPressed(),
          child: Icon(
            Icons.edit_outlined,
            size: 18 * media.textScaleFactor,
            color: theme.colors.onSurface400,
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
  flutter.Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final theme = Theme.of(context);
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.schedule,
            color: theme.colors.onSurface400,
            size: 14 * media.textScaleFactor,
          ),
          SizedBox(width: 4 * media.textScaleFactor),
          Text(
            task.dueDate.toFormattedString(),
          ),
        ]
      ),
    );
  }
}

class _CheckMark extends StatelessWidget {
  final Task task;
  final Listener listener;

  const _CheckMark(
    this.task,
    this.listener,
  );

  @override
  flutter.Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: listener.onCheckmarkPressed,
      child: Container(
        width: _checkboxSize,
        height: _checkboxSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.colors.secondary,
        ),
        child: task.done ? Center(
          child: Icon(
            Icons.check,
            color: theme.colors.onSecondary,
            size: _checkboxSize - 12,
          ),
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