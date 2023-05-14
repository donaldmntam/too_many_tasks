import 'package:flutter/widgets.dart';
import 'package:too_many_tasks/common/services/clock.dart';

class Services extends InheritedWidget {
  final Clock clock;

  const Services({
    super.key,
    required this.clock,
    required super.child
  });

  static Services? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Services>();
  }

  static Services of(BuildContext context) {
    final Services? result = maybeOf(context);
    assert(result != null, 'No Services found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}