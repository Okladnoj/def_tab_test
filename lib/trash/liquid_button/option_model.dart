import 'package:flutter/painting.dart';

/// Класс настроек жидкого виджета
///
class OptionsParam {
  /// Конструктор с настройками жидкого виджета
  OptionsParam({
    this.tension = 0.4,
    this.width = 50,
    this.height = 20,
    this.margin = 0,
    this.padding = 0,
    this.hoverFactor = -0.1,
    this.gap = 5,
    this.debug = false,
    this.forceFactor = 0.2,
    this.color1 = const Color(0xff36DFE7),
    this.color2 = const Color(0xff8F17E1),
    this.color3 = const Color(0xffE509E6),
    this.textColor = const Color(0xffFFFFFF),
    List<Map<String, dynamic>> layers,
    this.text = 'text',
    List<Map<String, dynamic>> touches,
    this.noise = 0,
  })  : this.layers = layers ??
            [
              {
                'points': [],
                'viscosity': 0.5,
                'mouseForce': 100,
                'forceLimit': 2,
              },
              {
                'points': [],
                'viscosity': 0.8,
                'mouseForce': 150,
                'forceLimit': 3,
              }
            ],
        this.touches = touches ?? [];
  final double tension;
  final double width;
  final double height;
  final double margin;
  final double padding;
  final double hoverFactor;
  final double gap;
  final bool debug;
  final double forceFactor;
  final Color color1;
  final Color color2;
  final Color color3;
  final Color textColor;
  List<Map<String, dynamic>> layers;
  final String text;
  final List<Map<String, dynamic>> touches;
  final double noise;
}

class Layer {
  List<Offset> points;
  double viscosity;
  double mouseForce;
  double forceLimit;

  Layer(
    this.points,
    this.viscosity,
    this.mouseForce,
    this.forceLimit,
  );
}

class CPrev {
  double x;
  double y;

  CPrev({
    this.x,
    this.y,
  });
}

class CNext {
  double x;
  double y;

  CNext({
    this.x,
    this.y,
  });
}

/// Модель изменяемой точки, которая состоит в множестве точек жидкой области
class PointModel {
  double x;
  double y;
  double ox;
  double oy;
  double vx;
  double vy;
  CPrev cPrev;
  CNext cNext;

  PointModel({
    this.x,
    this.y,
    this.ox,
    this.oy,
    this.vx,
    this.vy,
    this.cPrev,
    this.cNext,
  });
}

class Touch {
  double x;
  double y;
  double z;
  double force;
  Touch({this.x, this.y, this.z, this.force});
}
