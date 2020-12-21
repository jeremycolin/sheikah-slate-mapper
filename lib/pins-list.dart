import 'package:flutter/material.dart';

import 'pin.dart';

final List<Pin> pins = [
  Pin(46.81111272089395, 1.6863424794561743, Colors.purple, "Chateauroux"),
  Pin(48.86012935259547, 2.3415595797790036, Colors.blueAccent, "Paris"),
  Pin(45.75341428029482, 4.842855723029029, Colors.green, "Lyon")
];

final pinListView = ListView.builder(
    itemCount: pins.length,
    itemBuilder: (BuildContext context, int index) {
      final pin = pins[index];
      return Container(
        height: 50,
        color: pins[index].color,
        child: Center(
            child: Text('${pin.name} (${pin.latitude.toStringAsFixed(4)},'
                ' ${pin.longitude.toStringAsFixed(4)})')),
      );
    });
