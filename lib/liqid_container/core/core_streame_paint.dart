import 'dart:async';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:math' as math;
import 'package:vector_math/vector_math.dart';
import '../models/model_distance_vector.dart';
import '../models/model_dynamic_point.dart';
import '../models/model_layers.dart';
import '../models/model_line.dart';
import '../models/model_options.dart';
import '../models/model_touch.dart';

class CorePaint {
  final double height;
  final double width;
  final double topRight;
  final double bottomRight;
  final double topLeft;
  final double bottomLeft;
  OptionsParam optionsParam;
  List<LayerModel> listLayerModel;
  List<DynamicPoint> _points = [];
  Set<Offset> _allOffsets;
  final _gap;
  Timer _timerOfRedrow;
  Path _path = Path();

  CorePaint({
    @required this.height,
    @required this.width,
    @required this.topRight,
    @required this.bottomRight,
    @required this.topLeft,
    @required this.bottomLeft,
    @required this.optionsParam,
  })  : _gap = optionsParam.gap,
        listLayerModel = optionsParam.layers {
    _updateTouchesController.stream.listen(_streamUpdateTouches);
    getPoints();
    writeDynamicPoints();
    _changeStream();
    rePaint();
  }

  void updatePoints() {
    math.Random _random = math.Random();
    List<TouchModel> touches = optionsParam.touches;
    for (LayerModel layer in optionsParam.layers) {
      for (DynamicPoint point in layer.points) {
        double dx = point.ox -
            point.x +
            (_random.nextDouble() - 0.5) * optionsParam.noise;
        double dy = point.oy -
            point.y +
            (_random.nextDouble() - 0.5) * optionsParam.noise;
        double d = math.sqrt(dx * dx + dy * dy);
        double f = d * optionsParam.forceFactor;
        point.vx += f * ((dx / d).isNaN ? 0 : (dx / d));
        point.vy += f * ((dy / d).isNaN ? 0 : (dy / d));
        for (int touchIndex = 0; touchIndex < touches.length; touchIndex++) {
          TouchModel touch = touches[touchIndex];
          layer.paintStyle.shader = ui.Gradient.radial(
              Offset(touch.x, touch.y),
              math.max(width, height),
              [optionsParam.layers[0].color, optionsParam.layers.last.color]);
          double mouseForce = layer.touchForce;
          if (_path.contains(Offset(touch.x, touch.y))) {
            mouseForce *= -optionsParam.hoverFactor;
          } else {
            layer.paintStyle.shader = null;
          }
          double mx = point.x - touch.x;
          double my = point.y - touch.y;
          double md = math.sqrt(mx * mx + my * my);
          double mf = math.max(
              -layer.forceLimit?.toDouble(),
              math.min(layer.forceLimit?.toDouble(),
                  (mouseForce * touch.force) / md));
          point.vx += mf * ((mx / d).isNaN ? 0 : (mx / md));
          point.vy += mf * ((my / d).isNaN ? 0 : (my / md));
        }
        if (touches.length < 1) {
          layer.paintStyle.shader = null;
        }
        point.vx *= layer.viscosity;
        point.vy *= layer.viscosity;
        point.x += point.vx;
        point.y += point.vy;
      }
    }

    for (LayerModel layer in optionsParam.layers) {
      for (DynamicPoint point in layer.points) {
        calculateNextPrev(point);
      }
    }
  }

  double limitAdd({@required num value, num limit = 25, num kof = 4}) {
    if (value > 0) {
      return limit - ((limit * kof) / (value + kof));
    } else {
      return -(limit - ((limit * kof) / (-value + kof)));
    }
  }

  void calculateNextPrev(DynamicPoint point) {
    final prev = point.pPrev;
    final next = point.pNext;
    final dPrev = distance1(point, prev);
    final dNext = distance1(point, next);
    Line line = Line(
      x: next.x - prev.x,
      y: next.y - prev.y,
    );
    final dLine = math.sqrt(line.x * line.x + line.y * line.y);

    point.cPrev = Offset(
      point.x - (line.x / dLine) * dPrev * optionsParam.tension,
      point.y - (line.y / dLine) * dPrev * optionsParam.tension,
    );
    point.cNext = Offset(
      point.x + (line.x / dLine) * dNext * optionsParam.tension,
      point.y + (line.y / dLine) * dNext * optionsParam.tension,
    );
  }

