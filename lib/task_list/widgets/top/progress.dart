import 'package:flutter/material.dart' hide Theme;
import 'package:flutter_gen/gen_l10n/strings.dart';
import 'package:too_many_tasks/common/theme/theme.dart';

const _barHeight = 10.0;
const _barFillColor = Color(0x70FFFFFF);

class Progress extends StatelessWidget {
  final double? progress;

  const Progress(
    this.progress,
    {super.key}
  );

  @override
  Widget build(BuildContext context) {
    final strings = Strings.of(context);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        FittedBox(
          fit: BoxFit.contain,
          child: Text(
            strings.task_list_progress,
            style: theme.textStyle(
              size: 24,
              weight: FontWeight.w500,
              color: theme.colors.onPrimary,
            )
          ),
        ),
        const SizedBox(height: 4),
        _Bar(progress ?? 0),
      ]
    );
  }
}

class _Bar extends StatelessWidget {
  final double progress;

  const _Bar(this.progress);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: _barHeight,
      decoration: ShapeDecoration(
        color: theme.colors.primary,
        shape: StadiumBorder(
          side: BorderSide(color: theme.colors.onPrimary)
        ),
      ),
      child: LayoutBuilder(
        builder: (_, constraints) => Row(
          children: [
            Container(
              width: constraints.maxWidth * progress,
              color: _barFillColor,
            ),
          ]
        ),
      ),
    );
  }
}