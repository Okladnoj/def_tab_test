import 'dart:ui';

import 'model_dynamic_point.dart';

class LayerModel {
  /// точки контура Безье
  List<DynamicPoint> points;
  double viscosity;
  double touchForce;
  int forceLimit;
  Paint paintStyle;
  Color color;

  /// Модель слоя на основе которой отрисовывается изображение на [Canvas]
  LayerModel({
    List<DynamicPoint> points,
    this.viscosity,
    this.touchForce,
    this.forceLimit,
    this.color,
    Paint paintStyle,
  })  : this.points = points ?? [],
        this.paintStyle = paintStyle ?? Paint()
          ..color = color ?? Color(0xA1FF0000)
          ..strokeWidth = 1
          ..style = PaintingStyle.fill;
}