  distance1(DynamicPoint p1, DynamicPoint p2) {
    return math.sqrt(math.pow(p1.x - p2.x, 2) + math.pow(p1.y - p2.y, 2));
  }

  VectorDistanse distance({
    @required DynamicPoint dynamicPoint,
    @required TouchModel touche,
  }) {
    final distance = math.sqrt(
      math.pow(dynamicPoint.x - touche.x, 2) +
          math.pow(dynamicPoint.y - touche.y, 2),
    );
    final dx = dynamicPoint.x - touche.x;
    final dy = dynamicPoint.y - touche.y;
    return VectorDistanse(
      distance: distance,
      vx: dx / distance,
      vy: dy / distance,
    );
  }

  /// Перекомпоновка слоев, положения точек Безье, цвета, градиента
  void redrow() {
    for (final layerModel in listLayerModel) {
      layerModel.points.clear();
      layerModel.points = _points;
    }
  }

  /// Расчет точек обрамляющих исходный виджет
  void getPoints() {
    double _alfa;
    double _gapTemp;
    double dx = topLeft;
    double dy = 0;
    _allOffsets = Set<Offset>();

    /// Верхняя грань виджета =================================================<
    double upLine = width - topLeft - topRight;
    _gapTemp = _getGapTemp(line: upLine, gap: _gap);
    for (double i = 0; i <= upLine; i += _gapTemp) {
      _allOffsets.add(Offset(dx + i, dy));
    }

    /// Правый верхний угол виджета ===========================================<
    if (topRight > _gap) {
      final topRightLine = topRight * math.pi / 2;
      _gapTemp = _getGapTemp(line: topRightLine, gap: _gap);
      _alfa = (_gapTemp * 180) / (topRight * math.pi);
      double dxO = width - topLeft;
      double dyO = topLeft;
      for (double i = 270 - _alfa; i < 360; i += _alfa) {
        dx = dxO + (topRight * math.cos(radians(i)));
        dy = dyO + (topRight * math.sin(radians(i)));
        _allOffsets.add(Offset(dx, dy));
      }
    }

    /// Правая грань виджета ==================================================<
    double rightLine = height - topRight - bottomRight;
    _gapTemp = _getGapTemp(line: rightLine, gap: _gap);
    dx = width;
    dy = topRight;
    for (double i = 0; i <= rightLine; i += _gapTemp) {
      _allOffsets.add(Offset(dx, dy + i));
    }

    /// Правый нижний угол виджета ============================================<
    if (bottomRight > _gap) {
      final bottomRightLine = bottomRight * math.pi / 2;
      _gapTemp = _getGapTemp(line: bottomRightLine, gap: _gap);
      _alfa = (_gapTemp * 180) / (topRight * math.pi);

      double dxO = width - bottomRight;
      double dyO = height - bottomRight;
      for (double i = 0 - _alfa; i < 90; i += _alfa) {
        dx = dxO + (bottomRight * math.cos(radians(i)));
        dy = dyO + (bottomRight * math.sin(radians(i)));
        _allOffsets.add(Offset(dx, dy));
      }
    }

    /// Нижняя грань виджета ==================================================<
    double bottomLine = width - bottomLeft - bottomRight;
    _gapTemp = _getGapTemp(line: bottomLine, gap: _gap);
    dx = bottomLeft;
    dy = height;
    for (double i = bottomLine; i >= bottomLeft; i -= _gapTemp) {
      _allOffsets.add(Offset(dx + i, dy));
    }

    /// Левый нижний угол виджета =============================================<
    if (bottomLeft > _gap) {
      final bottomRightLine = bottomLeft * math.pi / 2;
      _gapTemp = _getGapTemp(line: bottomRightLine, gap: _gap);
      _alfa = (_gapTemp * 180) / (topRight * math.pi);

      double dxO = bottomLeft;
      double dyO = height - bottomLeft;
      for (double i = 90 - _alfa; i < 180; i += _alfa) {
        dx = dxO + (bottomLeft * math.cos(radians(i)));
        dy = dyO + (bottomLeft * math.sin(radians(i)));
        _allOffsets.add(Offset(dx, dy));
      }
    }

    /// Левая грань виджета ===================================================<
    double leftLine = height - topLeft - bottomLeft;
    _gapTemp = _getGapTemp(line: leftLine, gap: _gap);
    dx = 0;
    dy = topLeft;
    for (double i = leftLine; i >= topLeft; i -= _gapTemp) {
      _allOffsets.add(Offset(dx, dy + i));
    }

    /// Левый верхний угол виджета ============================================<
    if (topLeft > _gap) {
      final topRightLine = topLeft * math.pi / 2;
      _gapTemp = _getGapTemp(line: topRightLine, gap: _gap);
      _alfa = (_gapTemp * 180) / (topRight * math.pi);

      double dxO = topLeft;
      double dyO = topLeft;
      for (double i = 180 - _alfa; i < 270; i += _alfa) {
        dx = dxO + (topLeft * math.cos(radians(i)));
        dy = dyO + (topLeft * math.sin(radians(i)));
        _allOffsets.add(Offset(dx, dy));
      }
    }
  }

