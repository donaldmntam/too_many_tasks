import 'package:flutter/material.dart' hide Page;
import 'package:too_many_tasks/task_list/page.dart';

class Top extends StatelessWidget {
  const Top({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          flex: 1,
          child: Container(
            color: Colors.red,
            width: double.infinity,
            height: Page.topHeight,
          ),
        ),
        // clearance for overlapping with the clipboard
        const SizedBox(height: Page.clipBoardBorderRadius),
      ],
    );
  }
}