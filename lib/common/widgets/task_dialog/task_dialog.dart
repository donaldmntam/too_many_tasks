import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart' hide Dialog, Theme, TextButton;
import 'package:too_many_tasks/common/functions/date_functions.dart';
import 'package:too_many_tasks/common/models/task.dart';
import 'package:too_many_tasks/common/services/services.dart';
import 'package:too_many_tasks/common/theme/theme.dart';
import 'package:too_many_tasks/common/widgets/button/style.dart';
import 'package:too_many_tasks/common/widgets/button/text_button.dart';
import 'package:too_many_tasks/common/widgets/task_dialog/constants.dart';
import 'package:too_many_tasks/common/widgets/task_dialog/field_box.dart';
import 'package:too_many_tasks/common/widgets/task_dialog/preset_row.dart';
import 'package:flutter_gen/gen_l10n/strings.dart';

import '../dialogs/dialog.dart';
import '../dialogs/dialog_scaffold.dart';

const _fieldPadding = EdgeInsets.symmetric(horizontal: 10, vertical: 8);
const _spacing = 12.0;

TextStyle _fieldTextStyle(Theme theme) {
  return theme.textStyle(
    size: 10,
    weight: FontWeight.w400,
    color: theme.colors.onBackground100,
  );
}

class TaskDialog extends StatefulWidget {
  final Task? task;
  final IList<TaskPreset> presets;

  const TaskDialog({
    super.key,
    required this.task,
    required this.presets,
  });

  @override
  State<TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  var crossFadeState = CrossFadeState.showFirst;

  final nameController = TextEditingController();
  final nameFocusNode = FocusNode();
  DateTime? dueDate;

  @override
  void initState() {
    super.initState();

    nameController.text = widget.task?.name ?? "";
    dueDate = widget.task?.dueDate;
  }

  @override
  void dispose() {
    nameController.dispose();
    nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = Strings.of(context);
    final navigator = Navigator.of(context);
    final services = Services.of(context);
    final now = services.calendar.now();
    return Dialog(
      child: DialogScaffold(
        title: switch (widget.task) {
          null => strings.task_dialog_new_task_title,
          _ => strings.task_dialog_edit_task_title,
        },
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
                nameController,
                nameFocusNode,
              ),
              const SizedBox(height: _spacing),
              PresetRow(
                presets: widget.presets,
                onPressed: (preset) {
                  nameController.text = preset.name;
                  nameFocusNode.unfocus();
                },
              ),
              const SizedBox(height: _spacing),
              _DueDateField(
                dueDate,
                () => setState(() =>
                  crossFadeState = CrossFadeState.showSecond,
                ),
              ),
              const SizedBox(height: _spacing),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: horizontalPadding
                ),
                child: TextButton(
                  switch (widget.task) {
                    null => strings.task_dialog_new_task_add_button,
                    _ => strings.task_dialog_edit_task_confirm_button
                  },
                  style: Style.primary,
                  onPressed: () {
                    navigator.pop(
                      (
                        name: nameController.text,
                        dueDate: dueDate,
                        done: widget.task?.done ?? false,
                        pinned: false,
                      )
                    );
                  },
                ),
              ),
              const SizedBox(height: verticalPadding),
            ]
          ),
          secondChild: CalendarDatePicker(
            initialDate: now,
            firstDate: DateTime(now.year - 100, now.month, now.day),
            lastDate: DateTime(now.year + 100, now.month, now.day),
            onDateChanged: (date) {
              setState(() {
                crossFadeState = CrossFadeState.showFirst;
                dueDate = date;
              });
            }
          ),
        )
      )
    );
  }
}

class _TaskNameField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const _TaskNameField(this.controller, this.focusNode);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = _fieldTextStyle(theme);
    final strings = Strings.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: FieldBox(
        title: strings.task_dialog_name_field_title,
        icon: Icons.edit_outlined,
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          style: textStyle,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: _fieldPadding,
            border: InputBorder.none,
            hintText: strings.task_dialog_field_hint, // TODO: translation
            hintStyle: textStyle,
          ),
          cursorColor: theme.colors.onBackground100,
          cursorWidth: 1,
        ),
      ),          
    );
  }
}

class _DueDateField extends StatefulWidget {
  final DateTime? dueDate;
  final void Function() onTap;

  const _DueDateField(
    this.dueDate,
    this.onTap,
  );

  @override
  State<_DueDateField> createState() => _DueDateFieldState();
}

class _DueDateFieldState extends State<_DueDateField> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = Strings.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: GestureDetector(
        onTap: widget.onTap,
        child: FieldBox(
          title: strings.task_dialog_due_date_field_title,
          icon: Icons.calendar_month,
          child: Padding(
            padding: _fieldPadding,
            child: Text(
              widget.dueDate?.toFormattedString() ?? strings.task_dialog_field_hint,
              style: _fieldTextStyle(theme),
            ),
          )
        ),
      )
    );
  }
}