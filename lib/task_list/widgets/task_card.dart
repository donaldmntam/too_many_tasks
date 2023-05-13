import 'package:flutter/material.dart' hide Theme;
import 'package:flutter/widgets.dart';
import 'package:too_many_tasks/common/theme/theme.dart';

const _headerWidth = 30.0;
const _checkboxSize = 30.0;

class TaskCard extends StatelessWidget {
  const TaskCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IntrinsicHeight(
      child: Container(
        decoration: BoxDecoration(
          color: theme.colors.surface,
        ),
        child: Row(
          children: [
            Container(
              color: theme.colors.secondary,
              height: double.infinity,
              width: _headerWidth,
            ),
            SizedBox(width: 24),
            const Flexible(flex: 1, fit: FlexFit.tight, child: _Body()),
            const _CheckMark(),
          ]
        )
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Title(),
        _DueDate()
      ]
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      "Task Title",
      style: theme.textStyle(
        size: 16,
        weight: FontWeight.w400,
        color: theme.colors.onSurface400,
      )
    );
  }
}

class _DueDate extends StatelessWidget {
  const _DueDate();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.schedule,
          color: theme.colors.onSurface400,
        ),
        Text(
          "2023-05-02"
        ),
      ]
    );
  }
}

class _CheckMark extends StatelessWidget {
  const _CheckMark();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colors.secondary,
      ),
      child: Icon(
        Icons.check,
        color: theme.colors.onSecondary,
        size: _checkboxSize,
      )
    );
  }
}