import 'package:flutter/widgets.dart';
import 'package:too_many_tasks/common/theme/theme.dart';
import 'package:too_many_tasks/common/widgets/tappable/tappable.dart';

import 'style.dart';

class Button extends StatelessWidget {
  final Style style;
  final void Function()? onPressed;
  final Widget child;

  const Button({
    super.key,
    required this.style,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Tappable(
      onPressed: onPressed,
      child: Container(
        decoration: ShapeDecoration(
          shape: const StadiumBorder(),
          color: switch (onPressed) {
            null => theme.colors.disabled,
            _ => switch (style) {
              Style.primary => theme.colors.primary,
              Style.secondary => theme.colors.secondary,
            }
          },
        ),
        child: child,
      )
    );
  }
}