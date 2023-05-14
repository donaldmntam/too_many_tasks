import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:too_many_tasks/common/functions/scope_functions.dart';
import 'package:too_many_tasks/common/models/task.dart';
import 'package:too_many_tasks/task_list/widgets/task_card.dart' as task_card;

const _listPadding = 16.0;

class Page extends StatefulWidget {
  const Page({super.key});

  @override
  State<Page> createState() => _State();
}

class _State extends State<Page> implements task_card.Listener {
  int pinnedCount = 1;
  IList<Task> tasks = List.generate(
    10,
    (index) => (
      title: "Task ${index + 1}",
      dueDate: DateTime(2023, 5, 10 + index),
      done: true,
    ),
  ).lock;
  
  @override
  void onCheckmarkPressed() {
    // setState(() {
    //   task = (
    //     title: task.title,
    //     dueDate: task.dueDate,
    //     done: !task.done,
    //     pinned: task.pinned,
    //   );
    // });
  }
  
  @override
  void onEditPressed() {
    // TODO: implement onEditPressed
  }
  
  @override
  void onPinPressed(int index) {
    setState(() {
      final tasks = this.tasks.unlock;
      final taskToPin = tasks.removeAt(index);
      tasks.insert(pinnedCount, taskToPin);
      this.tasks = tasks.lock;
      pinnedCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF5F5F5),
          ),
          child: ListView.separated(
            itemCount: tasks.length,
            itemBuilder: (context, index) { 
              final bool pinned = index <= pinnedCount - 1;
              return Padding(
                padding: _padding(tasks.length, index),
                child: task_card.Widget(
                  (index: index, task: tasks[index], pinned: pinned),
                  this
                ),
              );
            },
            separatorBuilder: (context, index) => index == pinnedCount - 1 
              ? const SizedBox(
                  height: 16,
                  child: Divider(
                    height: 1,
                    color: Color(0xFFA4A2A0)
                  )
                )
              : const SizedBox(height: 8),
          ),
        )
      )
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