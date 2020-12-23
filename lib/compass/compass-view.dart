import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_compass/flutter_compass.dart';

import 'compass-painter.dart';
import '../style/global.dart';

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
          return Scaffold(
              backgroundColor: Colors.black,
              body: Container(
                  margin: containerViewMargin,
                  child: Column(children: [
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                          'Point to your desired pin location with your phone horizontally flat',
                          textAlign: TextAlign.center,
                          style: instructionsTextStyle),
                    ),
                    Expanded(child: _buildCompass()),
                    InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/add-pin/camera');
                        },
                        child: Container(
                            height: 50,
                            child: Center(
                                child: Text(
                              'Next',
                              style: instructionsTextStyle,
                            ))))
                  ])));
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
        double _cameraHeading = snapshot.data.headingForCameraMode; // might be useful later

        // if direction is null, then device does not support this sensor
        if (_heading == null) {
          return Center(
            child: Text("Unable to read from Device sensors"),
          );
        }

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
