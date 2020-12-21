import 'package:flutter/material.dart';

import './pin/pin-database.dart';
import './pin/pin-model.dart';
import './pins-list.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Your pins'),
      ),
      body: FutureBuilder<List<Pin>>(
          future: getPins(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return pinListView(snapshot.data);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-pin/compass');
        },
        tooltip: 'Add pin',
        child: Icon(Icons.pin_drop),
      ),
    );
  }
}
