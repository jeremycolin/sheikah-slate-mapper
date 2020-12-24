import 'dart:ui';

class Pin {
  final String description;
  final Color color;
  final double latitude;
  final double longitude;
  final double altitude;
  final DateTime created;

  Pin(
      {this.description,
      this.color,
      this.latitude,
      this.longitude,
      this.altitude = 0,
      this.created});

  // Convert Pin with keys matching databse columns
  toMap() {
    return {
      'description': description,
      'color': color.value.toRadixString(16),
      'latitude': latitude,
      'longitude': longitude,
      'altitude': altitude,
      'created': created.toIso8601String(),
    };
  }
}
