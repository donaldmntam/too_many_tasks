import 'dart:math';

import 'package:flutter/material.dart' hide Theme, Widget;
import 'package:flutter/widgets.dart' as flutter show Widget;
import 'package:too_many_tasks/common/functions/date_functions.dart';
import 'package:too_many_tasks/common/models/task.dart';
import 'package:too_many_tasks/common/services/services.dart';
import 'package:too_many_tasks/common/theme/theme.dart';

const _headerWidth = 32.0;
const _checkboxSize = 42.0;
final _borderRadius = BorderRadius.circular(12);
const _padding = EdgeInsets.all(14);

abstract interface class Listener {
  void onPinPressed(int index);
  void onEditPressed(int index);
  void onCheckmarkPressed(int index);
}

typedef Data = ({int index, Task task, bool pinned});

class Widget extends StatelessWidget {
  final Data data;
  final Listener listener;

  const Widget(
    this.data,
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
              child: _Body(data, listener),
            ),
            _CheckMark(data, listener),
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
        clipBehavior: Clip.antiAlias,
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
  final Data data;
  final Listener listener;

  const _Body(
    this.data,
    this.listener,
  );

  @override
  flutter.Widget build(BuildContext context) {
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
  flutter.Widget build(BuildContext context) {
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
  flutter.Widget build(BuildContext context) {
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

class _CheckMark extends StatelessWidget {
  final Data data;
  final Listener listener;

  const _CheckMark(
    this.data,
    this.listener,
  );

  @override
  flutter.Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => listener.onCheckmarkPressed(data.index),
      child: Container(
        width: _checkboxSize,
        height: _checkboxSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.colors.secondary,
        ),
        child: data.task.done ? Center(
          child: Icon( // TODO: use figma's
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