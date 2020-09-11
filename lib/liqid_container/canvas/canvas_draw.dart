import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import '../models/model_bezier.dart';
import '../models/model_dynamic_point.dart';
import '../models/model_layers.dart';

class SimplPaint extends CustomPainter {
  final List<LayerModel> _listLayerModel;

  SimplPaint({
    List<LayerModel> layerModel,
  }) : _listLayerModel = layerModel;

  @override
  void paint(canvas, size) {
    try {
      for (LayerModel _layerModel in _listLayerModel) {
        Path _path = Path();
        Paint _paintStyle = _layerModel.paintStyle;

        for (int i = 0; i < _layerModel.points.length; i++) {
          int v0 = (i + 0) % _layerModel.points.length;
          int v1 = (i + 1) % _layerModel.points.length;

          if (_layerModel.points[0] == _layerModel.points[i]) {
            _path.moveTo(
              _layerModel.points[v0].x,
              _layerModel.points[v0].y,
            );
            _path.cubicTo(
              _layerModel.points[v0].cNext.dx,
              _layerModel.points[v0].cNext.dy,
              _layerModel.points[v1].cPrev.dx,
              _layerModel.points[v1].cPrev.dy,
              _layerModel.points[v1].x,
              _layerModel.points[v1].y,
            );
          } else {
            _path.cubicTo(
              _layerModel.points[v0].cNext.dx,
              _layerModel.points[v0].cNext.dy,
              _layerModel.points[v1].cPrev.dx,
              _layerModel.points[v1].cPrev.dy,
              _layerModel.points[v1].x,
              _layerModel.points[v1].y,
            );
          }
        }
        canvas.drawPath(_path, _paintStyle);
      }
    } catch (e) {}
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  /// Преобразование списка точек в список Безье пар
  List<BezierPoints> getBezierPoints(List<DynamicPoint> listOffsets) {
    List<BezierPoints> listBezierPoints = [];

    for (int i = 0; i <= listOffsets.length; i++) {
      int v0 = (i + 0) % listOffsets.length;
      int v1 = (i + 1) % listOffsets.length;
      try {
        listBezierPoints.add(BezierPoints(
          controlPointOne:
              Offset(listOffsets[v0].pNext.x, listOffsets[v0].pNext.y),
          controlPointTwo:
              Offset(listOffsets[v1].pPrev.x, listOffsets[v1].pPrev.y),
          endPoint: Offset(listOffsets[v1].x, listOffsets[v1].y),
        ));
      } catch (e) {
        print('print - $e');
      }
    }
    return listBezierPoints;
  }
}
