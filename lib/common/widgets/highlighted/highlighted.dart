import 'package:flutter/widgets.dart';
import 'package:too_many_tasks/common/theme/theme.dart';

class Highlighted extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const Highlighted(this.text, {super.key, this.style});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultStyle = theme.textStyle(
      size: 16,
      weight: FontWeight.w500,
      color: theme.colors.onBackground400,
    );
    return Align(
      alignment: Alignment.center,
      child: IntrinsicWidth(
        child: IntrinsicHeight(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                  heightFactor: 0.6,
                  widthFactor: 1.0,
                  child: Container(
                    color: theme.colors.primary.withAlpha((255 * 0.5).toInt())
                  ),
                ),
              ),
              Text(
                text,
                style: style ?? defaultStyle,
              )
            ]
          ),
        ),
      ),
    );
  }
}
