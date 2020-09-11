import 'package:flutter/cupertino.dart';

class DynamicPoint {
  double x;
  double y;
  double ox;
  double oy;
  double vx;
  double vy;
  DynamicPoint pNext;
  DynamicPoint pPrev;
  Offset cNext;
  Offset cPrev;

  DynamicPoint({
    this.x,
    this.y,
    this.ox,
    this.oy,
    this.vx,
    this.vy,
  });
}
