import 'package:flutter/material.dart' hide Theme;
import 'package:too_many_tasks/common/theme/theme.dart';

import 'constants.dart';

const _padding = EdgeInsets.symmetric(horizontal: 10, vertical: 8);

class PresetRow extends StatelessWidget {
  final List<String> items;

  const PresetRow({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IntrinsicHeight(
      child: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row( 
              children: _widgets(items),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: horizontalPadding,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [theme.colors.surface, const Color(0x00FFFFFF)],
                  stops: const [0.2, 1.0],
                )
              )
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: horizontalPadding,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [const Color(0x00FFFFFF), theme.colors.surface],
                  stops: const [0.0, 0.8],
                )
              )
            ),
          ),
        ],
      ),
    );
  }
}

List<Widget> _widgets(List<String> items) {
  final widgets = List<Widget>.empty(growable: true);
  widgets.add(const SizedBox(width: horizontalPadding));
  for (var i = 0; i < items.length; i++) {
    final item = items[i];
    widgets.add(_Item(item));
    if (i == items.length - 1) continue;
    widgets.add(const SizedBox(width: 4));
  }
  widgets.add(const SizedBox(width: horizontalPadding));
  return widgets;
}

class _Item extends StatelessWidget {
  final String text;

  const _Item(this.text);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: _padding,
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colors.primary,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: theme.textStyle(
          size: 10,
          weight: FontWeight.w400,
          color: theme.colors.primary,
        ),
      ),
    );
  }
}