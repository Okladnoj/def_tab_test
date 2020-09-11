import 'dart:ui';

import 'liqid_container/models/model_layers.dart';
import 'liqid_container/models/model_options.dart';

OptionsParam gOptionsParam1 = OptionsParam(layers: [
  LayerModel(
    points: [],
    viscosity: 0.5,
    touchForce: 100,
    forceLimit: 2,
    color: Color(0xAFD80101),
  ),
  LayerModel(
    points: [],
    viscosity: 0.8,
    touchForce: 150,
    forceLimit: 3,
    color: Color(0xAF0E00CE),
  ),
]);
OptionsParam gOptionsParam2 = OptionsParam(layers: [
  LayerModel(
    points: [],
    viscosity: 0.5,
    touchForce: 100,
    forceLimit: 40,
    color: Color(0xAFB1D801),
  ),
  LayerModel(
    points: [],
    viscosity: 0.8,
    touchForce: 150,
    forceLimit: 50,
    color: Color(0xAF00AFCE),
  ),
]);
OptionsParam gOptionsParam3 = OptionsParam(
  layers: [
    LayerModel(
      points: [],
      viscosity: 0.80,
      touchForce: 150,
      forceLimit: 50,
      color: Color(0xAF08D801),
    ),
    LayerModel(
      points: [],
      viscosity: 0.8,
      touchForce: 120,
      forceLimit: 40,
      color: Color(0xAF0E00CE),
    ),
  ],
  gap: 5,
  noise: 8,
);
OptionsParam gOptionsParam4 = OptionsParam(layers: [
  LayerModel(
    points: [],
    viscosity: 0.5,
    touchForce: 100,
    forceLimit: 2,
    color: Color(0xAFFFEE00),
  ),
  LayerModel(
    points: [],
    viscosity: 0.8,
    touchForce: 150,
    forceLimit: 3,
    color: Color(0xAFCB2FDA),
  ),
]);
OptionsParam gOptionsParam5 = OptionsParam(layers: [
  LayerModel(
    points: [],
    viscosity: 0.5,
    touchForce: 100,
    forceLimit: 2,
    color: Color(0xAFD80101),
  ),
  LayerModel(
    points: [],
    viscosity: 0.8,
    touchForce: 150,
    forceLimit: 3,
    color: Color(0xAF0E00CE),
  ),
]);
