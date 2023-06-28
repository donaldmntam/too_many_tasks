import 'package:flutter/material.dart' hide Theme, Page, Localizations;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:too_many_tasks/common/coordinator/coordinator.dart';
import 'package:too_many_tasks/common/services/clock.dart';
import 'package:too_many_tasks/common/services/shared_preferences.dart';
import 'package:too_many_tasks/task_list/page.dart' as task_list;
import 'package:flutter_gen/gen_l10n/strings.dart';

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
    const sharedPreferences = DefaultSharedPreferences();
    return const Services(
      clock: DefaultClock(),
      sharedPreferences: sharedPreferences,
      child: Theme(
        colors: testColors,
        fontFamily: "",
        child: MaterialApp(
          localizationsDelegates: [
            Strings.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('en'),
          ],
          home: Coordinator(
            sharedPreferences: sharedPreferences,
          )
        )
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
  backdrop: Color(0xFFF5F5F5),
  onBackground100: Color(0xFFA59F9B),
  onBackground400: Color(0xFF383431),
  onBackground900: Color(0xFF000000),
  disabled: Color(0xFFA4A2A0),
  onDisabled: Color(0xFFFFFFFF),
  error: Color(0xFFFF0029),
);