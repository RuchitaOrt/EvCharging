import 'dart:convert' as ui;
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui hide Codec;

import 'package:ev_charging_app/Services/hub_repository.dart';
import 'package:ev_charging_app/model/ChargingHubResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Services/hub_repository.dart';
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

  final List<dynamic> hubs = []; // Use dynamic or ChargingHub type
  final Set<Marker> markers = {};
  Set<Polyline> polyLines = {};

  Future<void> loadHubs(
      BuildContext context, {
        bool reset = false,
        bool loadMore = false,
      }) async {
    if (loading) return;

    // If loading more but no more data, return
    if (loadMore && !hasMore) return;

    if (reset) {
      page = 1;
      hubs.clear();
      markers.clear();
      hasMore = true;
    } else if (loadMore) {
      page++;
    }

    loading = true;
    notifyListeners();

    try {
      final ChargingHubResponse res = await _repo.fetchHubs(
        context,
        page: page,
        size: 10,
      );

      print('API Response: ${res.hubs?.length} hubs');

      final List<dynamic> data = res.hubs ?? [];

      if (data.isEmpty) {
        hasMore = false;
      } else {
        hubs.addAll(data);
        //_createMarkers(data);

        // Check if we got less items than requested (means no more data)
        if (data.length < 10) {
          hasMore = false;
        }
      }
    } catch (e) {
      debugPrint('Error loading hubs: $e');
      // If loading more fails, decrement page
      if (loadMore) page--;
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

  Future<void> _createMarkers(List<ChargingHub> hubList,BuildContext context) async {
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
          onTap: (){
            debugPrint('Marker tapped:');
            drawRoute(LatLng(19.262147, 72.983966), LatLng(19.193039, 72.953840));
          }
      ),
    );

    /*for (final hub in hubList) {
      final double lat = hub.latitude ?? 0.0;
      final double lng = hub.longitude ?? 0.0;
      markers.add(
        Marker(
          markerId: MarkerId(hub.recId ?? ''),
          position: LatLng(lat, lng),
          icon: chargingIcon,
          infoWindow: InfoWindow(
            title: hub.chargingHubName ?? '',
              snippet: 'Tap for details',
            onTap: (){
              debugPrint('Marker tapped: ${hub.additionalInfo1}');
            }
          ),
        ),
      );
    }*/
  }
  Future<void> drawRoute(
      LatLng start,
      LatLng end,
      ) async {
    final routePoints = await _directionsService.getRoute(
      origin: start,
      destination: end,
    );
    polyLines = {
      Polyline(
        polylineId: const PolylineId('route'),
        points: routePoints,
        color: Colors.green,
        width: 6,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        jointType: JointType.round,
      ),
    };
    notifyListeners();
  }

}