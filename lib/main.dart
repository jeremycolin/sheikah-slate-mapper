import 'package:flutter/material.dart';

import 'compass.dart';
import 'home.dart';
import 'style/color.dart';

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
        '/add-pin': (context) => CompassView(),
      },
    );
  }
}
