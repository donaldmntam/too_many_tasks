import 'package:flutter/material.dart';
import 'package:too_many_tasks/task_list/state.dart';

class Content extends StatelessWidget {
  const Content({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator()
    );
  }
}