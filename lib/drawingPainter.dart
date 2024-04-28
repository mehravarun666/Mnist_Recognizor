import 'package:digitrecognizertflite/constants.dart';
import 'package:flutter/material.dart';

class DrawingPainter extends CustomPainter {
  final List<List<double>> points;
  final Color colorstroke;

  DrawingPainter(this.points, this.colorstroke);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint _paint = Paint()
      ..strokeCap = StrokeCap.round
      ..color = colorstroke 
      ..strokeWidth = Constants.strokeWidth;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i][0] != -1 && points[i + 1][0] != -1) {
        canvas.drawLine(
          Offset(points[i][0], points[i][1]),
          Offset(points[i + 1][0], points[i + 1][1]),
          _paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
