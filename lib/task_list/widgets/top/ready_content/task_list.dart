import 'package:flutter/material.dart';
import 'package:too_many_tasks/common/functions/list_functions.dart';
import 'package:too_many_tasks/common/models/task.dart';
import 'package:too_many_tasks/task_list/widgets/task_card.dart' as task_card;

const _listPadding = 20.0;

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final int pinnedCount;
  final double bottomPadding;
  final task_card.Listener listener;
  final ScrollController scrollController;

  const TaskList({
    super.key,
    required this.tasks,
    required this.pinnedCount,
    required this.bottomPadding,
    required this.listener,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
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

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      controller: scrollController,
      itemCount: widgetBuilders.length,
      itemBuilder: (_, index) => widgetBuilders[index](),
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