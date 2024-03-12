import 'package:flutter/material.dart' hide Colors;

import 'colors.dart';
import 'fonts.dart';

class Theme extends InheritedWidget {
  final Colors colors;
  final String fontFamily;

  const Theme({
    super.key,
    required this.colors,
    required this.fontFamily,
    required super.child,
  });

  static Theme? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Theme>();
  }

  static Theme of(BuildContext context) {
    final Theme? result = maybeOf(context);
    assert(result != null, 'No Theme found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(Theme oldWidget) => colors != oldWidget.colors;

  TextStyle textStyle({
    required double size,
    FontWeight weight = FontWeight.w400,
    required Color color,
    TextDecoration decoration = TextDecoration.none,
  }) {
    return TextStyle(
      color: color,
      fontSize: size,
      fontWeight: weight,
      fontFamily: fontFamily,
      decoration: decoration,
    );
  }

  BoxShadow boxShadow({
    int alpha = 16,
    BlurStyle blurStyle = BlurStyle.normal,
  }) {
    return BoxShadow(
      color: Color.fromARGB(alpha, 0, 0, 0),
      blurRadius: 4,
      spreadRadius: 0, 
      offset: const Offset(0, 2),
      blurStyle: blurStyle,
    );
  }
}
