import 'dart:ui';
import 'package:ev_charging_app/Services/hub_repository.dart';
import 'package:ev_charging_app/model/ChargingHubResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Screens/Controller/map_controller.dart';
import '../Utils/directions_service.dart';
import '../Utils/iconresizer.dart';

class HubProvider extends ChangeNotifier {
  final HubRepository _repo = HubRepository();
  final DirectionsService _directionsService = DirectionsService();
  bool hasZoomedToFirst = false;

  LatLng? get firstMarkerPosition {
    if (markers.isEmpty) return null;
    return markers.first.position;
  }

  bool loading = false;
  bool hasMore = true;
  int page = 1;

  final List hubs = [];
  late Set<Marker> markers = {};
  Set<Polyline> polyLines = {};

  bool _isRouteLoading = false;

  bool get isRouteLoading => _isRouteLoading;
  String? selectedMarkerId;
  String? currentMarkerId;
  BitmapDescriptor? normalMarkerIcon;
  BitmapDescriptor? activeMarkerIcon;
  BitmapDescriptor? currentMarkerIcon;

  // ✅ Load icons once
  Future<void> loadIcons() async {
    normalMarkerIcon = await getResizedMarker(
      'assets/images/normalMarker.png',
      width: 32,
    );
    activeMarkerIcon = await getResizedMarker(
      'assets/images/targetMarker.png',
      width: 125,
    );
    currentMarkerIcon = await getResizedMarker(
      'assets/images/currentMarker.png',
      width: 125,
    );
  }

