import 'dart:async';

import 'package:flutter/material.dart';

sealed class AppCycleMessage {}

final class DidDetach implements AppCycleMessage {
  const DidDetach();
}

Stream<AppCycleMessage> defaultAppCycleMessageStream() {
  final controller = StreamController<AppCycleMessage>.broadcast();

  WidgetsBinding.instance.addObserver(
    LifecycleEventHandler(
      resumedCallBack: () async {}, 
      detachedCallBack: () async => controller.add(const DidDetach()),
    )
  );

  return controller.stream;
}


class LifecycleEventHandler extends WidgetsBindingObserver {
  final Future<void> Function() resumedCallBack;
  final Future<void> Function() detachedCallBack;

  LifecycleEventHandler({
    required this.resumedCallBack, 
    required this.detachedCallBack,
  });

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    print("didChangeAppLifecycleState $state");
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        await detachedCallBack();
        break;
      case AppLifecycleState.resumed:
        await resumedCallBack();
        break;
    }
  }
}
