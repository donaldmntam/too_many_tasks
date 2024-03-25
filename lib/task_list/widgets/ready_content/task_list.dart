import 'package:flutter/material.dart' hide State, Theme;
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart' as widgets show State;
import 'package:too_many_tasks/common/functions/iterable_functions.dart';
import 'package:too_many_tasks/common/models/task.dart';
import 'package:too_many_tasks/common/services/services.dart';
import 'package:too_many_tasks/common/theme/theme.dart';
import 'package:too_many_tasks/task_list/functions/widget_functions.dart' as functions;
import 'package:too_many_tasks/task_list/widgets/task_card/task_card.dart' as task_card;
import 'package:too_many_tasks/task_list/widgets/task_card/state.dart' as task_card;
import 'package:too_many_tasks/task_list/functions/task_functions.dart' as functions;
import 'package:too_many_tasks/common/models/filter.dart';

const _addAnimationDuration = Duration(milliseconds: 500);
const _removeAnimationDuration = Duration(milliseconds: 500);

class TaskList extends StatefulWidget {
  final TaskStates taskStates;
  final Filter? filter;
  final double bottomPadding;
  final task_card.Listener listener;
  final ScrollController scrollController;

  const TaskList({
    super.key,
    required this.taskStates,
    required this.filter,
    required this.bottomPadding,
    required this.listener,
    required this.scrollController,
  });

  @override
  widgets.State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends widgets.State<TaskList>   
  with SingleTickerProviderStateMixin {
  late final List<task_card.State> cardStates;

  late final Ticker ticker;
  
  @override
  void initState() {
    cardStates = widget.taskStates.mapIndexed<task_card.State>((task, index) {
      return const task_card.Unpinned();
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

  @override
  void didUpdateWidget(TaskList oldWidget) {
    // final services = Services.of(context);
    // for (var i = oldWidget.tasks.length; i < widget.tasks.length; i++) {
    //   cardStates.add(
    //     task_card.BeingAdded(
    //       startTime: services.calendar.now(),
    //       animationValue: 0
    //     )
    //   );
    // }
    cardStates.clear();
    cardStates.addAll(
      functions.cardStates(oldWidget.taskStates, widget.taskStates),
    );

    super.didUpdateWidget(oldWidget);
  }

  // TODO: pinning
  void onTick(Duration _) {
    for (var i = 0; i < cardStates.length; i++) {
      final cardState = cardStates[i];
      switch (cardState) {
        case task_card.Unpinned():
        case task_card.Pinned():
        case task_card.Removed():
          break;
        case task_card.BeingPinned(startTime: final cardStateStartTime):
          final now = Services.of(context).calendar.now();
          final startTime = cardStateStartTime ?? now;
          final animationValue = (
            now.millisecondsSinceEpoch - startTime.millisecondsSinceEpoch
          ) / _addAnimationDuration.inMilliseconds;
          if (animationValue > 1.0) {
            cardStates[i] = const task_card.Pinned();
            setState(() {});
          } else {
            cardStates[i] = task_card.BeingPinned(
              startTime: startTime,
              animationValue: animationValue,
            );
            setState(() {});
          }
        case task_card.BeingAdded(startTime: final cardStateStartTime):
          final now = Services.of(context).calendar.now();
          final startTime = cardStateStartTime ?? now;
          final animationValue = (
            now.millisecondsSinceEpoch - startTime.millisecondsSinceEpoch
          ) / _addAnimationDuration.inMilliseconds;
          if (animationValue > 1.0) {
            cardStates[i] = const task_card.Unpinned();
            setState(() {});
          } else {
            cardStates[i] = task_card.BeingAdded(
              startTime: startTime,
              animationValue: animationValue,
            );
            setState(() {});
          }
        case task_card.BeingRemoved(startTime: final cardStateStartTime):
          final now = Services.of(context).calendar.now();
          final startTime = cardStateStartTime ?? now;
          final animationValue = (
            now.millisecondsSinceEpoch - startTime.millisecondsSinceEpoch
          ) / _removeAnimationDuration.inMilliseconds;
          if (animationValue > 1.0) {
            cardStates[i] = const task_card.Removed();
            setState(() {});
          } else {
            cardStates[i] = task_card.BeingRemoved(
              startTime: startTime,
              animationValue: animationValue,
            );
            setState(() {});
          }
        case task_card.BeingUnpinned(startTime: final cardStateStartTime):
          final now = Services.of(context).calendar.now();
          final startTime = cardStateStartTime ?? now;
          final animationValue = (
            now.millisecondsSinceEpoch - startTime.millisecondsSinceEpoch
          ) / _removeAnimationDuration.inMilliseconds;
          if (animationValue > 1.0) {
            cardStates[i] = const task_card.Unpinned();
            // widget.listener.onPinPressed(i);
            setState(() {});
          } else {
            cardStates[i] = task_card.BeingUnpinned(
              startTime: startTime,
              animationValue: animationValue,
            );
            setState(() {});
          }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final services = Services.of(context);

    final widgets = functions.widgets(
      today: services.calendar.today(),
      bottomPadding: widget.bottomPadding,
      theme: theme,
      taskStates: widget.taskStates,
      filter: widget.filter,
      cardStates: cardStates,
      listener: widget.listener,
    );

    return Column(
      children: [
        Flexible(flex: 1, child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          controller: widget.scrollController,
          itemCount: widgets.length,
          itemBuilder: (_, index) => widgets[index],
        )),
        // ElevatedButton(onPressed: () => print("cardStates here! ${inspect(cardStates)}"), child: Text("inspect"))
      ],
    );
  }
  
  void onRemove(int index) {
    final cardState = cardStates[index];
    switch (cardState) {
      case task_card.Unpinned():
        final clock = Services.of(context).calendar;
        cardStates[index] = task_card.BeingRemoved(
          startTime: clock.now(),
          animationValue: 0.0,
          shouldRemoveDataWhenAnimationEnds: true,
        );
        setState(() {});
      default:
        break;
    }
  }
}
