import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

class SimplPaint extends CustomPainter {
  final Offset startPoint;
  final Offset endPoint;
  final Offset basePoint;
  final Canvas canvas;
  final Size size;
  final Color color;
  final double strokeWidth;
  final StrokeCap strokeCap;
  final PaintingStyle style;
  final List<Map<String, Offset>> mapPoints;

  double scaleX = 1;
  double scaleY = 1;

  SimplPaint({
    this.mapPoints,
    @required this.startPoint,
    @required this.endPoint,
    @required this.basePoint,
    Path path,
    this.canvas,
    this.size,
    this.color = const Color(0xFFA54141),
    this.strokeWidth = 1,
    this.strokeCap = StrokeCap.round,
    this.style = PaintingStyle.fill,
  }) : _path = path;
  Path _path;
  @override
  void paint(canvas, size) {
    ///
    Paint _paintBezier = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = strokeCap
      ..style = style;
    Paint _paintBezierBack = Paint()
      ..color = color.withRed(250)
      ..strokeWidth = strokeWidth
      ..strokeCap = strokeCap
      ..style = PaintingStyle.fill;

    _path = true ? Path() : _path;

    ///
    for (Map<String, Offset> offset in mapPoints) {
      if (mapPoints[0] == offset) {
        _path.moveTo(
          offset['startPoint'].dx,
          offset['startPoint'].dy,
        );
      } else {
        _path.quadraticBezierTo(
          offset['basePoint'].dx,
          offset['basePoint'].dy,
          offset['endPoint'].dx,
          offset['endPoint'].dy,
        );
      }

      _path.quadraticBezierTo(
        offset['basePoint'].dx,
        offset['basePoint'].dy,
        offset['endPoint'].dx,
        offset['endPoint'].dy,
      );

      ///
      canvas.drawPath(_path, _paintBezier);
    }

    //canvas.drawPath(_path, _paintBezierBack);
    //canvas.drawPath(_path, _paintBezierBack);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
