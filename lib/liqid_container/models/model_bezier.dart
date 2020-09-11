import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';

class BezierPoints {
  Offset controlPointOne;
  Offset endPoint;
  Offset controlPointTwo;
  BezierPoints({
    @required this.controlPointOne,
    @required this.endPoint,
    @required this.controlPointTwo,
  });
}
