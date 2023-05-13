import 'package:flutter/material.dart' hide Widget;
import 'package:flutter/widgets.dart' as flutter show Widget;
import 'package:too_many_tasks/common/models/task.dart';
import 'package:too_many_tasks/task_list/widgets/task_card.dart' as task_card;

class Widget extends StatefulWidget {
  const Widget({super.key});

  @override
  State<Widget> createState() => _State();
}

class _State extends State<Widget> implements task_card.Listener {
  Task task = (
    title: "Task Title",
    dueDate: DateTime.now(),
    done: true,
    pinned: true
  );
  
  @override
  void onCheckmarkPressed() {
    setState(() {
      task = (
        title: task.title,
        dueDate: task.dueDate,
        done: !task.done,
        pinned: task.pinned,
      );
    });
  }
  
  @override
  void onEditPressed() {
    // TODO: implement onEditPressed
  }
  
  @override
  void onPinPressed() {
    setState(() {
      task = (
        title: task.title,
        dueDate: task.dueDate,
        done: task.done,
        pinned: !task.pinned,
      );
    });
  }

  @override
  flutter.Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF5F5F5),
          ),
          child: ListView.separated(
            itemCount: 3,
            itemBuilder: (context, index) => task_card.Widget(task, this),
            separatorBuilder: (context, index) => const SizedBox(height: 8)
          ),
        )
      )
    );
  }
}