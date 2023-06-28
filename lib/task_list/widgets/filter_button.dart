import 'package:flutter/material.dart' hide Theme;
import 'package:too_many_tasks/common/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/strings.dart';

class FilterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = Strings.of(context);
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.filter_alt_outlined,
            color: theme.colors.onBackground400,
          ),
          Text(
            strings.task_list_filter_button,
            style: theme.textStyle(
              size: 16,
              color: theme.colors.onBackground400,
            )
          )
        ]
      ),
    );
  }
}