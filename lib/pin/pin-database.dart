import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../pin/pin-model.dart';

Future<Database> getDatabase() async {
  WidgetsFlutterBinding.ensureInitialized();
  return openDatabase(
    join(await getDatabasesPath(), 'pin_database.db'),
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute('''CREATE TABLE pins(
        description TEXT,
        color TEXT,
        latitude REAL,
        longitude REAL,
        altitude REAL,
        created TEXT PRIMARY KEY
        )''');
    },
    version: 1,
  );
}

Future<void> insertPin(Pin pin) async {
  final Database db = await getDatabase();
  await db.insert('pins', pin.toMap());
  // db.close();
}

// A method that retrieves all the dogs from the dogs table.
Future<List<Pin>> getPins() async {
  final Database db = await getDatabase();

  // debug cleanups
  // db.delete('pins');

  final List<Map<String, dynamic>> maps = await db.query('pins');

  // Convert the List<Map<String, dynamic> into a List<Pin>
  return List.generate(maps.length, (i) {
    return Pin(
        description: maps[i]['description'],
        color: Color(int.parse(maps[i]['color'], radix: 16)),
        latitude: maps[i]['latitude'],
        longitude: maps[i]['longitude'],
        altitude: maps[i]['altitude'],
        created: DateTime.parse(maps[i]['created']));
  });
}
