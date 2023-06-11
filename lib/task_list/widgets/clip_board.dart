import 'package:flutter/widgets.dart' hide Page;
import 'package:too_many_tasks/task_list/page.dart';

class ClipBoard extends StatelessWidget {
  final double height;
  final Widget child;

  const ClipBoard({
    super.key,
    required this.height,
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Page.clipBoardBorderRadius),
        color: const Color(0xFFF5F5F5),
      ),
      child: child,
    );
  }
}