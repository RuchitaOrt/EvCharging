import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:ev_charging_app/Services/hub_repository.dart';
import 'package:ev_charging_app/Utils/LocationConvert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Screens/Controller/map_overview_controller.dart';
import '../Utils/directions_service.dart';
import '../Utils/iconresizer.dart';
import '../model/ChargingcomprehensiveHubResponse.dart';

class MapOverViewProvider extends ChangeNotifier {
  final HubRepository _repo = HubRepository();
  final DirectionsService _directionsService = DirectionsService();

  final OverViewMapController mapController;
  MapOverViewProvider(this.mapController);

  Set<Marker> markers = {};
  Set<Polyline> polyLines = {};

  BitmapDescriptor? carIcon;
  BitmapDescriptor? destinationIcon;

  String? distanceText;
  String? durationText;

  bool isDriving = false;
  bool isArrived = false;

  StreamSubscription<Position>? _driveStream;

  LatLng? destinationLatLng;
  LatLng? lastPosition;

  static const String carMarkerId = "CAR";
  static const String destinationMarkerId = "DEST";

  // ================= ICONS =================
  Future<void> loadIcons() async {
    carIcon = await getResizedMarker('assets/images/currentMarker.png', width: 80);
    destinationIcon =
    await getResizedMarker('assets/images/targetMarker.png', width: 100);
  }

  // ================= DRAW ROUTE =================
  Future<void> drawRouteWithInfo(ChargingHub hub) async {
    await loadIcons();

    destinationLatLng = LocationConvert.getLatLngFromHub(hub);
    if (destinationLatLng == null) return;

    final pos = await mapController.getCurrentPosition();
    final origin = LatLng(pos.latitude, pos.longitude);

    final routeInfo = await _directionsService.getRouteInfo(
      origin: origin,
      destination: destinationLatLng!,
    );

    distanceText = routeInfo.distanceText;
    durationText = routeInfo.durationText;

    polyLines = {
      Polyline(
        polylineId: const PolylineId("route"),
        points: routeInfo.points,
        color: Colors.green,
        width: 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      ),
    };

    markers = {
      _buildMarker(carMarkerId, origin, carIcon!, 0),
      _buildMarker(destinationMarkerId, destinationLatLng!, destinationIcon!, 0),
    };
    notifyListeners();
  }

  // ================= START DRIVING =================
  void startDriving() {
    if (isDriving) return;

    isDriving = true;
    isArrived = false;

    _driveStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    ).listen((Position pos) async {
      final current = LatLng(pos.latitude, pos.longitude);

      double bearing = 0;
      if (lastPosition != null) {
        bearing = _getBearing(lastPosition!, current);
      }
      lastPosition = current;

      // Update car marker
      markers.removeWhere((m) => m.markerId.value == carMarkerId);
      markers.add(_buildMarker(carMarkerId, current, carIcon!, bearing));
      mapController.zoom(current,bearing,pos.speed);
      // Check arrival
      if (_isArrived(current, destinationLatLng!)) {
        stopDriving();
        isArrived = true;
      } else {
        // Recalculate route every update
        await _recalculateRoute(current);
      }

      notifyListeners();
    });
  }

  // ================= STOP DRIVING =================
  void stopDriving() {
    _driveStream?.cancel();
    _driveStream = null;
    isDriving = false;
    notifyListeners();
  }

  // ================= RECALCULATE ROUTE =================
  Future<void> _recalculateRoute(LatLng current) async {
    if (destinationLatLng == null) return;

    final routeInfo = await _directionsService.getRouteInfo(
      origin: current,
      destination: destinationLatLng!,
    );

    distanceText = routeInfo.distanceText;
    durationText = routeInfo.durationText;

    polyLines = {
      Polyline(
        polylineId: const PolylineId("route"),
        points: routeInfo.points,
        color: Colors.green,
        width: 4,
      ),
    };
  }

  // ================= ARRIVAL CHECK =================
  bool _isArrived(LatLng current, LatLng destination) {
    final distance = Geolocator.distanceBetween(
      current.latitude,
      current.longitude,
      destination.latitude,
      destination.longitude,
    );
    return distance < 30; // meters
  }

  // ================= MARKER =================
  Marker _buildMarker(String id, LatLng pos, BitmapDescriptor icon, double rotation) {
    return Marker(
      markerId: MarkerId(id),
      position: pos,
      icon: icon,
      rotation: rotation,
      anchor: const Offset(0.5, 0.5),
    );
  }

  // ================= BEARING =================
  double _getBearing(LatLng start, LatLng end) {
    final lat1 = start.latitude * pi / 180;
    final lon1 = start.longitude * pi / 180;
    final lat2 = end.latitude * pi / 180;
    final lon2 = end.longitude * pi / 180;

    final dLon = lon2 - lon1;

    final y = sin(dLon) * cos(lat2);
    final x =
        cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);

    return (atan2(y, x) * 180 / pi + 360) % 360;
  }

  @override
  void dispose() {
    _driveStream?.cancel();
    super.dispose();
  }
}
