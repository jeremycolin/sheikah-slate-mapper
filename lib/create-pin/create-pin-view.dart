import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:geolocator/geolocator.dart';

import '../pin/pin-database.dart';
import '../pin/pin-model.dart';
import '../style/color.dart';
import './color-picker-manager.dart';

class CreatePinViewwArguments {
  final double heading;
  final double cameraHeading;
  final double pitch;
  CreatePinViewwArguments({this.heading, this.cameraHeading, this.pitch});
}

class CreatePinView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        body: Container(
            margin: EdgeInsets.only(top: 80, bottom: 40, left: 40, right: 40),
            child: CreatePinForm()));
  }
}

class CreatePinForm extends StatefulWidget {
  @override
  CreatePinFormState createState() {
    return CreatePinFormState();
  }
}

class CreatePinFormState extends State<CreatePinForm> {
  final _formKey = GlobalKey<FormState>();
  String _description;
  Color _color;
  Position _position;

  @override
  void initState() {
    // ignore: missing_required_param
    final availableColors = BlockPicker().availableColors;
    _color = availableColors[math.Random().nextInt(availableColors.length)];
    setCurrentPosition();
    super.initState();
  }

  void Function(Color) _onColorPickerChange(BuildContext context) => (value) {
        setState(() {
          _color = value;
        });
        Navigator.of(context).pop();
      };

  void setCurrentPosition() async {
    final position = await Geolocator.getCurrentPosition();
    setState(() => _position = position);
  }

  @override
  Widget build(BuildContext context) {
    final CreatePinViewwArguments arguments = ModalRoute.of(context).settings.arguments;
    return Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Pin description'),
            validator: (value) {
              if (value.isEmpty) {
                return 'Enter Pin description';
              }
              return null;
            },
            onSaved: (value) {
              _description = value;
            },
          ),
          Container(
              margin: EdgeInsets.only(top: 20, bottom: 20),
              child: RaisedButton(
                  elevation: 5,
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ColorPickerManager(_onColorPickerChange(context),
                              initialValue: _color);
                        });
                  },
                  child: Text('Select Pin color'),
                  color: _color,
                  textColor: useWhiteForeground(_color) ? Colors.white : Colors.black)),
          RaisedButton(
              elevation: 5,
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();

                  final Pin pin = Pin(
                      latitude: _position.latitude,
                      longitude: _position.longitude,
                      altitude: _position.altitude,
                      color: _color,
                      description: _description,
                      created: new DateTime.now());
                  insertPin(pin);
                  Navigator.pushNamed(context, '/');
                }
              },
              color: primaryColor,
              child: Text('Create Pin'),
              textColor: Colors.white),
          Container(
            margin: EdgeInsets.only(top: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Debug values:'),
                Text('heading: ${arguments.heading.toStringAsFixed(2)} degrees'),
                Text('camera heading: ${arguments.cameraHeading.toStringAsFixed(2)} degrees'),
                Text('pitch ${(arguments.pitch * 360 / (2 * math.pi)).toStringAsFixed(2)} degrees'),
                _position != null
                    ? Text(
                        'altitude: ${(_position.altitude)}\nlatitude: ${(_position.latitude.toStringAsFixed(2))}\nlongitude: ${_position.longitude.toStringAsFixed(2)}')
                    : Text('position not defined yet')
              ],
            ),
          )
        ]));
  }
}
