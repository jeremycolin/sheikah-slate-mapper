import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math' as math;
import 'keys.dart';

final mocks = {
  "results": [
    {
      "elevation": 155.7836456298828,
      "location": {"lat": 46.81766222112301, "lng": 1.705509380874771},
      "resolution": 9.543951988220215
    },
    {
      "elevation": 146.569091796875,
      "location": {"lat": 46.81987636693051, "lng": 1.704938845706533},
      "resolution": 9.543951988220215
    },
    {
      "elevation": 141.6023712158203,
      "location": {"lat": 46.82209050990289, "lng": 1.704368263546609},
      "resolution": 9.543951988220215
    }
  ],
  "status": "OK"
};

final R = 6371 * 1000; // earth radius in meters

class Location {
  final double latitude;
  final double longitude;
  final double altitude;
  Location({this.latitude, this.longitude, this.altitude = 0});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
        latitude: json['location']['lat'],
        longitude: json['location']['lng'],
        altitude: json['elevation']);
  }
}

Location getDestination(Location location, double heading, double distance) {
  final bearing = heading * 2 * math.pi / 360;
  final initialLatitude = location.latitude * 2 * math.pi / 360;
  final initialLongitude = location.longitude * 2 * math.pi / 360;

  final finalLatitude = math.asin(math.sin(initialLatitude) * math.cos(distance / R) +
      math.cos(initialLatitude) * math.sin(distance / R) * math.cos(bearing));
  final finalLongitude = initialLongitude +
      math.atan2(math.sin(bearing) * math.sin(distance / R) * math.cos(initialLatitude),
          math.cos(distance / R) - math.sin(initialLatitude) * math.sin(finalLatitude));

  return Location(
      latitude: finalLatitude * 360 / (2 * math.pi),
      longitude: finalLongitude * 360 / (2 * math.pi));
}

double getDistance(Location departure, Location destination) {
  final latitudeDeparture = departure.latitude * 2 * math.pi / 360;
  final latitudeDestination = destination.latitude * 2 * math.pi / 360;
  final latitudeDelta = (destination.latitude - departure.latitude) * 2 * math.pi / 360;
  final longtidueDelta = (destination.longitude - departure.longitude) * 2 * math.pi / 360;

  final a = math.sin(latitudeDelta / 2) * math.sin(latitudeDelta / 2) +
      math.cos(latitudeDeparture) *
          math.cos(latitudeDestination) *
          math.sin(longtidueDelta / 2) *
          math.sin(longtidueDelta / 2);
  final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  return R * c;
}

Future<List<Location>> getElevationsOnPath(
    Location currentLocation, double heading, double distance) async {
  final destination = getDestination(currentLocation, heading, distance);

  final baseUrl = 'https://maps.googleapis.com/maps/api/elevation/json';
  final path =
      '?path=${currentLocation.latitude},${currentLocation.longitude}|${destination.latitude},${destination.longitude}';
  final samples = '&samples=10';
  final url = '$baseUrl$path$samples&key=$googleElevationApiKey';
  final response = await http.get(url);

  // final mockBody = jsonEncode(mocks);
  final List<Location> _locations = new List();
  jsonDecode(response.body)['results'].forEach((result) {
    _locations.add(Location.fromJson(result));
  });
  return _locations;
}
