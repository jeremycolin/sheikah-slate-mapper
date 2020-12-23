import 'package:flutter/material.dart';

import '../style/global.dart';
import 'camera-preview-manager.dart';
import 'camera-painter.dart';

class CameraView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                    onTap: () {
                      Navigator.pushNamed(context, '/add-pin/create');
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
