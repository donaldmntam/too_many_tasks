import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:too_many_tasks/common/overlay/bottom_sheet.dart';
import 'package:too_many_tasks/common/theme/theme.dart';
import './filter.dart';
import 'package:too_many_tasks/common/widgets/highlighted/highlighted.dart';

Color textColor(Theme theme) => theme.colors.onBackground400;

class FilterMenu extends StatefulWidget {
  final Filter? initialChosenFilter;
  final void Function(Filter?) shouldUpdateFilter;

  const FilterMenu({
    super.key,
    required this.initialChosenFilter,
    required this.shouldUpdateFilter,
  });

  @override
  State<FilterMenu> createState() => _State();
}

class _State extends State<FilterMenu> {
  late Filter? chosenFilter;

  @override
  void initState() {
    super.initState();
    chosenFilter = widget.initialChosenFilter;
  }

  void onTap(Filter? filter) {
    chosenFilter = filter;
    setState(() {});
    widget.shouldUpdateFilter(filter);
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
            const _TitleItem(),
            const SizedBox(height: 36),
            _NoFilterButtonItem(chosenFilter != null, onTap),
            const SizedBox(height: 16),
            _FilterItem(const DueToday(), chosenFilter, onTap),
            const SizedBox(height: 16),
            _FilterItem(const Overdue(), chosenFilter, onTap),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _TitleItem extends StatelessWidget {
  const _TitleItem();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Icon(
        //   Icons.filter_alt_outlined,
        //   color: theme.colors.onBackground400,
        //   size: 32,
        // ),
        // const SizedBox(width: 10),
        Highlighted(
          // TODO: translation
          'Filter',
          style: theme.textStyle(
            size: 24,
            color: textColor(theme),
            weight: FontWeight.bold,
            // decoration: TextDecoration.underline,
            // decorationStyle: TextDecorationStyle.wavy,
          ),
        ),
      ],
    );
  }
}

class _NoFilterButtonItem extends StatelessWidget {
  final bool hasFilterChosen;
  final void Function(Filter?) onTap;

  const _NoFilterButtonItem(
    this.hasFilterChosen,
    this.onTap,
  );

  @override
  Widget build(BuildContext context) {
    return _Item(
      // TODO: translation
      'None',
      !hasFilterChosen,
      () => onTap(null),
    );
  }
}

class _FilterItem extends StatelessWidget {
  final Filter filter;
  final Filter? chosenFilter;
  final void Function(Filter) onTap;

  const _FilterItem(
    this.filter,
    this.chosenFilter,
    this.onTap,
  );

  @override
  Widget build(BuildContext context) {
    final chosenFilter = this.chosenFilter;

    return _Item(
      filter.title,
      chosenFilter != null && filter.isSameFilterAs(chosenFilter),
      () => onTap(filter),
    );
  }
}

class _Item extends StatelessWidget {
  final String title;
  final bool chosen;
  final void Function() onTap;

  const _Item(this.title, this.chosen, this.onTap);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
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
