import 'package:flutter/material.dart';

import 'pins-list.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Your pins'),
      ),
      body: pinListView,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add pin screen using named route
          Navigator.pushNamed(context, '/add-pin');
        },
        tooltip: 'Add pin',
        child: Icon(Icons.pin_drop),
      ),
    );
  }
}
