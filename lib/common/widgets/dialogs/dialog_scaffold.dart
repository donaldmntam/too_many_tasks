import 'package:flutter/material.dart' hide Theme;
import 'package:too_many_tasks/common/theme/theme.dart';
import 'package:too_many_tasks/common/widgets/tappable/tappable.dart';
import 'package:too_many_tasks/common/widgets/highlighted/highlighted.dart';

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
                  Flexible(flex: 1, child: Highlighted(title)),
                  const SizedBox(width: _rowSpacing),
                  SizedBox(
                    width: _buttonSize,
                    height: _buttonSize,
                    child: Tappable(
                      onPressed: () => navigator.pop(),
                      child: Icon(
                        Icons.close,
                        color: theme.colors.onBackground400,
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
