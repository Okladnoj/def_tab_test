import 'package:def_tab_test/liqid_container/core/core_streame_paint.dart';
import 'package:flutter/material.dart';

import 'model_layers.dart';
import 'model_touch.dart';

class OptionsParam {
  /// Конструктор с настройками жидкого виджета
  OptionsParam({
    this.tension = 0.45,
    this.width = 50,
    this.height = 20,
    this.hoverFactor = -0.3,
    this.gap = 5,
    this.forceFactor = 0.15,
    this.color1 = const Color(0xff36DFE7),
    this.color2 = const Color(0xff8F17E1),
    this.color3 = const Color(0xffE509E6),
    List<LayerModel> layers,
    List<TouchModel> touches,
    this.noise = 0,
  })  : this.layers = layers ??
            [
              LayerModel(
                points: [],
                viscosity: 0.5,
                touchForce: 100,
                forceLimit: 2,
              ),
              LayerModel(
                points: [],
                viscosity: 0.8,
                touchForce: 150,
                forceLimit: 3,
              ),
            ],
        this.touches = touches ?? [];
  double tension;
  double width;
  double height;
  double gap;
  double hoverFactor;
  double forceFactor;
  Color color1;
  Color color2;
  Color color3;
  List<LayerModel> layers;
  List<TouchModel> touches;
  double noise;
  CorePaint corePaint;
}
