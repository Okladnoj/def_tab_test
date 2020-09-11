import 'package:flutter/material.dart';

import 'option_model.dart';

class LiquidWidgetBezier extends StatefulWidget {
  const LiquidWidgetBezier({Key key, OptionsParam optionsParam})
      : _optionsParam = optionsParam,
        super(key: key);
  final OptionsParam _optionsParam;

  @override
  _LiquidWidgetBezierState createState() =>
      _LiquidWidgetBezierState(optionsParam: _optionsParam);
}

class _LiquidWidgetBezierState extends State<LiquidWidgetBezier> {
  _LiquidWidgetBezierState({OptionsParam optionsParam})
      : width = optionsParam.width,
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

  double width;
  double height;
  double margin;
  double padding;
  double hoverFactor;
  double gap;
  bool debug;
  double forceFactor;
  Color color1;
  Color color2;
  Color color3;
  Color textColor;
  List<Map<String, dynamic>> layers;
  String text;
  List<Map<String, dynamic>> touches;
  double noise;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
