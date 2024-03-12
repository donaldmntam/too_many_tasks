import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Icons, Colors;
import 'package:too_many_tasks/common/overlay/bottom_sheet.dart';
import 'package:too_many_tasks/common/theme/theme.dart';
import 'package:too_many_tasks/common/functions/list_functions.dart';
import './filter.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        width: double.infinity,
        decoration: theme.bottomSheetDecoration,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _ClearButtonItem(chosenFilter != null, onTap),
            _FilterItem(const DueToday(), chosenFilter, onTap),
            _FilterItem(const Paused(), chosenFilter, onTap),
            _FilterItem(const Overdue(), chosenFilter, onTap),
          ].surroundEach((_) => const SizedBox(height: 16)),
        ),
      ),
    );
  }
}

class _ClearButtonItem extends StatelessWidget {
  final bool hasFilterChosen;
  final void Function(Filter?) onTap;

  const _ClearButtonItem(
    this.hasFilterChosen,
    this.onTap,
  );

  @override
  Widget build(BuildContext context) {
    return _Item(
      // TODO: translation
      'Clear',
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
            chosen 
              ? Icons.radio_button_checked
              : Icons.radio_button_unchecked,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: theme.textStyle(
              color: theme.colors.onBackground400,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
