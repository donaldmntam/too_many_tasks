import 'package:flutter/rendering.dart';

class Box extends RenderProxyBox {
  double proportion = 1.0;

  Box({RenderBox? child}) : super(child);  

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final child = this.child;
    if (child == null) {
      return constraints.smallest;
    }
    final layout = child.getDryLayout(constraints);
    return Size(layout.width, layout.height * proportion);
  }

  @override
  void performLayout() {
    final child = this.child;
    if (child == null) return;
    child.layout(constraints, parentUsesSize: true);
    size = Size(child.size.width, child.size.height * proportion);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final child = this.child;
    if (child == null) return;
    layer = context.pushClipRect(
      needsCompositing,
      offset,
      Offset.zero & size,
      super.paint,
      oldLayer: layer is ClipRectLayer ? layer! as ClipRectLayer : null,
      clipBehavior: Clip.antiAlias,
    );
  }
}