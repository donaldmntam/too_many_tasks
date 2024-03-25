import 'package:flutter/widgets.dart';
import 'package:too_many_tasks/common/models/filter.dart';
import 'package:flutter_gen/gen_l10n/strings.dart';
import './menu.dart';
import 'package:too_many_tasks/common/functions/iterable_functions.dart';
import 'package:too_many_tasks/common/monads/optional.dart';

class FilterMenu extends StatelessWidget {
  final Filter? initialChosenFilter;
  final void Function(Filter?) shouldUpdateFilter;

  const FilterMenu({
    super.key,
    required this.initialChosenFilter,
    required this.shouldUpdateFilter,
  });

  @override
  Widget build(BuildContext context) {
    final strings = Strings.of(context);
    final buttons = <_Button>[
      _Button(strings.task_list_filter_menu_none_button, null),
      _Button(strings.task_list_filter_menu_due_today_button, const DueToday()),
      _Button(strings.task_list_filter_menu_paused_button, const Paused()),
      _Button(strings.task_list_filter_menu_overdue_button, const Overdue()),
    ];
    final (index, _) = buttons.find((button) {
      final filter = button.filter;  
      final initialChosenFilter = this.initialChosenFilter;
      if (filter != null && initialChosenFilter != null) {
        return filter.isSameFilterAs(initialChosenFilter);
      }
      return filter == null && initialChosenFilter == null;
    }).unwrap();
    return Menu(
      title: strings.task_list_filter_menu_title,
      items: buttons.map((button) => button.title).toList(),
      initialChosenIndex: index,
      didSelectItem: (i) => shouldUpdateFilter(buttons[i].filter),
    );
  }
}

class _Button {
  final String title;
  final Filter? filter;

  const _Button(this.title, this.filter);
}
