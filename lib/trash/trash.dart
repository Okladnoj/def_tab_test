/*
  GlobalKey key = GlobalKey<_LiqidContainerState>();
  List<BezierPoints> listBezierPoints = [];
  Offset basePoint;
  final countStep = 50;
  BoxConstraints constraints;
  List<LayerModel> layerModel;
  @override
  void initState() {
    super.initState();
  }

  Future<void> redrow(Offset tapPoint) async {
    double bX = basePoint.dx;
    double bY = basePoint.dy;
    double dX = tapPoint.dx - basePoint.dx;
    double dY = tapPoint.dy - basePoint.dy;
    double basePointKof = 5;

    for (int i = 0; i < countStep; i++) {
      await Future.delayed(
          Duration(
            microseconds: 250,
          ), () {
        setState(() {
          listBezierPoints = [];
          basePoint = Offset(
            bX + (dX / countStep * i) * basePointKof,
            bY + (dY / countStep * i) * basePointKof,
          );
          listBezierPoints = listBezierPoints;
        });
      });
    }
    for (int i = countStep; i >= 0; i--) {
      await Future.delayed(
          Duration(
            milliseconds: 30,
          ), () {
        setState(() {
          listBezierPoints = [];
          basePoint = Offset(
            bX + (dX / countStep * i) * basePointKof,
            bY + (dY / countStep * i) * basePointKof,
          );
        });
        listBezierPoints = listBezierPoints;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
*/

/**
 Offset startPoint = Offset(
            constraints.minWidth,
            constraints.maxHeight / 2,
          );
          Offset endPoint = Offset(
            constraints.maxWidth,
            constraints.maxHeight / 2,
          );
          basePoint = basePoint ?? (startPoint + endPoint) / 2;
          listBezierPoints.add(BezierPoints(
            startPoint: startPoint,
            endPoint: endPoint,
            basePoint: basePoint,
          ));

          ///
          startPoint = endPoint;
          endPoint = Offset(
            constraints.maxWidth,
            (constraints.maxHeight / 2) + 50,
          );
          basePoint = basePoint ?? (startPoint + endPoint) / 2;
          listBezierPoints.add(BezierPoints(
            startPoint: startPoint,
            endPoint: endPoint,
            basePoint: basePoint,
          ));

          ///
          startPoint = endPoint;
          endPoint = Offset(
            constraints.minWidth,
            (constraints.maxHeight / 2) + 50,
          );
          basePoint = basePoint ?? (startPoint + endPoint) / 2;
          listBezierPoints.add(BezierPoints(
            startPoint: startPoint,
            endPoint: endPoint,
            basePoint: basePoint,
          ));

          ///
          startPoint = endPoint;
          endPoint = Offset(
            constraints.minWidth,
            (constraints.maxHeight / 2),
          );
          basePoint = basePoint ?? (startPoint + endPoint) / 2;
          listBezierPoints.add(BezierPoints(
            startPoint: startPoint,
            endPoint: endPoint,
            basePoint: basePoint,
          ));
          Future.delayed(
              Duration(
                milliseconds: 250,
              ),
              () => basePoint = (startPoint + endPoint) / 2);

*/
