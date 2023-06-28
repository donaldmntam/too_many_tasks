import 'package:flutter/material.dart' hide Page, Theme;
import 'package:too_many_tasks/common/theme/theme.dart';
import 'package:too_many_tasks/task_list/page.dart';

const _clipRatio = 1.8275862069; // from Figma

class ClipBoard extends StatelessWidget {
  final double height;
  final Widget child;

  const ClipBoard({
    super.key,
    required this.height,
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      height: height,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(
                top: Page.clipBoardClipHeight - Page.clipBoardClipOverlapHeight,
              ),
              child: Container(
                padding: const EdgeInsets.only(
                  top: Page.clipBoardClipOverlapHeight,
                ),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(Page.clipBoardBorderRadius),
                    topRight: Radius.circular(Page.clipBoardBorderRadius),
                  ),
                  color: theme.colors.backdrop,
                ),
                child: child,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Image.asset(
              'assets/images/task_list_clip.png',
              width: _clipRatio * Page.clipBoardClipHeight,
              height: Page.clipBoardClipHeight,
            ),
          ),
        ],
      ),
    );
  }
}