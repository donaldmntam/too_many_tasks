import 'package:flutter/material.dart';
import 'package:too_many_tasks/task_list/state.dart';

class Content extends StatelessWidget {
  final Loading state;

  const Content({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator()
    );
  }
}