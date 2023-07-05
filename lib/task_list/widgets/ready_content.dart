import 'package:flutter/material.dart' hide State, Theme;
import 'package:too_many_tasks/common/theme/theme.dart';
import 'package:too_many_tasks/task_list/state.dart';
import 'task_card.dart' as task_card;
import 'package:flutter/widgets.dart' as widgets show State;

const _linePadding = 8.0;
const _listPadding = 20.0;
const _returnButtonPadding = 16.0;
const _animationDuration = Duration(milliseconds: 200);

class Content extends StatefulWidget {
  final Ready state;
  final task_card.Listener listener;

  const Content({super.key, required this.state, required this.listener});

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
    // return Center(
    //   child: SizedBox(
    //     width: 100,
    //     height: 100,
    //     child: Stack(
    //       children: [
    //         Container(
    //           width: 50,
    //           height: 100,
    //           color: Colors.red,
    //         ),
    //         Container(
    //           width: 100,
    //           height: 100,
    //           color: Colors.white
    //         )
    //       ]
    //     ),
    //   ),
    // );

    final theme = Theme.of(context);
    final bottomPadding = MediaQuery.of(context).padding.bottom;
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
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  controller: controller,
                  itemCount: widget.state.tasks.length + 1, // plus one for bottom inset
                  itemBuilder: (context, index) { 
                    if (index == widget.state.tasks.length) {
                      return SizedBox(height: bottomPadding);
                    }
                    final bool pinned = index <= widget.state.pinnedCount - 1;
                    return Padding(
                      padding: _padding(widget.state.tasks.length, index),
                      child: task_card.Widget(
                        (index: index, task: widget.state.tasks[index], pinned: pinned),
                        widget.listener,
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    if (index == widget.state.pinnedCount - 1) {
                      return const SizedBox(
                        height: 16,
                        child: Divider(
                          height: 1,
                          color: Color(0xFFA4A2A0)
                        )
                      );
                    } else {
                      return const SizedBox(height: 8);
                    }
                  },
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