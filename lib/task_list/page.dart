import 'package:flutter/material.dart';
import 'package:too_many_tasks/task_list/widgets/task_card.dart';

class Page extends StatefulWidget {
  const Page({super.key});

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color(0xF5F5F5),
              ),
              child: Column(
                children: [
                  TaskCard(),
                  TaskCard(),
                  TaskCard(),
                ]
              )
            )
          ]
        ),
      )
    );
  }
}