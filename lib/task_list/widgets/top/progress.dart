import 'package:flutter/material.dart' hide Theme;
import 'package:flutter_gen/gen_l10n/strings.dart';
import 'package:too_many_tasks/common/theme/theme.dart';

const _barHeight = 10.0;
const _percentageHeight = 18.0;
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
        Flexible(
          flex: 1,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 1,
                child: SizedBox(
                  height: _barHeight,
                  child: _Bar(progress ?? 0)
                )
              ),
              const SizedBox(width: 4),
              SizedBox(
                height: _percentageHeight,
                child: AspectRatio(
                  aspectRatio: 2,
                  child: _Percentage(progress ?? 0)
                ),
              ),
            ],
          )
        ),
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

class _Percentage extends StatelessWidget {
  final double progress;

  const _Percentage(this.progress);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FittedBox(
      fit: BoxFit.contain,
      child: Text(
        "${(progress * 100).round()}%",
        style: theme.textStyle(
          color: theme.colors.onPrimary,
          size: 14,
          weight: FontWeight.normal,
        )
      )
    );
  }
}