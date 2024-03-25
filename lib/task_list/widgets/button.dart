import 'package:flutter/material.dart' hide Theme, BottomSheet;
import 'package:too_many_tasks/common/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/strings.dart';

class _Button extends StatelessWidget {
  final _key = GlobalKey();
  final IconData icon;
  final String text;
  final void Function() onTap;

  _Button(this.icon, this.text, this.onTap);
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      key: _key,
      onTap: () {
        final renderBox = _key.currentContext?.findRenderObject() as RenderBox;
        final offset = renderBox.localToGlobal(Offset.zero);
        print('offset here! $offset');
        onTap();
      },
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: theme.colors.onBackground400,
            ),
            Text(
              text,
              style: theme.textStyle(
                size: 16,
                color: theme.colors.onBackground400,
              )
            )
          ]
        ),
      ),
    );
  }
}

class SortButton extends StatelessWidget {
  final void Function() onTap;

  const SortButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final strings = Strings.of(context);
    return _Button(
      Icons.swap_vert_outlined,
      strings.task_list_sort_button,
      onTap,
    );
  }
}

class FilterButton extends StatelessWidget {
  final void Function() onTap;

  const FilterButton({super.key, required this.onTap});
  
  @override
  Widget build(BuildContext context) {
    final strings = Strings.of(context);
    return _Button(
      Icons.filter_alt_outlined,
      strings.task_list_filter_button,
      onTap,
    );
  }
}
