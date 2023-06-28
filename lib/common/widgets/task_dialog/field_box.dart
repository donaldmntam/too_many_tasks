import 'package:flutter/material.dart' hide Theme;
import 'package:flutter/widgets.dart';
import 'package:too_many_tasks/common/theme/theme.dart';
import 'package:too_many_tasks/common/widgets/task_dialog/preset_row.dart';

const _iconSize = 28.0;

class FieldBox extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const FieldBox({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textStyle(
            size: 10,
            weight: FontWeight.w500,
            color: theme.colors.onBackground100
          ),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: theme.colors.onBackground100),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: child,
              ),
              SizedBox(
                width: _iconSize,
                height: _iconSize,
                child: Icon(
                  icon,
                  color: theme.colors.onBackground100,
                  size: _iconSize - 10,
                )
              )
            ],
          ),
        ),
      ]
    );
  }
}