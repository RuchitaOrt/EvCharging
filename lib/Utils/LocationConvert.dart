import 'package:HyCharge/model/UnifiedComprehensiveResponse.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/ChargingcomprehensiveHubResponse.dart';

// import '../model/ChargingHubResponse.dart';

class LocationConvert{
  static LatLng? getLatLngFromUnifiedHub(Location hub) {
    if (hub.latitude == null ||
        hub.longitude == null ||
        hub.latitude!.isEmpty ||
        hub.longitude!.isEmpty) {
      return null;
    }
    return convertToLatLng(hub.latitude!, hub.longitude!);
  }
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
//  static double parseCoordinate(String value) {
//     // Remove degree symbol and spaces
//     value = value.replaceAll("°", "").trim();

//     final parts = value.split(" ");
//     double coordinate = double.parse(parts[0]);
//     String direction = parts[1];

//     if (direction == "S" || direction == "W") {
//       coordinate = -coordinate;
//     }

//     return coordinate;
//   }
static double parseCoordinate(String value) {
  value = value.trim();

  // ✅ Case 1: Already a plain decimal number
  final direct = double.tryParse(value);
  if (direct != null) {
    return direct;
  }

  // ✅ Case 2: Has direction (N, S, E, W) like "19.25 N"
  value = value.replaceAll("°", "").trim();
  final parts = value.split(RegExp(r'\s+'));

  if (parts.length != 2) {
    throw FormatException("Invalid coordinate format: $value");
  }

  double coordinate = double.parse(parts[0]);
  String direction = parts[1].toUpperCase();

  if (direction == "S" || direction == "W") {
    coordinate = -coordinate;
  }

  return coordinate;
}

}
String capitalizeWords(String text) {
  return text
      .split(' ')
      .map((word) =>
          word.isNotEmpty ? word[0].toUpperCase() + word.substring(1).toLowerCase() : '')
      .join(' ');
}