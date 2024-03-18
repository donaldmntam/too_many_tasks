import 'package:flutter/widgets.dart';
import 'package:too_many_tasks/common/theme/theme.dart';

final class BottomSheet {
  final void Function()? onTapBackdrop;
  final Widget Function(BuildContext) builder;

  const BottomSheet({
    this.onTapBackdrop,
    required this.builder,
  });
}

extension ExtendedTheme on Theme {
  BoxDecoration get bottomSheetDecoration {
    return BoxDecoration(
      color: colors.surface,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(8), 
        topRight: Radius.circular(8),
      ),
    );
  }
}
