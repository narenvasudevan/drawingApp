import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class Draw extends StatefulWidget {
  @override
  _DrawState createState() => _DrawState();
}

class _DrawState extends State<Draw> {
  /// body
  /// list of points
  /// paint

  List<DrawModel> pointsList = [];
  final pointsStream = BehaviorSubject<List<DrawModel>>();
  GlobalKey key = GlobalKey();
  @override
  void dispose() {
    // TODO: implement dispose
    pointsStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      body: GestureDetector(
        onPanStart: (details) {
          RenderBox renderBox = key.currentContext.findRenderObject();

          Paint paint = Paint();

          paint.color = Colors.red;
          paint.strokeCap = StrokeCap.round;
          paint.strokeWidth = 4.0;

          pointsList.add(DrawModel(
            offset: renderBox.globalToLocal(details.globalPosition),
            paint: paint,
          ));

          pointsStream.add(pointsList);
        },
        onPanUpdate: (details) {
          RenderBox renderBox = key.currentContext.findRenderObject();

          Paint paint = Paint();

          paint.color = Colors.red;
          paint.strokeCap = StrokeCap.round;
          paint.strokeWidth = 4.0;

          pointsList.add(DrawModel(
            offset: renderBox.globalToLocal(details.globalPosition),
            paint: paint,
          ));

          pointsStream.add(pointsList);
        },
        onPanEnd: (details) {
          pointsList.add(null);
          pointsStream.add(pointsList);
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: StreamBuilder<List<DrawModel>>(
              stream: pointsStream.stream,
              builder: (context, snapshot) {
                return CustomPaint(
                  painter: DrawingPainter(snapshot.data ?? []),
                );
              }),
        ),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<DrawModel> pointsList;

  DrawingPainter(this.pointsList);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < (pointsList.length - 1); i++) {
      if (pointsList[i] != null && pointsList[i + 1] != null) {
        canvas.drawLine(pointsList[i].offset, pointsList[i + 1].offset,
            pointsList[i].paint);
      } else if (pointsList[i] != null && pointsList[i + 1] == null) {
        List<Offset> offsetList = [];
        offsetList.add(pointsList[i].offset);

        canvas.drawPoints(PointMode.points, offsetList, pointsList[i].paint);
      }
    }
    // TODO: implement paint
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

class DrawModel {
  final Offset offset;
  final Paint paint;

  DrawModel({this.offset, this.paint});
}
