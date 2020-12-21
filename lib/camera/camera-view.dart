import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'package:flutter_compass/flutter_compass.dart';

import '../create-pin/create-pin-view.dart';
import '../style/global.dart';
import './camera-preview-manager.dart';
import './camera-painter.dart';
import './sensors.dart';

class CameraViewArguments {
  final double heading;
  CameraViewArguments({this.heading});
}

class CameraView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CameraViewArguments arguments = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        backgroundColor: Colors.black,
        extendBody: true,
        body: Container(
            margin: containerViewMargin,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: Text('Zoom to desired pin surface',
                      textAlign: TextAlign.center, style: instructionsTextStyle),
                ),
                Expanded(
                    child: Stack(children: [
                  CameraPreviewManager(),
                  CustomPaint(foregroundPainter: CameraPainter(), child: Center())
                ])),
                InkWell(
                    onTap: () async {
                      final accEvent = await accelerometerEvents.first;
                      final pitch = getPitch(x: accEvent.x, y: accEvent.y, z: accEvent.z);
                      final compassEvent = await FlutterCompass.events.first;

                      Navigator.pushNamed(context, '/add-pin/create',
                          arguments: CreatePinViewwArguments(
                              heading: arguments.heading,
                              cameraHeading: compassEvent.headingForCameraMode,
                              pitch: pitch));
                    },
                    child: Container(
                        height: 50,
                        child: Center(
                            child: Text(
                          'Next',
                          style: instructionsTextStyle,
                        ))))
              ],
            )));
  }
}
