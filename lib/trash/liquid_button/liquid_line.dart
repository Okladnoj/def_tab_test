import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'option_model.dart';
import 'paint_canvas.dart';

class MyPainter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bezier'),
      ),
      body: Column(
        children: [
          Expanded(child: LiqidLine()),
          Expanded(child: LiqidLine()),
          Expanded(child: LiqidLine()),
          Expanded(child: LiqidLine()),
        ],
      ),
    );
  }
}

class LiqidLine extends StatefulWidget {
  const LiqidLine({Key key, OptionsParam optionsParam})
      : _optionsParam = optionsParam,
        super(key: key);
  final OptionsParam _optionsParam;

  @override
  _LiqidLineState createState() => _LiqidLineState(optionsParam: _optionsParam);
}

class _LiqidLineState extends State<LiqidLine> {
  _LiqidLineState({OptionsParam optionsParam})
      : tension = optionsParam.tension,
        width = optionsParam.width,
        height = optionsParam.height,
        margin = optionsParam.margin,
        padding = optionsParam.padding,
        hoverFactor = optionsParam.hoverFactor,
        gap = optionsParam.gap,
        debug = optionsParam.debug,
        forceFactor = optionsParam.forceFactor,
        color1 = optionsParam.color1,
        color2 = optionsParam.color2,
        color3 = optionsParam.color3,
        textColor = optionsParam.textColor,
        layers = optionsParam.layers,
        text = optionsParam.text,
        touches = optionsParam.touches,
        noise = optionsParam.noise;
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
  final List<Map<String, dynamic>> layers;
  final String text;
  List<Map<String, dynamic>> touches;
  final double noise;
  Canvas canvas;
  Paint paintBezier;
  Offset startPoint;
  Offset endPoint;
  Offset basePoint;
  Path _path = Path();
  List<PointModel> points;
  Map<String, dynamic> layer;
  List<Map<String, Offset>> listMapPoints = [];
  Timer _timer;