  /// Заполнение моделей динамических точек
  void writeDynamicPoints() {
    for (LayerModel layerModel in optionsParam.layers) {
      layerModel.points.clear();
      for (int i = 0; i < _allOffsets.length; i++) {
        layerModel.points.add(DynamicPoint(
          x: _allOffsets.elementAt(i).dx,
          y: _allOffsets.elementAt(i).dy,
          ox: _allOffsets.elementAt(i).dx,
          oy: _allOffsets.elementAt(i).dy,
          vx: 0,
          vy: 0,
        ));
      }

      /// Заполнение позиционирования точки относительно [pPrev] и [pNext]
      for (LayerModel layerModel in optionsParam.layers) {
        for (int i = 1; i <= layerModel.points.length; i++) {
          final v1 = (i + -1) % layerModel.points.length;
          final v0 = (i + 0) % layerModel.points.length;
          final v2 = (i + 1) % layerModel.points.length;
          layerModel.points[v0].pPrev = layerModel.points[v1];
          layerModel.points[v0].pNext = layerModel.points[v2];
        }
      }

      /// Построение грани виджета
      DynamicPoint point = optionsParam.layers[0].points.last;
      _path.moveTo(point.ox, point.oy);
      for (DynamicPoint point in optionsParam.layers[0].points) {
        _path.lineTo(point.ox, point.oy);
      }
      _path.lineTo(point.ox, point.oy);
    }
  }

  /// Расчет шага
  num _getGapTemp({@required num line, @required num gap}) {
    if (line / 2 <= gap) {
      return line / 2;
    } else {
      if (((line % gap) / 2) < gap) {
        final w1 = (line % gap);
        final w2 = (line ~/ gap);
        final w3 = w1 / w2;
        final w4 = gap + w3;
        return w4;
      } else {
        final w1 = gap - (line % gap);
        final w2 = (line ~/ gap) - 1;
        final w3 = w1 / w2;
        final w4 = gap + w3;
        return w4;
      }
    }
  }

  /// Внутренний поток (для передачи расчетных данных)
  final _newPointsStream = BehaviorSubject<List<LayerModel>>.seeded([]);

  /// Выходной поток (для передачи расчетных данных)
  Stream get streamlistLayerModel => _newPointsStream.stream;
  Sink get _addValue => _newPointsStream.sink;

  /// Входной поток (для приема точки касания)
  StreamController<List<TouchModel>> _updateTouchesController =
      StreamController();
  StreamSink<List<TouchModel>> get updatePointsStream =>
      _updateTouchesController.sink;
  void _streamUpdateTouches(List<TouchModel> data) {
    optionsParam.touches = data;
    updatePoints();
  }

  void _changeStream() {
    _addValue.add(listLayerModel);
  }

  rePaint() {
    _timerOfRedrow = Timer.periodic(Duration(milliseconds: 60), (_) {
      updatePoints();
      if (listLayerModel.first.points.first.cNext != null) {
        _addValue.add(listLayerModel);
      } else {
        print(listLayerModel.first.points.first.cNext);
      }
    });
  }

  void dispose() {
    _newPointsStream?.close();
    _updateTouchesController?.close();
    _timerOfRedrow?.cancel();
  }
}
