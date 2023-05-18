import 'package:flutter/material.dart' as material;
import 'package:flutter/widgets.dart';
import 'package:too_many_tasks/common/theme/theme.dart';

class Dialog extends StatelessWidget {
  final Widget child;
  
  const Dialog({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return material.Dialog(
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      backgroundColor: theme.colors.surface,
      child: child,
    );
  }
}