  Future<void> loadHubs(
    BuildContext context, {
    bool reset = false,
  }) async {
    if (loading || !hasMore) return;
    if (reset) {
      page = 1;
      hubs.clear();
      markers.clear();
      hasMore = true;
      // polyLines.clear(); remove routes
    }
    loading = true;
    notifyListeners();
    try {
      await loadIcons();
      final ChargingHubResponse res = await _repo.fetchHubs(context);
      print(res.hubs);
      final List<ChargingHub> data = res.hubs ?? [];
      if (data.isEmpty) {
        hasMore = false;
      } else {
        hubs.addAll(data);
        _createMarkers(context);
        page++;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    loading = false;
    notifyListeners();
  }

  Future<void> _createMarkersoldone(List<ChargingHub> hubList) async {
    for (final hub in hubList) {
      final double lat = hub.latitude ?? 0.0;
      final double lng = hub.longitude ?? 0.0;
      markers.add(
        Marker(
          markerId: MarkerId(hub.recId ?? ''),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
              title: hub.chargingHubName ?? '',
              snippet: 'Tap for details',
              onTap: () {
                debugPrint('Marker tapped: ${hub.additionalInfo1}');
              }),
        ),
      );
    }
  }

  Future<void> _createMarkers(BuildContext context) async {
    markers.clear();

    markers.add(
      _buildMarker(
        id: "243243",
        position: const LatLng(19.196262132107243, 72.96296701103056),
        title: "EV Dock Charging Station",
        // icon: targetMarkerIcon!,
      ),
    );

    markers.add(
      _buildMarker(
        id: "243244",
        position: const LatLng(19.19842263661491, 72.95372020182485),
        title: "GLIDA Charging Station",
      ),
    );

    markers.add(
      _buildMarker(
        id: "243245",
        position: const LatLng(19.193039, 72.953840),
        title: "Kazam Charging Station",
      ),
    );

    markers.add(
      _buildMarker(
        id: "243246",
        position: const LatLng(19.262147, 72.983966),
        title: "Vishu Electric Vehicle Charging Station",
        /*onTap: () async {
          final position = await MapController().getCurrentPosition();
          clearRoute();
          drawRoute(
            LatLng(position.latitude, position.longitude),
            const LatLng(19.193039, 72.953840),
          );
        },*/
      ),
    );
  }

  Marker _buildMarker({
    required String id,
    required LatLng position,
    required String title,
    BitmapDescriptor? icon,
    VoidCallback? onTap,
  }) {
    /* final String id = m.markerId.value;
    BitmapDescriptor iconToUse;
    if (id == "12345678") {
      //current location marker
      iconToUse = currentMarkerIcon!;
    } else if (id == selectedMarkerId) {
      //active selected marker
      iconToUse = activeMarkerIcon!;
    } else {
      //normal marker
      iconToUse = normalMarkerIcon!;
    }*/
    return Marker(
      markerId: MarkerId(id),
      position: position,
      icon: selectedMarkerId == id
          ? activeMarkerIcon!
          : '12345678' == id
              ? currentMarkerIcon!
              : (icon ?? normalMarkerIcon!),
      anchor: const Offset(0.5, 0.5),
      infoWindow: InfoWindow(title: title, snippet: "Tap for details"),
      onTap: () async {
        clearRoute();
        _isRouteLoading = true;
        selectMarker(id);
        //
        final currentPosition = await MapController().getCurrentPosition();
        // clearRoute();
        drawRoute(
          //current position
          LatLng(currentPosition.latitude, currentPosition.longitude),
          // target position
          LatLng(position.latitude, position.longitude),
        );
        _isRouteLoading = false;
        //
        if (onTap != null) onTap();
      },
    );
  }

  void selectMarker(String markerId) {
    selectedMarkerId = markerId;
    _createMarkersInternal();
    notifyListeners();
  }

  void _createMarkersInternal() {
    // rebuild markers with active icon
    markers = markers.map((m) {
      // final isSelected = m.markerId.value == selectedMarkerId;
      final String id = m.markerId.value;
      BitmapDescriptor iconToUse;
      if (id == "12345678") {
        //current location marker
        iconToUse = currentMarkerIcon!;
      } else if (id == selectedMarkerId) {
        //active selected marker
        iconToUse = activeMarkerIcon!;
      } else {
        //normal marker
        iconToUse = normalMarkerIcon!;
      }
      return m.copyWith(
        // iconParam: isSelected ? activeMarkerIcon : normalMarkerIcon,
        iconParam: iconToUse,
      );
    }).toSet();
  }

/*  Future<void> _createMarkers(List<ChargingHub> hubList,BuildContext context) async {
    BitmapDescriptor  normalMarkerIcon = await getResizedMarker(
      'assets/images/normalMarker.png',
      width: 32,
    );
    BitmapDescriptor  targetMarkerIcon = await getResizedMarker(
      'assets/images/targetMarker.png',
      width: 125,
    );

    markers.add(
      Marker(
        markerId: MarkerId('243243' ?? ''),
        position: LatLng(19.196262132107243, 72.96296701103056),
        icon: targetMarkerIcon,
        anchor: const Offset(0.5, 0.5),
        infoWindow: InfoWindow(
            title:  'EV Dock Charging Station',
            snippet: 'Tap for details',
            onTap: () {
              debugPrint('Marker tapped:');
            }),
      ),
    );
    markers.add(
      Marker(
        markerId: MarkerId('243244' ?? ''),
        position: LatLng(19.19842263661491, 72.95372020182485),
        icon: normalMarkerIcon,
        infoWindow: InfoWindow(
            title:  'GLIDA Charging Station',
            snippet: 'Tap for details',
            onTap: () {
              debugPrint('Marker tapped:');
            }),
      ),
    );
    markers.add(
      Marker(
        markerId: MarkerId('243245' ?? ''),
        position: LatLng(19.193039, 72.953840),
        icon: normalMarkerIcon,
        infoWindow: InfoWindow(
            title:  'Kazam Charging Station',
            snippet: 'Tap for details',
            onTap: () {
              debugPrint('Marker tapped:');
            }),
      ),
    );
    markers.add(
      Marker(
        markerId: MarkerId('243246' ?? ''),
        position: LatLng(19.262147, 72.983966),
        icon: normalMarkerIcon,
        infoWindow: InfoWindow(
            title:  'Vishu Electric Vehicle Charging Station',
            snippet: 'Tap for details',
        ),
        onTap: () async {
          debugPrint('Marker tapped:');
          final Position position = await MapController().getCurrentPosition();
          // drawRoute(LatLng(19.262147, 72.983966), LatLng(19.193039, 72.953840));
          drawRoute(LatLng(position.latitude, position.longitude), LatLng(19.193039, 72.953840));
        }
      ),
    );
  }*/

  Future<void> drawRoute(
    LatLng start,
    LatLng end,
  ) async {
    // BitmapDescriptor  normalMarkerIcon = await getResizedMarker(
    //   'assets/images/currentMarker.png',
    //   width: 125,
    // );
    final Position position = await MapController().getCurrentPosition();
    markers.add(
      _buildMarker(
          id: "12345678",
          position: LatLng(position.latitude, position.longitude),
          title: "Me",
          icon: currentMarkerIcon,
          onTap: () {}
          // onTap: () async {
          //   final position = await MapController().getCurrentPosition();
          //   clearRoute();
          //   drawRoute(
          //     LatLng(position.latitude, position.longitude),
          //     const LatLng(19.193039, 72.953840),
          //   );
          // },
          ),
    );

    final routePoints = await _directionsService.getRoute(
      origin: LatLng(position.latitude, position.longitude),
      destination: end,
    );
    polyLines = {
      Polyline(
          polylineId: const PolylineId('route'),
          points: routePoints,
          color: Colors.green,
          width: 3,
          startCap: Cap.roundCap,
          endCap: Cap.squareCap,
          jointType: JointType.round,
          // patterns: [
          //   PatternItem.dash(10),
          //   PatternItem.gap(10),
          // ],
          geodesic: false,
          consumeTapEvents: false,
          onTap: () {
            //   route tap
          }),
    };
    notifyListeners();
  }

  void clearRoute() {
    polyLines.clear();
    notifyListeners();
  }
}
