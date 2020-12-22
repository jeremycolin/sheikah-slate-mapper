import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:permission_handler/permission_handler.dart';

class CompassView extends StatefulWidget {
  @override
  _CompassViewState createState() => _CompassViewState();
}

class _CompassViewState extends State<CompassView> {
  Future<bool> _isPermissionGrantedFuture;

  @override
  void initState() {
    super.initState();
    _isPermissionGrantedFuture = _isPermissionGranted();
    _isPermissionGrantedFuture.then((isPermissionGranted) {
      if (!mounted || !isPermissionGranted) {
        return;
      }
      setState(() {});
    });
  }

  Future<bool> _isPermissionGranted() async {
    if (!await Permission.locationWhenInUse.isGranted) {
      return await Permission.locationWhenInUse.request().isGranted;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isPermissionGrantedFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data) {
          // TODO maybe render permission request button
          return Center(child: CircularProgressIndicator());
        } else {
          return Scaffold(backgroundColor: Colors.black, body: _buildCompass());
        }
      },
    );
  }

  Widget _buildCompass() {
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        double _heading = snapshot.data.heading;
        double _cameraHeading = snapshot.data.headingForCameraMode;

        // if direction is null, then device does not support this sensor
        if (_heading == null) {
          return Center(
            child: Text("Unable to read from Device sensors"),
          );
        }

        //  Text('Point to your desired pin location with your phone horizontally flat',
        // style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w400)),

        return CustomPaint(
            foregroundPainter: CompassPainter(_heading, _cameraHeading),
            child: Center(
              child: Text('${_heading.toStringAsFixed(1)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w400,
                  )),
            ));
      },
    );
  }
}

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

    double radius = math.min(size.width / 2.2, size.height / 2.2);
    Offset center = Offset(size.width / 2, size.height / 2);
    Offset start = Offset.lerp(Offset(center.dx, radius), center, .5);
    Offset end = Offset.lerp(Offset(center.dx, radius), center, 0.1);

    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    canvas.translate(-center.dx, -center.dy);
    canvas.drawLine(start, end, needle);
    canvas.drawCircle(center, radius, circle);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
