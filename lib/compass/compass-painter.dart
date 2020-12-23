import 'package:flutter/material.dart';

import 'dart:math' as math;

class CompassPainter extends CustomPainter {
  final double heading;
  final double cameraHeading;
  CompassPainter(this.heading, this.cameraHeading);

  double get rotation => -2 * math.pi * (heading / 360);

  Paint get _brush => new Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 8;

  @override
  void paint(Canvas canvas, Size size) {
    Paint circle = _brush..color = Colors.indigo[400].withOpacity(0.6);
    Paint needle = _brush..color = Colors.red[400];

    double radius = math.min(size.width / 2.5, size.height / 2.5);
    Offset center = Offset(size.width / 2, size.height / 2);

    Offset start = Offset(center.dx, center.dy - radius / 2);
    Offset end = Offset(center.dx, center.dy - radius);

    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    canvas.translate(-center.dx, -center.dy);
    canvas.drawLine(start, end, needle);
    canvas.drawCircle(center, radius, circle);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
