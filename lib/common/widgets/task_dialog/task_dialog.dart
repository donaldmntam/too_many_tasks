import 'package:flutter/material.dart' hide Dialog, Theme;
import 'package:too_many_tasks/common/functions/date_functions.dart';
import 'package:too_many_tasks/common/functions/scope_functions.dart';
import 'package:too_many_tasks/common/theme/theme.dart';
import 'package:too_many_tasks/common/widgets/task_dialog/constants.dart';
import 'package:too_many_tasks/common/widgets/task_dialog/field_box.dart';
import 'package:too_many_tasks/common/widgets/task_dialog/preset_row.dart';

import '../dialogs/dialog.dart';
import '../dialogs/dialog_scaffold.dart';

const _fieldPadding = EdgeInsets.symmetric(horizontal: 10, vertical: 8);
const _spacing = 12.0;

TextStyle _fieldTextStyle(Theme theme) {
  return theme.textStyle(
    size: 10,
    weight: FontWeight.w400,
    color: theme.colors.onSurface100,
  );
}

class TaskDialog extends StatefulWidget {
  const TaskDialog({super.key});

  @override
  State<TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  var crossFadeState = CrossFadeState.showFirst;

  String name = "";
  DateTime? dueDate;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: DialogScaffold(
        title: "New Task",
        child: AnimatedCrossFade(
          crossFadeState: crossFadeState,
          duration: const Duration(milliseconds: 400),
          sizeCurve: Curves.easeInOut,
          // secondCurve: Curves.easeInExpo,
          firstChild: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: verticalPadding),
              _TaskNameField(
                (name) => this.name = name,
              ),
              const SizedBox(height: _spacing),
              PresetRow(
                items: ["Brew Coffee", "Hey"].expand((it) => [it, it, it, it]).toList(),
              ),
              const SizedBox(height: _spacing),
              _DueDateField(
                () => setState(() =>
                  crossFadeState = CrossFadeState.showSecond,
                ),
              ),
              const SizedBox(height: verticalPadding),
            ]
          ),
          secondChild: CalendarDatePicker(
            initialDate: DateTime.now(),
            firstDate: DateTime(2023, 5, 17),
            lastDate: DateTime(2023, 5, 19),
            onDateChanged: (date) => setState(() => 
              crossFadeState = CrossFadeState.showFirst,
            ),
          ),
        )
      )
    );
  }
}

class _TaskNameField extends StatelessWidget {
  final void Function(String) onChanged;

  const _TaskNameField(this.onChanged);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: FieldBox(
        title: "Task Name",
        icon: Icons.edit_outlined,
        child: TextField(
          onChanged: onChanged,
          style: _fieldTextStyle(theme),
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: _fieldPadding,
            border: InputBorder.none,
          ),
          cursorColor: theme.colors.onSurface100,
          cursorWidth: 1,
        ),
      ),          
    );
  }
}

class _DueDateField extends StatefulWidget {
  final void Function() onTap;

  const _DueDateField(
    this.onTap,
  );

  @override
  State<_DueDateField> createState() => _DueDateFieldState();
}

class _DueDateFieldState extends State<_DueDateField> {
  DateTime? date;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: GestureDetector(
        onTap: widget.onTap,
        child: FieldBox(
          title: "Due Date",
          icon: Icons.calendar_month,
          child: Padding(
            padding: _fieldPadding,
            child: Text(
              date?.toFormattedString() ?? "none",
              style: _fieldTextStyle(theme),
            ),
          )
        ),
      )
    );
  }
}