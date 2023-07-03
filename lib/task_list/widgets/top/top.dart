import 'package:flutter/material.dart' hide Page, Theme;
import 'package:too_many_tasks/common/theme/theme.dart';
import 'package:too_many_tasks/task_list/page.dart';
import 'package:too_many_tasks/task_list/widgets/top/progress.dart';
import 'package:too_many_tasks/task_list/widgets/top/rising_bubbles.dart';

const _gridSize = 26.0;
const _bubbleSize = 12.0;
const _speed = 0.2;
const _startColor = Color(0x10FFFFFF);
// const _startColor = Color(0xFFFF0000);
const _endColor = Color(0x30FFFFFF);

class Top extends StatefulWidget {
  static progressHeight(BuildContext context) => Page.topHeight(context) * 0.5;

  final double? progress;

  const Top({
    super.key,
    required this.progress,
  });

  @override
  State<Top> createState() => _TopState();
}

class _TopState extends State<Top> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        Positioned.fill(
          child: RisingBubbles(
            configuration: Configuration(
              backgroundColor: theme.colors.primary,
              gridSize: _gridSize,
              bubbleSize: _bubbleSize,
              speed: _speed,
              startColor: _startColor,
              endColor: _endColor,
            )
          ),
        ),
        Positioned.fill(
          child: SafeArea(
            top: true,
            left: false,
            right: false,
            bottom: false,
            child: AnimatedOpacity(
              opacity: widget.progress == null ? 0 : 1,
              duration: const Duration(seconds: 1),
              child: Column(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Page.clipboardBorderRadius
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Progress(widget.progress)
                      ),
                    )
                  ),
                  const SizedBox(
                    height: Page.clipboardClipHeight
                      - Page.clipboardClipOverlapHeight
                      + Page.clipboardBorderRadius
                  ),
                ]
              ),
            ),
          ),
        ),
      ],
    );
  }
}