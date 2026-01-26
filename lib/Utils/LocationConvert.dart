import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/ChargingHubResponse.dart';

class LocationConvert{
 static LatLng? getLatLngFromHub(ChargingHub hub) {
    if (hub.latitude == null ||
        hub.longitude == null ||
        hub.latitude!.isEmpty ||
        hub.longitude!.isEmpty) {
      return null;
    }
    return convertToLatLng(hub.latitude!, hub.longitude!);
  }
  static LatLng convertToLatLng(String lat, String lng) {
    final double latitude = parseCoordinate(lat);
    final double longitude = parseCoordinate(lng);

    return LatLng(latitude, longitude);
  }
 static double parseCoordinate(String value) {
    // Remove degree symbol and spaces
    value = value.replaceAll("°", "").trim();

    final parts = value.split(" ");
    double coordinate = double.parse(parts[0]);
    String direction = parts[1];

    if (direction == "S" || direction == "W") {
      coordinate = -coordinate;
    }

    return coordinate;
  }
}