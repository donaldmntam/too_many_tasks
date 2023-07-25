import 'package:flutter/material.dart';
import 'package:too_many_tasks/common/widgets/proportion_box/box.dart';

class ProportionSize extends SingleChildRenderObjectWidget {
  final double proportion;

  const ProportionSize({
    super.key,
    required this.proportion,
    required super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return Box();
  }

  @override
  void updateRenderObject(BuildContext context, Box renderObject) {
    renderObject.proportion = proportion;
    renderObject.markNeedsLayout();
  }
}
