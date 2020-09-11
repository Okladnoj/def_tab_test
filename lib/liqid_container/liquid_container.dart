import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'models/model_layers.dart';
import 'models/model_options.dart';
import 'models/model_touch.dart';
import 'canvas/canvas_draw.dart';
import 'core/core_streame_paint.dart';

class LiqidContainer extends StatelessWidget {
  final BoxDecoration boxDecorationLable;
  final OptionsParam optionsParam;
  final Widget child;
  final Function onTap;
  const LiqidContainer({
    Key key,
    this.boxDecorationLable,
    this.onTap,
    @required this.optionsParam,
    this.child,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height;
    double width;
    CorePaint _corePaint;
    Future.delayed(Duration(milliseconds: 200), () {
      _corePaint.updatePointsStream
          .add([touchApdate(Offset(width / 2, height / 2), force: 30)]);
      _corePaint.updatePointsStream.add([]);
    });

    return Container(
      decoration: boxDecorationLable,
      child: GestureDetector(
        onTap: onTap,
        onTapDown: (_) {
          _corePaint.updatePointsStream
              .add([touchApdate(_.localPosition, force: 10)]);
        },
        onVerticalDragUpdate: (_) {
          _corePaint.updatePointsStream.add([touchApdate(_.localPosition)]);
        },
        onVerticalDragEnd: (details) {
          _corePaint.updatePointsStream.add([]);
        },
        onHorizontalDragUpdate: (_) {
          _corePaint.updatePointsStream.add([touchApdate(_.localPosition)]);
        },
        onHorizontalDragEnd: (details) {
          _corePaint.updatePointsStream.add([]);
        },
        onTapUp: (_) {
          _corePaint.updatePointsStream.add([]);
        },
        child: LayoutBuilder(builder: (context, constraints) {
          height = constraints.maxHeight;
          width = constraints.maxWidth;
          double topRight = 0;
          double bottomRight = 0;
          double topLeft = 0;
          double bottomLeft = 0;
          if (boxDecorationLable.borderRadius != null) {
            final _borderRadius = boxDecorationLable.borderRadius.toString();

            final _circular = 'BorderRadius.circular(';
            final _only = 'BorderRadius.only(';
            if (_borderRadius.contains(_circular)) {
              double _cir = double.parse(_borderRadius.substring(
                  _circular.length, _borderRadius.length - 2));
              topRight = _cir;
              bottomRight = _cir;
              topLeft = _cir;
              bottomLeft = _cir;
            } else if (_borderRadius.contains(_only)) {
              topRight = getPiceOfString(
                  start: 'topRight: Radius.circular(',
                  end: ')',
                  exstract: _borderRadius);
              bottomRight = getPiceOfString(
                  start: 'bottomRight: Radius.circular(',
                  end: ')',
                  exstract: _borderRadius);
              topLeft = getPiceOfString(
                  start: 'topLeft: Radius.circular(',
                  end: ')',
                  exstract: _borderRadius);
              bottomLeft = getPiceOfString(
                  start: 'bottomLeft: Radius.circular(',
                  end: ')',
                  exstract: _borderRadius);
            }
          }
          optionsParam.corePaint?.dispose();
          optionsParam.corePaint = _corePaint = CorePaint(
            height: height,
            width: width,
            topRight: topRight,
            bottomRight: bottomRight,
            topLeft: topLeft,
            bottomLeft: bottomLeft,
            optionsParam: optionsParam,
          );

          return StreamBuilder<List<LayerModel>>(
              stream: _corePaint.streamlistLayerModel,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.first.points.first.cNext != null) {
                    return CustomPaint(
                      painter: SimplPaint(
                        layerModel: snapshot.data,
                      ),
                      child: child,
                    );
                  } else {
                    return Container(child: CircularProgressIndicator());
                  }
                } else {
                  return Container(child: CircularProgressIndicator());
                }
              });
        }),
      ),
    );
  }

  TouchModel touchApdate(Offset offset, {double force = 10}) {
    return TouchModel(
      x: offset.dx,
      y: offset.dy,
      z: 0,
      force: force,
    );
  }

  void touchCanel(dynamic dynam) {
    optionsParam.touches = [];
  }
}

double getPiceOfString({String start, String end, String exstract}) {
  int _st = exstract.indexOf(start) + start.length;
  int _en = exstract.indexOf(end, _st);
  String _temp = exstract.substring(_st, _en);
  try {
    return double.parse(_temp);
  } catch (e) {
    return 0.0;
  }
}