  final countStep = 50;
  @override
  void initState() {
    paintBezier = Paint();
    initOrigins();
    _timer = Timer.periodic(Duration(milliseconds: 1000), (_) {
      setState(() {
        animate();
      });
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    initOrigins();
    super.didChangeDependencies();
  }

  @override
  dispose() {
    _timer.cancel();
    super.dispose();
  }

  pressMove(Offset localPosition) {
    this.touches = [
      {
        'x': localPosition.dx,
        'y': localPosition.dy,
        'z': 0,
        'force': 1,
      }
    ];
  }

  pressOut() {
    this.touches = [];
  }

  double distance(PointModel p1, PointModel p2) {
    return math.sqrt(
      math.pow(p1.x - p2.x, 2) + math.pow(p1.y - p2.y, 2),
    );
  }

  update() {
    for (var layerIndex = 0; layerIndex < this.layers.length; layerIndex++) {
      listMapPoints = [];
      layer = this.layers[layerIndex];
      List<PointModel> points = layer['points'];
      for (var pointIndex = 0; pointIndex < points.length; pointIndex++) {
        PointModel point = points[pointIndex];
        double dx = point.ox -
            point.x +
            (math.Random().nextDouble() - 0.5) * this.noise;
        double dy = point.oy -
            point.y +
            (math.Random().nextDouble() - 0.5) * this.noise;
        double d = math.sqrt(dx * dx + dy * dy);
        double f = d * this.forceFactor;
        point.vx += (dx / d).isNaN ? 0 : f * ((dx / d));
        point.vy += (dy / d).isNaN ? 0 : f * ((dy / d));
        for (int touchIndex = 0;
            touchIndex < this.touches.length;
            touchIndex++) {
          final touch = this.touches[touchIndex];
          double mouseForce = double.parse(layer['mouseForce'].toString());
          if (touch['x'] > this.margin &&
              touch['x'] < this.margin + this.width &&
              touch['y'] > this.margin &&
              touch['y'] < this.margin + this.height) {
            mouseForce *= -this.hoverFactor;
          }
          double mx = point.x - touch['x'];
          double my = point.y - touch['y'];
          double md = math.sqrt(mx * mx + my * my);
          double mf = math.max(
            -double.parse(layer['forceLimit'].toString()),
            math.min(double.parse(layer['forceLimit'].toString()),
                (mouseForce * touch['force']) / md),
          );
          point.vx += (mx / md).isNaN ? 0 : mf * ((mx / md));
          point.vy += (mx / md).isNaN ? 0 : mf * ((my / md));
        }
        point.vx *= layer['viscosity'];
        point.vy *= layer['viscosity'];
        point.x += point.vx;
        point.y += point.vy;
      }
      for (int pointIndex = 0; pointIndex < points.length; pointIndex++) {
        PointModel prev =
            points[(pointIndex + points.length - 1) % points.length];
        PointModel point = points[pointIndex];
        PointModel next =
            points[(pointIndex + points.length + 1) % points.length];
        final dPrev = this.distance(point, prev);
        final dNext = this.distance(point, next);

        final line = {
          'x': next.x - prev.x,
          'y': next.y - prev.y,
        };
        final dLine = math.sqrt(line['x'] * line['x'] + line['y'] * line['y']);

        point.cPrev = CPrev(
          x: point.x - (line['x'] / dLine) * dPrev * this.tension,
          y: point.y - (line['y'] / dLine) * dPrev * this.tension,
        );
        point.cNext = CNext(
          x: point.x + (line['x'] / dLine) * dNext * this.tension,
          y: point.y + (line['y'] / dLine) * dNext * this.tension,
        );
      }
    }
  }

  animate() {
    update();
    draw();
    setState(() {
      listMapPoints = listMapPoints;
    });
  }

  draw() async {
    listMapPoints = [];
    for (int layerIndex = 0; layerIndex < this.layers.length; layerIndex++) {
      layer = this.layers[layerIndex];
      if (layerIndex == 1) {
        if (this.touches.length > 0) {
          double gx = this.touches[0]['x'];
          double gy = this.touches[0]['y'];
          layer['color'] = ui.Gradient.radial(
              Offset(gx, gy), this.height * 2, [this.color2, this.color3]);
        } else {
          layer['color'] = this.color2;
        }
      } else {
        layer['color'] = this.color1;
      }
      points = layer['points'];

      paintBezier.color = layer['color'];

      for (int pointIndex = 1; pointIndex < points.length; pointIndex++) {
        startPoint = Offset(
          points[(pointIndex + 0) % points.length].cNext.x,
          points[(pointIndex + 0) % points.length].cNext.y,
        );
        endPoint = Offset(
          points[(pointIndex + 1) % points.length].cPrev.x,
          points[(pointIndex + 1) % points.length].cPrev.y,
        );
        basePoint = Offset(
          points[(pointIndex + 1) % points.length].x,
          points[(pointIndex + 1) % points.length].y,
        );
        listMapPoints.add({
          'startPoint': startPoint,
          'endPoint': endPoint,
          'basePoint': basePoint,
        });
        // _path.moveTo(
        //   startPoint.dx,
        //   startPoint.dy,
        // );
        // _path.quadraticBezierTo(
        //   basePoint.dx,
        //   basePoint.dy,
        //   endPoint.dx,
        //   endPoint.dy,
        // );

        await Future.delayed(Duration(microseconds: 500), () => {});
      }
    }
    if (this.debug) {
      this.drawDebug();
    }
  }

  drawDebug() {
    // this.context.fillStyle = 'rgba(255, 255, 255, 0.8)';
    // this.context.fillRect(0, 0, this.canvas.width, this.canvas.height);
    // for (final layerIndex = 0; layerIndex < this.layers.length; layerIndex++) {
    //     final layer = this.layers[layerIndex];
    //      points = layer['points'];
    //     for (final pointIndex = 0; pointIndex < points.length; pointIndex++) {
    //         if (layerIndex === 0) {
    //             this.context.fillStyle = this.color1;
    //         } else {
    //             this.context.fillStyle = this.color2;
    //         }
    //         final point = points[pointIndex];
    //         this.context.fillRect(point.x, point.y, 1, 1);
    //         this.context.fillStyle = '#000';
    //         this.context.fillRect(point.cPrev.x, point.cPrev.y, 1, 1);
    //         this.context.fillRect(point.cNext.x, point.cNext.y, 1, 1);
    //         this.context.strokeStyle = 'rgba(0, 0, 0, 0.33)';
    //         this.context.strokeWidth = 0.5;
    //         this.context.beginPath();
    //         this.context.moveTo(point.cPrev.x, point.cPrev.y);
    //         this.context.lineTo(point.cNext.x, point.cNext.y);
    //         this.context.stroke();
    //     }
    // }
  }

  createPoint(x, y) {
    return PointModel(
      x: x,
      y: y,
      ox: x,
      oy: y,
      vx: 0,
      vy: 0,
    );
  }

  initOrigins() {
    for (int layerIndex = 0; layerIndex < this.layers.length; layerIndex++) {
      layer = this.layers[layerIndex];
      points = [];
      for (double x = double.parse((this.height / 2).floor().toString());
          x < this.width - (this.height / 2).floor();
          x += this.gap) {
        points.add(this.createPoint(x + this.margin, this.margin));
      }
      for (double alpha = double.parse((this.height * 1.25).floor().toString());
          alpha >= 0;
          alpha -= this.gap) {
        double angle = (math.pi / (this.height * 1.25)).floor() * alpha;
        points.add(this.createPoint(
            math.sin(angle) * this.height / 2 +
                this.margin +
                this.width -
                this.height / 2,
            math.cos(angle) * this.height / 2 + this.margin + this.height / 2));
      }
      for (double x = this.width - (this.height / 2).floor() - 1;
          x >= (this.height / 2).floor();
          x -= this.gap) {
        points
            .add(this.createPoint(x + this.margin, this.margin + this.height));
      }
      for (double alpha = 0;
          alpha <= (this.height * 1.25).floor();
          alpha += this.gap) {
        double angle = (math.pi / (this.height * 1.25).floor()) * alpha;
        points.add(this.createPoint(
            (this.height - math.sin(angle) * this.height / 2) +
                this.margin -
                this.height / 2,
            math.cos(angle) * this.height / 2 + this.margin + this.height / 2));
      }
      layer['points'] = points;
    }
  }

  final redraw = () => {
        // button.initOrigins();
      };

  @override
  Widget build(BuildContext context) {
    //initOrigins();
    return Container(
      decoration: kBoxDecorationLable,
      margin: EdgeInsets.all(5),
      child: GestureDetector(
        onTapDown: (_) async {
          pressMove(_.globalPosition);
          animate();
        },
        onTapUp: (details) {
          pressOut();
        },
        onVerticalDragUpdate: (_) async {
          pressMove(_.globalPosition);
          animate();
        },
        onHorizontalDragUpdate: (_) async {
          pressMove(_.globalPosition);
          animate();
        },
        child: LayoutBuilder(builder: (context, constraints) {
          // Offset startPoint = Offset(
          //   constraints.minWidth,
          //   constraints.maxHeight / 2,
          // );
          // Offset endPoint = Offset(
          //   constraints.maxWidth,
          //   constraints.maxHeight / 2,
          // );
          // Offset basePoint = (startPoint + endPoint) / 2;
          // Future.delayed(
          //     Duration(
          //       milliseconds: 250,
          //     ),
          //     () => basePoint = (startPoint + endPoint) / 2);
          return CustomPaint(
            painter: SimplPaint(
              startPoint: startPoint,
              endPoint: endPoint,
              basePoint: basePoint,
              mapPoints: listMapPoints,
              path: _path,
              color: Color(0x8F48FF00),
              style: PaintingStyle.fill,
              strokeWidth: 1,
            ),
            child: Container(),
          );
        }),
      ),
    );
  }
}

BoxDecoration kBoxDecorationLable = BoxDecoration(
    borderRadius: BorderRadius.circular(5),
    color: Color(0xFFC2C2C2),
    border: Border.all(
      color: Color(0xFF9E0089),
      width: 3,
    ));
