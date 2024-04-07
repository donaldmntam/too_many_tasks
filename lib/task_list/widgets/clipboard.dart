import 'package:flutter/material.dart' hide Page, Theme;
import 'package:too_many_tasks/common/theme/theme.dart';
import 'package:too_many_tasks/task_list/page.dart';

const _clipRatio = 1.8275862069; // from Figma

class Clipboard extends StatelessWidget {
  final double height;
  final Widget? topLeftChild;
  final Widget? topRightChild;
  final Widget child;

  const Clipboard({
    super.key,
    required this.height,
    this.topLeftChild,
    this.topRightChild,
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final topLeftChild = this.topLeftChild;
    final topRightChild = this.topRightChild;
    return SizedBox(
      width: double.infinity,
      height: height,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(
                top: Page.clipboardClipHeight - Page.clipboardClipOverlapHeight,
              ),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                padding: const EdgeInsets.only(
                  top: Page.clipboardTopClearance,
                ),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(Page.clipboardBorderRadius),
                    topRight: Radius.circular(Page.clipboardBorderRadius),
                  ),
                  color: theme.colors.backdrop,
                ),
                child: child,
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: Page.clipboardClipHeight 
              + Page.clipboardTopWidgetsHeight
              - Page.clipboardClipOverlapHeight,
            child: Row(
              children: [
                switch (topLeftChild) {
                  null => const Spacer(flex: 1),
                  _ => Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: Page.clipboardClipDanglingHeight
                      ),
                      child: topLeftChild
                    ),
                  )
                },
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    'assets/images/task_list_clip.png',
                    width: _clipRatio * Page.clipboardClipHeight,
                    height: Page.clipboardClipHeight,
                  ),
                ),
                switch (topRightChild) {
                  null => const Spacer(flex: 1),
                  _ => Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: Page.clipboardClipDanglingHeight,
                      ),
                      child: topRightChild
                    ),
                  )
                }
              ],
            ),
          ),
        ],
      ),
    );
  }
}
