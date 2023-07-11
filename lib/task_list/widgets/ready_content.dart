import 'package:flutter/material.dart' hide State, Theme;
import 'package:too_many_tasks/common/functions/list_functions.dart';
import 'package:too_many_tasks/common/models/task.dart';
import 'package:too_many_tasks/common/theme/theme.dart';
import 'package:too_many_tasks/task_list/state.dart';
import 'task_card.dart' as task_card;
import 'package:flutter/widgets.dart' as widgets show State;

const _linePadding = 8.0;
const _listPadding = 20.0;
const _returnButtonPadding = 16.0;
const _animationDuration = Duration(milliseconds: 200);

class Content extends StatefulWidget {
  final GlobalKey<AnimatedListState> listKey;
  final double fabClearance;
  final Ready state;
  final task_card.Listener listener;

  const Content({
    super.key,
    required this.listKey,
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
                child: _listView(
                  key: widget.listKey,
                  tasks: widget.state.tasks,
                  pinnedCount: widget.state.pinnedCount,
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

Widget _listView({
  required GlobalKey<AnimatedListState> key,
  required List<Task> tasks,
  required int pinnedCount,
  required double bottomPadding,
  required task_card.Listener listener,
  required ScrollController scrollController,
}) {
  final widgetBuilders = List<Widget Function()>.generate(
    tasks.length,
    (index) => () {
      final task = tasks[index];
      final bool pinned = index <= pinnedCount - 1;
      return Padding(
        key: Key('task$index'),
        padding: _padding(tasks.length, index),
        child: task_card.TaskCard(
          (index: index, task: task, pinned: pinned),
          listener,
        ),
      );
    }
  );
  widgetBuilders.insertInBetween((index) {
    if (index == pinnedCount - 1) {
      return () => const SizedBox(
        height: 16,
        child: Divider(
          height: 1,
          color: Color(0xFFA4A2A0)
        )
      );
    } else {
      return () => const SizedBox(height: 8);
    }
  });
  widgetBuilders.add(
    () => SizedBox(height: bottomPadding),
  );

  print("widgetBuilder.length ${widgetBuilders.length}");

  return AnimatedList(
    key: key,
    physics: const BouncingScrollPhysics(),
    controller: scrollController,
    initialItemCount: widgetBuilders.length,
    itemBuilder: (_, index, __) => widgetBuilders[index](),
    // separatorBuilder: (context, index) {
    //   if (index == widget.state.pinnedCount - 1) {
    //     return const SizedBox(
    //       height: 16,
    //       child: Divider(
    //         height: 1,
    //         color: Color(0xFFA4A2A0)
    //       )
    //     );
    //   } else {
    //     return const SizedBox(height: 8);
    //   }
    // },
  );
}

EdgeInsets _padding(int length, int index) {
  if (index == 0) {
    return const EdgeInsets.only(
      top: _listPadding,
      left: _listPadding,
      right: _listPadding,
    );
  } else if (index == length - 1) {
    return const EdgeInsets.only(
      bottom: _listPadding,
      left: _listPadding,
      right: _listPadding,
    );
  } else {
    return const EdgeInsets.symmetric(      
      horizontal: _listPadding,
    );
  }
}