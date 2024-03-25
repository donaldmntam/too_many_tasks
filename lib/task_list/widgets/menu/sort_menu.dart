import 'package:flutter/widgets.dart';
import 'package:too_many_tasks/common/models/sort.dart';
import 'package:flutter_gen/gen_l10n/strings.dart';
import './menu.dart';
import 'package:too_many_tasks/common/functions/iterable_functions.dart';
import 'package:too_many_tasks/common/monads/optional.dart';

class SortMenu extends StatelessWidget {
  final Sort? initialChosenSort;
  final void Function(Sort?) shouldUpdateFilter;

  const SortMenu({
    super.key,
    required this.initialChosenSort,
    required this.shouldUpdateFilter,
  });

  @override
  Widget build(BuildContext context) {
    final strings = Strings.of(context);
    final buttons = <_Button>[
      _Button(strings.task_list_sort_menu_due_date_button, const DueDate()),
      _Button(
        strings.task_list_sort_menu_task_name_by_ascending_order_button, 
        const AscendingTaskName(),
      ),
      _Button(
        strings.task_list_sort_menu_task_name_by_descending_order_button,
        const DescendingTaskName(),
      ),
    ];
    final (index, _) = buttons.find((button) {
      final sort = button.sort;  
      final initialChosenSort = this.initialChosenSort;
      if (sort != null && initialChosenSort != null) {
        return sort.isSameSortAs(initialChosenSort);
      }
      return sort == null && initialChosenSort == null;
    }).unwrap();
    return Menu(
      title: strings.task_list_sort_menu_title,
      items: buttons.map((button) => button.title).toList(),
      initialChosenIndex: index,
      didSelectItem: (i) => shouldUpdateFilter(buttons[i].sort),
    );
  }
}

class _Button {
  final String title;
  final Sort? sort;

  const _Button(this.title, this.sort);
}
