import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart' hide Theme;
import 'package:too_many_tasks/common/models/task.dart';
import 'package:too_many_tasks/common/theme/theme.dart';
import 'package:too_many_tasks/common/widgets/tappable/tappable.dart';

import 'constants.dart';

const _padding = EdgeInsets.symmetric(horizontal: 10, vertical: 8);

class PresetRow extends StatelessWidget {
  final IList<TaskPreset> presets;
  final void Function(TaskPreset) onPressed;

  const PresetRow({
    super.key,
    required this.presets,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IntrinsicHeight(
      child: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row( 
              children: widgets(presets),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: horizontalPadding,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [theme.colors.surface, const Color(0x00FFFFFF)],
                  stops: const [0.2, 1.0],
                )
              )
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: horizontalPadding,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [const Color(0x00FFFFFF), theme.colors.surface],
                  stops: const [0.0, 0.8],
                )
              )
            ),
          ),
        ],
      ),
    );
  }

    List<Widget> widgets(IList<TaskPreset> presets) {
    final widgets = List<Widget>.empty(growable: true);
    widgets.add(const SizedBox(width: horizontalPadding));
    for (var i = 0; i < presets.length; i++) {
      final preset = presets[i];
      widgets.add(
        Tappable(
          onPressed: () => onPressed(preset),
          child: _Item(preset),
        )
      );
      if (i == presets.length - 1) continue;
      widgets.add(const SizedBox(width: 4));
    }
    widgets.add(const SizedBox(width: horizontalPadding));
    return widgets;
  }
}

class _Item extends StatelessWidget {
  final TaskPreset preset;

  const _Item(this.preset);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: _padding,
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colors.primary,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        preset.name,
        style: theme.textStyle(
          size: 10,
          weight: FontWeight.w400,
          color: theme.colors.primary,
        ),
      ),
    );
  }
}