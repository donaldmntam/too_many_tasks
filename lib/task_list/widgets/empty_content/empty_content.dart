import 'package:flutter/widgets.dart';
import 'package:too_many_tasks/common/widgets/button/text_button.dart';
import 'package:too_many_tasks/common/widgets/button/style.dart' as button;
import 'package:too_many_tasks/common/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/strings.dart';

class EmptyContent extends StatelessWidget {
  final void Function() onAddNewTask;

  const EmptyContent({
    super.key,
    required this.onAddNewTask,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = Strings.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Align(
          alignment: const Alignment(0, -0.15),
          child: SizedBox(
            // width: constraints.maxWidth * 0.8,
            child: IntrinsicWidth(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    strings.task_list_empty_title,
                    style: theme.textStyle(
                      color: theme.colors.onBackground900,
                      weight: FontWeight.bold,
                      size: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    strings.task_list_empty_button,
                    style: button.Style.secondary,
                    onPressed: onAddNewTask,
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
