import 'package:ev_charging_app/Utils/LocationConvert.dart';
import 'package:ev_charging_app/Utils/googleMap.dart';
import 'package:ev_charging_app/model/ChargingcomprehensiveHubResponse.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../Controller/map_controller.dart';

class MiniMapWidget extends StatefulWidget {
  final ChargingHub hub;
  final LatLng currentLocation;
  final LatLng hubLocation;

  const MiniMapWidget({
    super.key,
    required this.currentLocation,
    required this.hubLocation, required this.hub,
  });

  @override
  State<MiniMapWidget> createState() => _MiniMapWidgetState();
}

class _MiniMapWidgetState extends State<MiniMapWidget> {
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  String? mapStyle;
  double distanceInKm = 0;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    await _loadMapStyle();
    _setupRoute();
  }

  Future<void> _loadMapStyle() async {
    mapStyle = await DefaultAssetBundle.of(context)
        .loadString('assets/map_styles/dark_map.json');
  }

  void _setupRoute() {
    markers = {
      Marker(
        markerId: const MarkerId("current"),
        position: widget.currentLocation,
        infoWindow:  InfoWindow(title: "${widget.currentLocation}"),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed),
      ),
      Marker(
        markerId: const MarkerId("hub"),
        position: widget.hubLocation,
        infoWindow:  InfoWindow(title:widget.hub.chargingHubName),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueOrange),
      ),
    };

    polylines = {
      Polyline(
        polylineId: const PolylineId("route"),
        points: [widget.currentLocation, widget.hubLocation],
        color: Colors.green,
        width: 5,
      ),
    };

    distanceInKm = Geolocator.distanceBetween(
          widget.currentLocation.latitude,
          widget.currentLocation.longitude,
          widget.hubLocation.latitude,
          widget.hubLocation.longitude,
        ) /
        1000;

    setState(() {});
  }

  void _fitMarkers() {
    if (mapController == null) return;

    final bounds = LatLngBounds(
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

    mapController!
        .animateCamera(CameraUpdate.newLatLngBounds(bounds, 60));
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
          onMapCreated: (controller) {
            mapController = controller;
            if (mapStyle != null) {
              mapController!.setMapStyle(mapStyle);
            }
            Future.delayed(
              const Duration(milliseconds: 300),
              _fitMarkers,
            );
          },
          markers: markers,
          polylines: polylines,
          gestureRecognizers: {
    Factory<OneSequenceGestureRecognizer>(
      () => EagerGestureRecognizer(),
    ),
  },
          zoomControlsEnabled: false,
          compassEnabled: false,
          mapToolbarEnabled: false,
          buildingsEnabled: false,
          trafficEnabled: false,
          zoomGesturesEnabled: true,
          scrollGesturesEnabled: true,
          rotateGesturesEnabled: true,
        ),

        /// 🔥 Direction button (right side)
        Positioned(
          right: 12,
          bottom: 12,
          child: FloatingActionButton(
            mini: true,
            backgroundColor: Colors.white,
            onPressed: () {
              openGoogleMaps(
                latitude: widget.hubLocation.latitude,
                longitude: widget.hubLocation.longitude,
              );
            },
            child: const Icon(
              Icons.directions,
              color: Colors.black,
            ),
          ),
        ),
      ],
    ),
  ),
),


        const SizedBox(height: 8),
        //  Positioned(
        //   right: 12,
        //   bottom: 12,
        //   child: FloatingActionButton(
        //     mini: true,
        //     backgroundColor: Colors.white,
        //     onPressed: () {
        //       openGoogleMaps(
        //         latitude: widget.hubLocation.latitude,
        //         longitude: widget.hubLocation.longitude,
        //       );
        //     },
        //     child: const Icon(
        //       Icons.directions,
        //       color: Colors.black,
        //     ),
        //   ),
        // ),
        // GestureDetector(
        //   onTap: ()
        //   {
        //         LatLng? location = LocationConvert.getLatLngFromHub(widget.hub);
        //                       print(location!.latitude);
        //                       print(location!.longitude);
        //                       openGoogleMaps(
        //                     latitude: location.latitude,
        //                     longitude: location.longitude,

        //                   );
        //   },
        //   child: Icon(Icons.navigation_rounded))
        // Text(
        //   "Distance: ${distanceInKm.toStringAsFixed(2)} km",
        //   style: const TextStyle(color: Colors.white, fontSize: 14),
        // ),
      ],
    );
  }


}
