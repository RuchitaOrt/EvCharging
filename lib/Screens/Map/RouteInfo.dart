import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteInfo {
  final List<LatLng> points;
  final String distanceText; // "4.8 km"
  final String durationText; // "12 mins"

  RouteInfo({
    required this.points,
    required this.distanceText,
    required this.durationText,
  });
}
