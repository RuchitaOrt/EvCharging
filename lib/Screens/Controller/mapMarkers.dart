import 'package:google_maps_flutter/google_maps_flutter.dart';

Set<Marker> mapMarkers = {
  Marker(
    markerId: const MarkerId("station1"),
    position: const LatLng(17.4444, 78.3772),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
  ),
  Marker(
    markerId: const MarkerId("station2"),
    position: const LatLng(17.4500, 78.3800),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
  ),
};
