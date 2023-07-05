import 'package:flutter/widgets.dart';

class SwipeableClipper extends CustomClipper<Rect> {
  final double offset;
  
  const SwipeableClipper({required this.offset});

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(
      0,
      0,
      offset,
      size.height,
    );
  }

  @override
  bool shouldReclip(covariant SwipeableClipper oldClipper) {
    return offset != oldClipper.offset;
  }
}