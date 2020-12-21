import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';

import './pin/pin-model.dart';

Widget pinListView(List<Pin> pins) => ListView.builder(
    itemCount: pins.length,
    itemBuilder: (BuildContext context, int index) {
      final pin = pins[index];

      return InkWell(
          onTap: () {
            MapsLauncher.launchCoordinates(pin.latitude, pin.longitude);
          },
          child: Container(
            height: 50,
            color: pin.color,
            child: Center(
                child: Text('${pin.description} (${pin.latitude.toStringAsFixed(4)},'
                    ' ${pin.longitude.toStringAsFixed(4)})')),
          ));
    });
