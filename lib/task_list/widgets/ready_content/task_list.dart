import 'package:flutter/material.dart' hide State, Theme;
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart' as widgets show State;
import 'package:too_many_tasks/common/functions/iterable_functions.dart';
import 'package:too_many_tasks/common/models/task.dart';
import 'package:too_many_tasks/common/services/services.dart';
import 'package:too_many_tasks/common/theme/theme.dart';
import 'package:too_many_tasks/task_list/data/widget_data.dart';
import 'package:too_many_tasks/task_list/functions/widget_functions.dart' as functions;
import 'package:too_many_tasks/task_list/widgets/task_card/task_card.dart' as task_card;
import 'package:too_many_tasks/task_list/widgets/task_card/state.dart' as task_card;

import '../task_card/task_card.dart';

const _removeAnimationDuration = Duration(milliseconds: 500);
const _curve = Curves.easeOutQuad;

class TaskList extends StatefulWidget {
  final List<Task> tasks;
  final double bottomPadding;
  final task_card.Listener listener;
  final ScrollController scrollController;

  const TaskList({
    super.key,
    required this.tasks,
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
      return const task_card.Ready();
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

  // TODO: widget did change --> update cardStates

  void onTick(Duration _) {
    for (var i = 0; i < cardStates.length; i++) {
      final cardState = cardStates[i];
      switch (cardState) {
        case task_card.Ready():
        case task_card.Removed():
          break;
        case task_card.BeingRemoved(
          startTime: final startTime,
        ):
          final now = Services.of(context).clock.now();
          final rawAnimationValue = (
            now.millisecondsSinceEpoch 
              - cardState.startTime.millisecondsSinceEpoch
          ) / _removeAnimationDuration.inMilliseconds;
          if (rawAnimationValue > 1.0) {
            cardStates[i] = const task_card.Removed();
            setState(() {});
          } else {
            cardStates[i] = task_card.BeingRemoved(
              startTime: startTime,
              animationValue: _curve.transform(rawAnimationValue),
            );
            setState(() {});
          }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final widgetBuilders = List<Widget Function()>.empty(growable: true);

    widgetBuilders.add(() => const SizedBox(height: taskListPadding));

    final pinnedTasksBuilders = 
      functions.pinnedTasksBuilders(widget.tasks, cardStates, this);
    if (pinnedTasksBuilders.isNotEmpty) {
      widgetBuilders.addAll(pinnedTasksBuilders);
      widgetBuilders.add(() => Padding(
        padding: middleTaskListItemEdgeInsets,
        child: Divider(
          color: theme.colors.onBackground400,
        )
      ));
    }

    widgetBuilders.addAll(
      functions.unpinnedTasksBuilders(widget.tasks, cardStates, this)
    );
    
    widgetBuilders.add(
      () => SizedBox(
        height: widget.bottomPadding + taskListPadding,
      ),
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
      case task_card.Ready():
        final clock = Services.of(context).clock;
        cardStates[index] = task_card.BeingRemoved(
          startTime: clock.now(),
          animationValue: 0.0
        );
        setState(() {});
      default:
        break;
    }
  }
}
