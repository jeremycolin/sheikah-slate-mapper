import 'package:flutter/material.dart';
import 'dart:math' as math;

class CameraPainter extends CustomPainter {
  CameraPainter();

  Paint get _brush => new Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 4;

  @override
  void paint(Canvas canvas, Size size) {
    Paint crosshair = _brush..color = Colors.black54;

    double radius = math.min(size.width / 8, size.height / 8);
    Offset center = Offset(size.width / 2, size.height / 2);
    Offset start = Offset(center.dx, center.dy - radius / 4);
    Offset end = Offset(center.dx, center.dy - radius);

    // draw the crosshair
    canvas.drawLine(start, end, crosshair);
    for (int _ in [0, 1, 2]) {
      canvas.translate(center.dx, center.dy);
      canvas.rotate(-2 / 4 * math.pi);
      canvas.translate(-center.dx, -center.dy);
      canvas.drawLine(start, end, crosshair);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
