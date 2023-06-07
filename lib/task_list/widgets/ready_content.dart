import 'package:flutter/material.dart';
import 'package:too_many_tasks/task_list/state.dart';
import 'task_card.dart' as task_card;

const _listPadding = 16.0;

class Content extends StatelessWidget {
  final Ready state;
  final task_card.Listener listener;

  const Content({super.key, required this.state, required this.listener});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: state.tasks.length,
      itemBuilder: (context, index) { 
        final bool pinned = index <= state.pinnedCount - 1;
        return Padding(
          padding: _padding(state.tasks.length, index),
          child: task_card.Widget(
            (index: index, task: state.tasks[index], pinned: pinned),
            listener,
          ),
        );
      },
      separatorBuilder: (context, index) => index == state.pinnedCount - 1 
        ? const SizedBox(
            height: 16,
            child: Divider(
              height: 1,
              color: Color(0xFFA4A2A0)
            )
          )
        : const SizedBox(height: 8),
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