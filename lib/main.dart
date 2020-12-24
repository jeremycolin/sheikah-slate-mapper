import 'package:flutter/material.dart';

import './compass/compass-view.dart';
import './camera/camera-view.dart';
import './create-pin/create-pin-view.dart';
import './home.dart';
import './style/color.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sheikah Slate Pin Mapper',
      theme: ThemeData(
        primarySwatch: primaryMaterialColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeView(),
      routes: {
        '/add-pin/compass': (context) => CompassView(),
        '/add-pin/camera': (context) => CameraView(),
        '/add-pin/create': (context) => CreatePinView()
      },
    );
  }
}
