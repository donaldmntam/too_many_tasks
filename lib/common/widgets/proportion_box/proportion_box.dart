import 'package:flutter/material.dart';
import 'package:too_many_tasks/common/widgets/proportion_box/box.dart';

class ProportionSize extends SingleChildRenderObjectWidget {
  final double heightProportion;

  const ProportionSize({
    super.key,
    required this.heightProportion,
    required super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return Box();
  }

  @override
  void updateRenderObject(BuildContext context, Box renderObject) {
    renderObject.proportion = heightProportion;
    renderObject.markNeedsLayout();
  }
}
