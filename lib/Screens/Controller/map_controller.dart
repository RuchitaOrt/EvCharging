import 'dart:async';

import 'package:ev_charging_app/main.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../Utils/location_permission_manager.dart';

class MapController {
  late GoogleMapController googleMapController;
  final LatLng center = const LatLng(19.0760, 72.8777);
  LatLng? currentLocation;
  StreamSubscription<Position>? _positionStream;


  Future<void> onMapCreated(GoogleMapController controller) async {

    // String style = await DefaultAssetBundle.of(routeGlobalKey.currentContext!)
    //     .loadString('assets/map_styles/dark_map.json');
    // controller.setMapStyle(style);
    googleMapController = controller;
    // Move camera to current location
    await moveToCurrentLocation();

  }
   /// One-time camera move
  Future<void> moveToCurrentLocation() async {
    final Position position = await _getPosition();
    print('Current Location: ${position.latitude}, ${position.longitude}');
    zoomTo(LatLng(position.latitude, position.longitude));
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

   void startLocationTracking() {
    _positionStream?.cancel(); // safety
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // meters (important)
      ),
    ).listen((Position position) {
      zoomTo(LatLng(position.latitude, position.longitude));
    });
  }
   void stopLocationTracking() {
    _positionStream?.cancel();
    _positionStream = null;
  }
   Future<Position> _getPosition() async {
    final bool ready = await LocationPermissionManager.instance.ensureLocationReady(routeGlobalKey.currentContext!);
    if (!ready) {      throw Exception('Location not ready');

    }
    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
  Future<Position> getCurrentPosition() async {
    final bool ready = await LocationPermissionManager.instance.ensureLocationReady(routeGlobalKey.currentContext!);
    if (!ready) {      throw Exception('Location not ready');
    }
    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
