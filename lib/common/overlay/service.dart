import 'package:flutter/widgets.dart';
import './overlay.dart';
import './bottom_sheet.dart';

class OverlayService extends InheritedWidget {
  final void Function(BottomSheet?) shouldSetBottomSheet;

  const OverlayService({
    super.key,
    required this.shouldSetBottomSheet,
    required super.child,
  });

  static OverlayService? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<OverlayService>();
  }

  static OverlayService of(BuildContext context) {
    return maybeOf(context)!;
  }

  void openBottomSheet(BottomSheet bottomSheet) {
    shouldSetBottomSheet(bottomSheet);
  }
  
  void closeBottomSheet() {
    shouldSetBottomSheet(null);
  }

  @override
  updateShouldNotify(OverlayService oldWidget) => false;
}

