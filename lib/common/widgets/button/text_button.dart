import 'package:flutter/widgets.dart';
import 'package:too_many_tasks/common/theme/theme.dart';
import 'package:too_many_tasks/common/widgets/button/button.dart';

import 'style.dart';

class TextButton extends StatelessWidget {
  final String text;
  final Style style;
  final void Function()? onPressed;

  const TextButton(
    this.text,
    {super.key,
    required this.style,
    required this.onPressed}
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Button(
      style: style,
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Center(
          child: Text(
            text,
            style: theme.textStyle(
              size: 12,
              weight: FontWeight.w500,
              color: switch (onPressed) {
                null => theme.colors.onDisabled,
                _ => switch (style) {
                  Style.primary => theme.colors.onPrimary,
                  Style.secondary => theme.colors.onSecondary,
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}