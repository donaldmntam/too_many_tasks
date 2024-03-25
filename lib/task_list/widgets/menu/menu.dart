import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:too_many_tasks/common/overlay/bottom_sheet.dart';
import 'package:too_many_tasks/common/theme/theme.dart';
import 'package:too_many_tasks/common/widgets/highlighted/highlighted.dart';
import 'package:too_many_tasks/common/functions/iterable_functions.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

Color textColor(Theme theme) => theme.colors.onBackground400;

class Menu extends StatefulWidget {
  final String title;
  final List<String> items;
  final int initialChosenIndex;
  final void Function(int) didSelectItem;

  const Menu({
    super.key,
    required this.title,
    required this.items,
    required this.initialChosenIndex,
    required this.didSelectItem,
  });

  @override
  State<Menu> createState() => _State();
}

class _State extends State<Menu> {
  late int chosenIndex;

  @override
  void initState() {
    super.initState();
    chosenIndex = widget.initialChosenIndex;
  }

  void onTap(int index) {
    chosenIndex = index;
    setState(() {});
    widget.didSelectItem(index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        width: double.infinity,
        decoration: theme.bottomSheetDecoration,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 36),
            _TitleItem(widget.title),
            const SizedBox(height: 36),
            ...widget.items.mapIndexed<Widget>((item, i) =>
              _Item(i, item, chosenIndex == i, widget.didSelectItem),
            ).toList().addBetween(const SizedBox(height: 16)),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _TitleItem extends StatelessWidget {
  final String title;
  
  const _TitleItem(this.title);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Highlighted(
          title,
          style: theme.textStyle(
            size: 24,
            color: textColor(theme),
            weight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _Item extends StatelessWidget {
  final int index;
  final String title;
  final bool chosen;
  final void Function(int) onTap;

  const _Item(this.index, this.title, this.chosen, this.onTap);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(index),
      child: Row(
        children: [
          Icon(
            size: 26,
            color: theme.colors.primary,
            chosen 
              ? Icons.radio_button_checked
              : Icons.radio_button_unchecked,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: theme.textStyle(
              color: textColor(theme),
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
