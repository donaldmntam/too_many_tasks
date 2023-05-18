import 'package:flutter/material.dart' hide Theme;
import 'package:too_many_tasks/common/theme/theme.dart';

const _buttonSize = 32.0;
const _columnSpacing = 16.0;
const _rowSpacing = 8.0;

class DialogScaffold extends StatelessWidget {
  final String title;
  final Widget child;

  const DialogScaffold({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: _columnSpacing),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  const SizedBox(width: _buttonSize + _rowSpacing),
                  Flexible(flex: 1, child: _Title(title)),
                  const SizedBox(width: _rowSpacing),
                  SizedBox(
                    width: _buttonSize,
                    height: _buttonSize,
                    child: IconButton(
                      onPressed: () => navigator.pop(),
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.close,
                        color: theme.colors.onSurface400,
                        size: _buttonSize,
                      ),
                    ),
                  )
                ],
              ),
            ),
            child,
          ]
        );
      }
    );
  }
}

class _Title extends StatelessWidget {
  final String text;

  const _Title(this.text);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                style: theme.textStyle(
                  size: 16,
                  weight: FontWeight.w500,
                  color: theme.colors.onSurface400,
                ),
              )
            ]
          ),
        ),
      ),
    );
  }
}