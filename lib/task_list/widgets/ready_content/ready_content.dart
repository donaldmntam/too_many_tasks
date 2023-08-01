import 'package:flutter/material.dart' hide State, Theme;
import 'package:too_many_tasks/common/coordinator/tasks_state.dart';
import 'package:too_many_tasks/common/functions/list_functions.dart';
import 'package:too_many_tasks/common/models/task.dart';
import 'package:too_many_tasks/common/theme/theme.dart';
import 'package:too_many_tasks/task_list/state.dart';
import 'package:too_many_tasks/task_list/widgets/ready_content/task_list.dart';
import '../task_card/task_card.dart' as task_card;
import 'package:flutter/widgets.dart' as widgets show State;

const _linePadding = 8.0;
const _returnButtonPadding = 16.0;
const _animationDuration = Duration(milliseconds: 200);

class Content extends StatefulWidget {
  final double fabClearance;
  final TasksReady state;
  final task_card.Listener listener;

  const Content({
    super.key,
    required this.fabClearance,
    required this.state,
    required this.listener
  });

  @override
  widgets.State<Content> createState() => _ContentState();
}

class _ContentState extends widgets.State<Content> {
  late final ScrollController controller;
  var hasScrolledDown = false;

  @override
  void initState() {
    controller = ScrollController();
    controller.addListener(() {
      final justScrolledDown = controller.offset > 0 && hasScrolledDown == false;
      if (justScrolledDown) {
        setState(() => hasScrolledDown = true);
        return;
      }
      final justReachedTop = controller.offset <= 0 && hasScrolledDown == true;
      if (justReachedTop) {
        setState(() => hasScrolledDown = false);
        return;
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.state.tasks.isEmpty) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).padding.bottom;
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Stack(
        children: [
          Column(
            children: [
              AnimatedOpacity(
                opacity: hasScrolledDown ? 1.0 : 0.0,
                duration: _animationDuration,
                child: Divider(
                  height: 1,
                  indent: _linePadding,
                  endIndent: _linePadding,
                  color: theme.colors.onBackground100,
                ),
              ),
              Flexible(
                flex: 1,
                child: TaskList(
                  tasks: widget.state.tasks,
                  bottomPadding: bottomInset + widget.fabClearance, 
                  listener: widget.listener,
                  scrollController: controller
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(_returnButtonPadding),
              child: AnimatedOpacity(
                duration: _animationDuration,
                opacity: hasScrolledDown ? 1.0 : 0.0,
                child: GestureDetector(
                  onTap: () => controller.animateTo(
                    0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                  ),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: ShapeDecoration(
                      color: theme.colors.surface,
                      shape: const CircleBorder(),
                      shadows: [
                        theme.boxShadow(
                          alpha: 60,
                        ),
                      ]
                    ),
                    child: const Icon(
                      Icons.arrow_upward,
                      color: Colors.black,
                    )
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
