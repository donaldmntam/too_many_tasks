import 'package:flutter/material.dart' hide State;
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart' as widgets show State;
import 'package:too_many_tasks/common/functions/iterable_functions.dart';
import 'package:too_many_tasks/common/functions/list_functions.dart';
import 'package:too_many_tasks/common/models/task.dart';
import 'package:too_many_tasks/common/services/services.dart';
import 'package:too_many_tasks/task_list/widgets/task_card/task_card.dart' as task_card;
import 'package:too_many_tasks/task_list/widgets/task_card/state.dart' as task_card;

const _listPadding = 20.0;
const _removeAnimationDuration = Duration(milliseconds: 500);

class TaskList extends StatefulWidget {
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
  widgets.State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends widgets.State<TaskList>   
  with SingleTickerProviderStateMixin 
  implements task_card.Listener {
  late final List<task_card.State> cardStates;

  late final Ticker ticker;

  @override
  void initState() {
    cardStates = widget.tasks.mapIndexed<task_card.State>((task, index) {
      final bool pinned = index <= widget.pinnedCount - 1;
      return task_card.Ready(
        data: (index: index, task: task, pinned: pinned)
      );
    }).toList();

    ticker = createTicker(onTick);
    ticker.start();

    super.initState();
  }

  @override
  void dispose() {
    ticker.dispose();

    super.dispose();
  }

  void onTick(Duration _) {
    for (var i = 0; i < cardStates.length; i++) {
      final cardState = cardStates[i];
      switch (cardState) {
        case task_card.Ready():
        case task_card.Removed():
          break;
        case task_card.BeingRemoved(
          startTime: final startTime,
          data: final data,
        ):
          final now = Services.of(context).clock.now();
          final animationValue = (
            now.millisecondsSinceEpoch 
              - cardState.startTime.millisecondsSinceEpoch
          ) / _removeAnimationDuration.inMilliseconds;
          print("animatinoValue ${animationValue}");
          print("startTime: ${startTime}");
          print("now: ${now}");
          if (animationValue > 1.0) {
            cardStates[i] = const task_card.Removed();
            setState(() {});
          } else {
            cardStates[i] = task_card.BeingRemoved(
              startTime: startTime,
              animationValue: animationValue,
              data: data,
            );
            setState(() {});
          }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final widgetBuilders = cardStates
      .mapIndexed<Widget Function()>((cardState, index) =>
        () => Padding(
          key: Key('task$index'),
          padding: _padding(widget.tasks.length, index),
          child: task_card.TaskCard(
            cardState,
            // widget.listener,
            this,
          ),
        )
      ).toList();
    widgetBuilders.insertInBetween((index) {
      if (index == widget.pinnedCount - 1) {
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
      () => SizedBox(height: widget.bottomPadding),
    );

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      controller: widget.scrollController,
      itemCount: widgetBuilders.length,
      itemBuilder: (_, index) => widgetBuilders[index](),
    );
  }
  
  @override
  void onCheckMarkPressed(int index) {
    widget.listener.onCheckMarkPressed(index);
  }
  
  @override
  void onEditPressed(int index) {
    widget.listener.onEditPressed(index);
  }
  
  @override
  void onPinPressed(int index) {
    widget.listener.onPinPressed(index);
  }
  
  @override
  void onRemove(int index) {
    // widget.listener.onRemove(index);
    final cardState = cardStates[index];
    switch (cardState) {
      case task_card.Ready(data: final data):
        final clock = Services.of(context).clock;
        cardStates[index] = task_card.BeingRemoved(
          startTime: clock.now(),
          data: data,
          animationValue: 0.0
        );
        setState(() {});
      default:
        break;
    }
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