import 'package:HyCharge/Utils/LocationConvert.dart';
import 'package:HyCharge/Utils/googleMap.dart';
import 'package:HyCharge/Utils/iconresizer.dart';
import 'package:HyCharge/model/ChargingcomprehensiveHubResponse.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MiniMapWidget extends StatefulWidget {
  final ChargingHub hub;
  final LatLng currentLocation;
  final LatLng hubLocation;
  final List<dynamic> nearbyHubs;

  const MiniMapWidget({
    super.key,
    required this.currentLocation,
    required this.hubLocation,
    required this.hub,
    required this.nearbyHubs,
  });

  @override
  State<MiniMapWidget> createState() => _MiniMapWidgetState();
}

class _MiniMapWidgetState extends State<MiniMapWidget> {
  GoogleMapController? mapController;

  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  Set<Circle> circles = {};

  BitmapDescriptor? hubIcon;
  BitmapDescriptor? nearbyIcon;
  BitmapDescriptor? currentIcon;

  String? mapStyle;

  final String googleApiKey = "AIzaSyDdTSK2ZYsXBQMa-PnFx4BHRfE5RIM0uNs";

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    await _loadMapStyle();
    await _loadIcons();
    _setupMarkers();
    await _getRoute();
  }

  /// Load icons
  Future<void> _loadIcons() async {
    hubIcon = await getResizedMarker(
      'assets/images/targetMarker.png',
      width: 90,
    );

    nearbyIcon = await getResizedMarker(
      'assets/images/normalMarker.png',
      width: 40,
    );

    currentIcon = await getResizedMarker(
      'assets/images/currentMarker.png',
      width: 40,
    );
  }

  /// Setup markers
  void _setupMarkers() {
    Set<Marker> tempMarkers = {};

    /// HUB MARKER
    tempMarkers.add(
      Marker(
        markerId: const MarkerId("hub"),
        position: widget.hubLocation,
        icon: hubIcon!,
        anchor: const Offset(0.5, 1),
        infoWindow: InfoWindow(
          title: widget.hub.chargingHubName ?? "Charging Station",
        ),
      ),
    );

    /// CURRENT LOCATION
    tempMarkers.add(
      Marker(
        markerId: const MarkerId("current"),
        position: widget.currentLocation,
        icon: currentIcon!,
        anchor: const Offset(0.5, 0.5),
      ),
    );

    /// NEARBY HUBS
    for (var station in widget.nearbyHubs) {
      if (station.recId == widget.hub.recId) continue;

      if (station.latitude != null && station.longitude != null) {
        try {
          double lat = LocationConvert.parseCoordinate(station.latitude.toString());
          double lng = LocationConvert.parseCoordinate(station.longitude.toString());

          tempMarkers.add(
            Marker(
              markerId: MarkerId("nearby_${station.recId}"),
              position: LatLng(lat, lng),
              icon: nearbyIcon!,
            ),
          );
        } catch (e) {
          debugPrint("Invalid nearby hub coordinate: ${station.latitude}, ${station.longitude} | $e");
        }
      }
    }

    markers = tempMarkers;

    /// CURRENT LOCATION GLOW
    circles = {
      Circle(
        circleId: const CircleId("current_circle"),
        center: widget.currentLocation,
        radius: 70,
        fillColor: Colors.green.withOpacity(0.25),
        strokeColor: Colors.green,
        strokeWidth: 2,
      )
    };

    setState(() {});
  }

  /// Get road route
  Future<void> _getRoute() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: googleApiKey,
      request: PolylineRequest(
        origin: PointLatLng(
          widget.currentLocation.latitude,
          widget.currentLocation.longitude,
        ),
        destination: PointLatLng(
          widget.hubLocation.latitude,
          widget.hubLocation.longitude,
        ),
        mode: TravelMode.driving,
      ),
    );

    if (result.points.isNotEmpty) {
      List<LatLng> routePoints = result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();

      polylines = {
        Polyline(
          polylineId: const PolylineId("route"),
          points: routePoints,
          color: Colors.green,
          width: 6,
        )
      };

      setState(() {});
    }
  }

  /// Load dark style
  Future<void> _loadMapStyle() async {
    mapStyle = await DefaultAssetBundle.of(context)
        .loadString('assets/map_styles/dark_map.json');
  }

  void _fitMarkers() {
    if (mapController == null) return;

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        widget.currentLocation.latitude < widget.hubLocation.latitude
            ? widget.currentLocation.latitude
            : widget.hubLocation.latitude,
        widget.currentLocation.longitude < widget.hubLocation.longitude
            ? widget.currentLocation.longitude
            : widget.hubLocation.longitude,
      ),
      northeast: LatLng(
        widget.currentLocation.latitude > widget.hubLocation.latitude
            ? widget.currentLocation.latitude
            : widget.hubLocation.latitude,
        widget.currentLocation.longitude > widget.hubLocation.longitude
            ? widget.currentLocation.longitude
            : widget.hubLocation.longitude,
      ),
    );

    mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 80),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: widget.currentLocation,
                    zoom: 14,
                  ),
                  markers: markers,
                  polylines: polylines,
                  circles: circles,
                  onMapCreated: (controller) {
                    mapController = controller;
                    if (mapStyle != null) {
                      controller.setMapStyle(mapStyle);
                    }
                    Future.delayed(
                      const Duration(milliseconds: 500),
                      _fitMarkers,
                    );
                  },
                  gestureRecognizers: {
                    Factory<OneSequenceGestureRecognizer>(
                      () => EagerGestureRecognizer(),
                    ),
                  },
                  zoomControlsEnabled: false,
                  compassEnabled: false,
                  mapToolbarEnabled: false,
                ),
                /// Direction button
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: FloatingActionButton(
                    mini: true,
                    backgroundColor: Colors.white,
                    onPressed: () {
                      openMaps(
                        latitude: widget.hubLocation.latitude,
                        longitude: widget.hubLocation.longitude,
                      );
                    },
                    child: const Icon(
                      Icons.directions,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
