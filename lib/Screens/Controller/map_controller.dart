import 'package:ev_charging_app/main.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';

class MapController {
  late GoogleMapController googleMapController;

  final LatLng center = const LatLng(19.0760, 72.8777);

  Future<void> onMapCreated(GoogleMapController controller) async {

    String style = await DefaultAssetBundle.of(routeGlobalKey.currentContext!)
        .loadString('assets/map_styles/dark_map.json');

    controller.setMapStyle(style);
    googleMapController = controller;

  }

  void zoomTo(LatLng position) {
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: position,
          zoom: 15, // adjust if needed
        ),
      ),
    );
  }
}
