import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyWidget extends LeafRenderObjectWidget {
  final String text;
  final String sentAt;
  final TextStyle style;

  const MyWidget({
    super.key,
    required this.text,
    required this.sentAt,
    required this.style,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return MyRenderObject(
      text: text,
      sentAt: sentAt,
      style: style,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    MyRenderObject renderObject,
  ) {
    renderObject.text = text;
    renderObject.sentAt = sentAt;
    renderObject.style = style;
  }
}

class MyRenderObject extends RenderBox {
  String _text;
  String _sentAt;
  TextStyle _style;

  TextPainter _textPainter;
  TextPainter _sentAtTextPainter;

  // Saved values from `performLayout` used in `paint`
  late bool _sentAtFitsOnLastLine;
  late double _lineHeight;
  late double _lastMessageLineWidth;
  late double _longestLineWidth;
  late double _sentAtLineWidth;
  late int _numMessageLines;

  String get text => _text;
  set text(String value) {
    if (value == text) return;
    _text = value;
    _textPainter.text = textSpan;
  }

  String get sentAt => _sentAt;
  set sentAt(String value) {
    if (value == _sentAt) return;
    _sentAt = value;
    _sentAtTextPainter.text = sentAtTextSpan;
  }

  TextStyle get style => _style;
  set style(TextStyle value) {
    if (value == _style) return;
    _style = value;
    _textPainter.text = textSpan;
    _sentAtTextPainter.text = sentAtTextSpan;
  }

  TextSpan get textSpan => TextSpan(text: _text, style: _style);
  TextSpan get sentAtTextSpan => TextSpan(
    text: _sentAt,
    style: _style.copyWith(color: Colors.grey),
  );

  MyRenderObject({
    required String text,
    required String sentAt,
    required TextStyle style,
  }) :
    _text = text,
    _sentAt = sentAt,
    _style = style, 
    _textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    ),
    _sentAtTextPainter = TextPainter(
      text: TextSpan(text: sentAt, style: style),
      textDirection: TextDirection.ltr,
    );

  @override
  void performLayout() {
    _textPainter.layout(maxWidth: constraints.maxWidth);
    final textLines = _textPainter.computeLineMetrics();

    _sentAtTextPainter.layout(maxWidth: constraints.maxWidth);    
    _sentAtLineWidth = _sentAtTextPainter.computeLineMetrics().first.width;

    _longestLineWidth = 0;
    for (final line in textLines) {
      _longestLineWidth = max(_longestLineWidth, line.width);
    }
    _lastMessageLineWidth = textLines.last.width;
    _lineHeight = textLines.last.height;
    _numMessageLines = textLines.length;

    final sizeOfMessage = Size(_longestLineWidth, _textPainter.height);

    final lastLineWithDate = _lastMessageLineWidth + (_sentAtLineWidth * 1.1);
    if (textLines.length == 1) {
      _sentAtFitsOnLastLine = lastLineWithDate < constraints.maxWidth;
    } else {
      _sentAtFitsOnLastLine = 
        lastLineWithDate < min(_longestLineWidth, constraints.maxWidth);
    }

    final Size computedSize;
    if (!_sentAtFitsOnLastLine) {
      computedSize = Size(
        sizeOfMessage.width,
        sizeOfMessage.height,
      );
    } else {
      if (textLines.length == 1) {
        computedSize = Size(lastLineWithDate, sizeOfMessage.height);
      } else {
        computedSize = Size(_longestLineWidth, sizeOfMessage.height);
      }
    }

    size = constraints.constrain(computedSize);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _textPainter.paint(context.canvas, offset);
  }
}