import 'package:flutter/material.dart' hide Theme, Page;
import 'package:too_many_tasks/common/services/clock.dart';
import 'package:too_many_tasks/task_list/page.dart' as task_list;

import 'common/services/services.dart';
import 'common/theme/theme.dart';
void main() {
  runApp(const MainApp());
}

class FrozenClock implements Clock {
  const FrozenClock();

  @override
  DateTime now() {
    return DateTime(2023, 5, 14);
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Services(
        // clock: DefaultClock(),
        clock: FrozenClock(),
        child: Theme(
          colors: testColors,
          fontFamily: "",
          child: task_list.Page()
        ),
      ),
    );
  }
}

const testColors = (
  primary: Color(0xFFFFC253),
  onPrimary: Color(0xFFFFFFFF),
  secondary: Color(0xFF5FADA0),
  onSecondary: Color(0xFFFFFFFF),
  surface: Color(0xFFFFFFFF),
  onSurface100: Color(0xFFA59F9B),
  onSurface400: Color(0xFF383431),
  onSurface900: Color(0xFF000000),
  disabled: Color(0xFFA4A2A0),
  onDisabled: Color(0xFFFFFFFF),
  error: Color(0xFFFF0029),
);