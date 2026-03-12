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
// import 'package:HyCharge/Utils/googleMap.dart';
// import 'package:HyCharge/Utils/iconresizer.dart';
// import 'package:HyCharge/model/ChargingcomprehensiveHubResponse.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class MiniMapWidget extends StatefulWidget {
//   final ChargingHub hub;
//   final LatLng currentLocation;
//   final LatLng hubLocation;
//   final List<dynamic> nearbyHubs;

//   const MiniMapWidget({
//     super.key,
//     required this.currentLocation,
//     required this.hubLocation,
//     required this.hub,
//     required this.nearbyHubs,
//   });

//   @override
//   State<MiniMapWidget> createState() => _MiniMapWidgetState();
// }

// class _MiniMapWidgetState extends State<MiniMapWidget> {

//   GoogleMapController? mapController;

//   Set<Marker> markers = {};
//   Set<Polyline> polylines = {};
//   Set<Circle> circles = {};

//   BitmapDescriptor? hubIcon;
//   BitmapDescriptor? nearbyIcon;
//   BitmapDescriptor? currentIcon;

//   String? mapStyle;

//   final String googleApiKey = "AIzaSyDdTSK2ZYsXBQMa-PnFx4BHRfE5RIM0uNs";

//   @override
//   void initState() {
//     super.initState();
//     _initData();
//   }

//   Future<void> _initData() async {
//     await _loadMapStyle();
//     await _loadIcons();
//     _setupMarkers();
//     await _getRoute();
//   }

//   /// Load icons
//   Future<void> _loadIcons() async {

//     hubIcon = await getResizedMarker(
//       'assets/images/targetMarker.png',
//       width: 90,
//     );

//     nearbyIcon = await getResizedMarker(
//       'assets/images/normalMarker.png',
//       width: 40,
//     );

//     currentIcon = await getResizedMarker(
//       'assets/images/currentMarker.png',
//       width: 40,
//     );
//   }

//   /// Setup markers
//   void _setupMarkers() {

//     Set<Marker> tempMarkers = {};

//     /// HUB MARKER
//     tempMarkers.add(
//       Marker(
//         markerId: const MarkerId("hub"),
//         position: widget.hubLocation,
//         icon: hubIcon!,
//         anchor: const Offset(0.5, 1),
//         infoWindow: InfoWindow(
//           title: widget.hub.chargingHubName ?? "Charging Station",
//         ),
//       ),
//     );

//     /// CURRENT LOCATION
//     tempMarkers.add(
//       Marker(
//         markerId: const MarkerId("current"),
//         position: widget.currentLocation,
//         icon: currentIcon!,
//         anchor: const Offset(0.5, 0.5),
//       ),
//     );

//     /// NEARBY HUBS
//     for (var station in widget.nearbyHubs) {

//       if (station.recId == widget.hub.recId) continue;

//       if (station.latitude != null && station.longitude != null) {

//         double lat = double.parse(station.latitude.toString());
//         double lng = double.parse(station.longitude.toString());

//         tempMarkers.add(
//           Marker(
//             markerId: MarkerId("nearby_${station.recId}"),
//             position: LatLng(lat, lng),
//             icon: nearbyIcon!,
//           ),
//         );
//       }
//     }

//     markers = tempMarkers;

//     /// CURRENT LOCATION GLOW
//     circles = {
//       Circle(
//         circleId: const CircleId("current_circle"),
//         center: widget.currentLocation,
//         radius: 70,
//         fillColor: Colors.green.withOpacity(0.25),
//         strokeColor: Colors.green,
//         strokeWidth: 2,
//       )
//     };

//     setState(() {});
//   }

//   /// Get road route
//   Future<void> _getRoute() async {

//     PolylinePoints polylinePoints = PolylinePoints();

//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       googleApiKey: googleApiKey,
//       request: PolylineRequest(
//         origin: PointLatLng(
//           widget.currentLocation.latitude,
//           widget.currentLocation.longitude,
//         ),
//         destination: PointLatLng(
//           widget.hubLocation.latitude,
//           widget.hubLocation.longitude,
//         ),
//         mode: TravelMode.driving,
//       ),
//     );

//     if (result.points.isNotEmpty) {

//       List<LatLng> routePoints = result.points
//           .map((point) => LatLng(point.latitude, point.longitude))
//           .toList();

//       polylines = {
//         Polyline(
//           polylineId: const PolylineId("route"),
//           points: routePoints,
//           color: Colors.green,
//           width: 6,
//         )
//       };

//       setState(() {});
//     }
//   }

//   /// Load dark style
//   Future<void> _loadMapStyle() async {

//     mapStyle = await DefaultAssetBundle.of(context)
//         .loadString('assets/map_styles/dark_map.json');
//   }

//   void _fitMarkers() {

//     if (mapController == null) return;

//     LatLngBounds bounds = LatLngBounds(
//       southwest: LatLng(
//         widget.currentLocation.latitude < widget.hubLocation.latitude
//             ? widget.currentLocation.latitude
//             : widget.hubLocation.latitude,
//         widget.currentLocation.longitude < widget.hubLocation.longitude
//             ? widget.currentLocation.longitude
//             : widget.hubLocation.longitude,
//       ),
//       northeast: LatLng(
//         widget.currentLocation.latitude > widget.hubLocation.latitude
//             ? widget.currentLocation.latitude
//             : widget.hubLocation.latitude,
//         widget.currentLocation.longitude > widget.hubLocation.longitude
//             ? widget.currentLocation.longitude
//             : widget.hubLocation.longitude,
//       ),
//     );

//     mapController!.animateCamera(
//       CameraUpdate.newLatLngBounds(bounds, 80),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {

//     return Column(
//       children: [

//         Expanded(
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child: Stack(
//               children: [

//                 GoogleMap(

//                   initialCameraPosition: CameraPosition(
//                     target: widget.currentLocation,
//                     zoom: 14,
//                   ),

//                   markers: markers,
//                   polylines: polylines,
//                   circles: circles,

//                   onMapCreated: (controller) {

//                     mapController = controller;

//                     if (mapStyle != null) {
//                       controller.setMapStyle(mapStyle);
//                     }

//                     Future.delayed(
//                       const Duration(milliseconds: 500),
//                       _fitMarkers,
//                     );
//                   },

//                   gestureRecognizers: {
//                     Factory<OneSequenceGestureRecognizer>(
//                       () => EagerGestureRecognizer(),
//                     ),
//                   },

//                   zoomControlsEnabled: false,
//                   compassEnabled: false,
//                   mapToolbarEnabled: false,
//                 ),

//                 /// Direction button
//                 Positioned(
//                   right: 12,
//                   bottom: 12,
//                   child: FloatingActionButton(
//                     mini: true,
//                     backgroundColor: Colors.white,
//                     onPressed: () {

//                       openMaps(
//                         latitude: widget.hubLocation.latitude,
//                         longitude: widget.hubLocation.longitude,
//                       );
//                     },
//                     child: const Icon(
//                       Icons.directions,
//                       color: Colors.black,
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),

//         const SizedBox(height: 8),
//       ],
//     );
//   }
// }
// import 'package:HyCharge/Utils/googleMap.dart';
// import 'package:HyCharge/Utils/iconresizer.dart';
// import 'package:HyCharge/model/ChargingcomprehensiveHubResponse.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class MiniMapWidget extends StatefulWidget {
//   final ChargingHub hub;
//   final LatLng currentLocation;
//   final LatLng hubLocation;
//   final List<dynamic> nearbyHubs;

//   const MiniMapWidget({
//     super.key,
//     required this.currentLocation,
//     required this.hubLocation,
//     required this.hub,
//     required this.nearbyHubs,
//   });

//   @override
//   State<MiniMapWidget> createState() => _MiniMapWidgetState();
// }

// class _MiniMapWidgetState extends State<MiniMapWidget> {
//   GoogleMapController? mapController;

//   Set<Marker> markers = {};
//   Set<Polyline> polylines = {};
//   Set<Circle> circles = {};

//   String? mapStyle;
// BitmapDescriptor? hubIcon;
// BitmapDescriptor? nearbyIcon;
// BitmapDescriptor? currentIcon;
//   @override
//   void initState() {
//     super.initState();
//     _initData();
//   }
// // Future<void> _loadIcons() async {
// //   hubIcon = await BitmapDescriptor.fromAssetImage(
// //     const ImageConfiguration(size: Size(400, 400)),
// //     "assets/images/currentstation.png",
// //   );

// //   nearbyIcon = await BitmapDescriptor.fromAssetImage(
// //     const ImageConfiguration(size: Size(36, 36)),
// //     "assets/images/nearby.png",
// //   );

// //   currentIcon = await BitmapDescriptor.fromAssetImage(
// //     const ImageConfiguration(size: Size(20, 20)),
// //     "assets/images/current.png",
// //   );
// // }
//  Future<void> _loadIcons() async {
//     hubIcon = await getResizedMarker(
//       'assets/images/targetMarker.png',
//       width: 125,
//     );
//     nearbyIcon = await getResizedMarker(
//       'assets/images/normalMarker.png',
//       width: 40,
//     );
//     currentIcon = await getResizedMarker(
//       'assets/images/currentMarker.png',
//       width: 40,
//     );
//   }

//   Future<void> _initData() async {
//     await _loadMapStyle();
//     await _loadIcons();
//     _setupRoute();
//   }

//   /// SAFE COORDINATE PARSER
//   double _parseCoordinate(dynamic value) {
//     if (value == null) return 0;

//     if (value is double) return value;

//     String val = value.toString().trim();

//     final direct = double.tryParse(val);
//     if (direct != null) return direct;

//     val = val.replaceAll("°", "");
//     final parts = val.split(RegExp(r'\s+'));

//     if (parts.length != 2) return 0;

//     double coordinate = double.parse(parts[0]);
//     String direction = parts[1].toUpperCase();

//     if (direction == "S" || direction == "W") {
//       coordinate = -coordinate;
//     }

//     return coordinate;
//   }

//   void _setupRoute() {
//     Set<Marker> tempMarkers = {};

//     /// MAIN HUB (GREEN MARKER)
//     tempMarkers.add(
//       Marker(
//         markerId: const MarkerId("hub"),
//         position: widget.hubLocation,
//         infoWindow: InfoWindow(
//           title: widget.hub.chargingHubName ?? "Charging Station",
//         ),
//           icon: hubIcon!,
//       ),
//     );

//     /// NEARBY HUBS (ORANGE MARKERS)
//    for (var station in widget.nearbyHubs) {

//   /// Skip current hub
//   if (station.recId == widget.hub.recId) {
//     continue;
//   }

//   if (station.latitude != null && station.longitude != null) {
//     try {
//       final latitude = _parseCoordinate(station.latitude);
//       final longitude = _parseCoordinate(station.longitude);

//       tempMarkers.add(
//         Marker(
//           markerId: MarkerId("nearby_${station.recId}"),
//           position: LatLng(latitude, longitude),
//           infoWindow: InfoWindow(
//             title: station.chargingHubName ?? "Nearby Station",
//           ),
//           icon: nearbyIcon!,
//         ),
//       );
//     } catch (_) {}
//   }
// }

//     /// CURRENT LOCATION MARKER
//     tempMarkers.add(
//       Marker(
//         markerId: const MarkerId("current_location"),
//         position: widget.currentLocation,
//        icon: currentIcon!,
//         infoWindow: const InfoWindow(title: "Your Location"),
//       ),
//     );

//     markers = tempMarkers;

//     /// GREEN LOCATION CIRCLE
//     circles = {
//       Circle(
//         circleId: const CircleId("current_circle"),
//         center: widget.currentLocation,
//         radius: 80,
//         fillColor: Colors.green.withOpacity(0.25),
//         strokeColor: Colors.green,
//         strokeWidth: 2,
//       ),
//     };

//     /// ROUTE LINE
//    polylines = {
//   Polyline(
//     polylineId: const PolylineId("route"),
//     points: [
//       LatLng(widget.currentLocation.latitude, widget.currentLocation.longitude),
//       LatLng(widget.hubLocation.latitude, widget.hubLocation.longitude),
//     ],
//     color: Colors.green,
//     width: 5,
//   ),
// };

//     setState(() {});
//   }

//   Future<void> _loadMapStyle() async {
//     mapStyle =
//         await DefaultAssetBundle.of(context).loadString('assets/map_styles/dark_map.json');
//   }

//   /// FIT MAP TO HUB
//   void _fitMarkers() {
//     if (mapController == null) return;

//     mapController!.animateCamera(
//       CameraUpdate.newLatLngZoom(widget.hubLocation, 13),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child: Stack(
//               children: [
//                 GoogleMap(
//                   initialCameraPosition: CameraPosition(
//                     target: widget.currentLocation,
//                     zoom: 14,
//                   ),
//                   onMapCreated: (controller) {
//                     mapController = controller;

//                     if (mapStyle != null) {
//                       mapController!.setMapStyle(mapStyle);
//                     }

//                     Future.delayed(
//                       const Duration(milliseconds: 300),
//                       _fitMarkers,
//                     );
//                   },

//                   markers: markers,
//                   polylines: polylines,
//                   circles: circles,

//                   gestureRecognizers: {
//                     Factory<OneSequenceGestureRecognizer>(
//                       () => EagerGestureRecognizer(),
//                     ),
//                   },

//                   zoomControlsEnabled: false,
//                   compassEnabled: false,
//                   mapToolbarEnabled: false,
//                   buildingsEnabled: false,
//                   trafficEnabled: false,

//                   zoomGesturesEnabled: true,
//                   scrollGesturesEnabled: true,
//                   rotateGesturesEnabled: true,
//                 ),

//                 /// DIRECTION BUTTON
//                 Positioned(
//                   right: 12,
//                   bottom: 12,
//                   child: FloatingActionButton(
//                     mini: true,
//                     backgroundColor: Colors.white,
//                     onPressed: () {
//                       openMaps(
//                         latitude: widget.hubLocation.latitude,
//                         longitude: widget.hubLocation.longitude,
//                       );
//                     },
//                     child: const Icon(
//                       Icons.directions,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox(height: 8),
//       ],
//     );
//   }
// }
// import 'package:HyCharge/Utils/LocationConvert.dart';
// import 'package:HyCharge/Utils/googleMap.dart';
// import 'package:HyCharge/model/ChargingcomprehensiveHubResponse.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';

// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import '../Controller/map_controller.dart';

// class MiniMapWidget extends StatefulWidget {
//   final ChargingHub hub;
//   final LatLng currentLocation;
//   final LatLng hubLocation;

//   const MiniMapWidget({
//     super.key,
//     required this.currentLocation,
//     required this.hubLocation, required this.hub,
//   });

//   @override
//   State<MiniMapWidget> createState() => _MiniMapWidgetState();
// }
// class _MiniMapWidgetState extends State<MiniMapWidget> {
//   GoogleMapController? mapController;

//   Set<Marker> markers = {};
//   Set<Polyline> polylines = {};

//   String? mapStyle;
//   double distanceInKm = 0;

//   @override
//   void initState() {
//     super.initState();
//     _initData();
//   }

//   Future<void> _initData() async {
//     await _loadMapStyle();
//     _setupRoute();
//   }

//   Future<void> _loadMapStyle() async {
//     mapStyle = await DefaultAssetBundle.of(context)
//         .loadString('assets/map_styles/dark_map.json');
//   }

//   void _setupRoute() {

//     /// MARKERS
//     markers = {
//       Marker(
//         markerId: const MarkerId("current"),
//         position: widget.currentLocation,
//         infoWindow: const InfoWindow(title: "Your Location"),
//         icon: BitmapDescriptor.defaultMarkerWithHue(
//           BitmapDescriptor.hueAzure,
//         ),
//       ),

//       Marker(
//         markerId: const MarkerId("hub"),
//         position: widget.hubLocation,
//         infoWindow: InfoWindow(
//           title: widget.hub.chargingHubName ?? "Charging Station",
//         ),
//         icon: BitmapDescriptor.defaultMarkerWithHue(
//           BitmapDescriptor.hueGreen,
//         ),
//       ),
//     };

//     /// ROUTE LINE
//     polylines = {
//       Polyline(
//         polylineId: const PolylineId("route"),
//         points: [
//           widget.currentLocation,
//           widget.hubLocation,
//         ],
//         width: 4,
//         color: Colors.green,
//         geodesic: true,
//       ),
//     };

//     /// DISTANCE
//     distanceInKm = Geolocator.distanceBetween(
//           widget.currentLocation.latitude,
//           widget.currentLocation.longitude,
//           widget.hubLocation.latitude,
//           widget.hubLocation.longitude,
//         ) /
//         1000;

//     setState(() {});
//   }

//   void _fitMarkers() {
//     if (mapController == null) return;

//     final bounds = LatLngBounds(
//       southwest: LatLng(
//         widget.currentLocation.latitude < widget.hubLocation.latitude
//             ? widget.currentLocation.latitude
//             : widget.hubLocation.latitude,
//         widget.currentLocation.longitude < widget.hubLocation.longitude
//             ? widget.currentLocation.longitude
//             : widget.hubLocation.longitude,
//       ),
//       northeast: LatLng(
//         widget.currentLocation.latitude > widget.hubLocation.latitude
//             ? widget.currentLocation.latitude
//             : widget.hubLocation.latitude,
//         widget.currentLocation.longitude > widget.hubLocation.longitude
//             ? widget.currentLocation.longitude
//             : widget.hubLocation.longitude,
//       ),
//     );

//     mapController!.animateCamera(
//       CameraUpdate.newLatLngBounds(bounds, 70),
//     );
//   }

//   void _moveToCurrentLocation() {
//     mapController?.animateCamera(
//       CameraUpdate.newCameraPosition(
//         CameraPosition(
//           target: widget.currentLocation,
//           zoom: 16,
//           tilt: 45,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(12),
//       child: Stack(
//         children: [
//           GoogleMap(
//             initialCameraPosition: CameraPosition(
//               target: widget.currentLocation,
//               zoom: 14,
//               tilt: 45,
//             ),

//             onMapCreated: (controller) {
//               mapController = controller;

//               if (mapStyle != null) {
//                 mapController!.setMapStyle(mapStyle);
//               }

//               Future.delayed(
//                 const Duration(milliseconds: 400),
//                 _fitMarkers,
//               );
//             },

//             markers: markers,
//             polylines: polylines,

//             gestureRecognizers: {
//               Factory<OneSequenceGestureRecognizer>(
//                 () => EagerGestureRecognizer(),
//               ),
//             },

//             myLocationEnabled: true,
//             myLocationButtonEnabled: false,

//             zoomControlsEnabled: false,
//             compassEnabled: false,
//             mapToolbarEnabled: false,

//             buildingsEnabled: true,
//             indoorViewEnabled: true,

//             trafficEnabled: false,
//             mapType: MapType.normal,
//           ),

//           /// GPS Button
//           Positioned(
//             right: 12,
//             top: 12,
//             child: Container(
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black26,
//                     blurRadius: 4,
//                   ),
//                 ],
//               ),
//               child: IconButton(
//                 icon: const Icon(Icons.gps_fixed),
//                 onPressed: _moveToCurrentLocation,
//               ),
//             ),
//           ),

//           /// Direction Button
//           Positioned(
//             right: 12,
//             bottom: 12,
//             child: FloatingActionButton(
//               mini: true,
//               backgroundColor: Colors.white,
//               onPressed: () {
//                 openMaps(
//                   latitude: widget.hubLocation.latitude,
//                   longitude: widget.hubLocation.longitude,
//                 );
//               },
//               child: const Icon(
//                 Icons.directions,
//                 color: Colors.black,
//               ),
//             ),
//           ),

//           /// Distance Badge
//           Positioned(
//             left: 12,
//             bottom: 12,
//             child: Container(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.7),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Text(
//                 "${distanceInKm.toStringAsFixed(2)} km away",
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 12,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// class _MiniMapWidgetState extends State<MiniMapWidget> {
//   GoogleMapController? mapController;
//   Set<Marker> markers = {};
//   Set<Polyline> polylines = {};
//   String? mapStyle;
//   double distanceInKm = 0;

//   @override
//   void initState() {
//     super.initState();
//     _initData();
//   }

//   Future<void> _initData() async {
//     await _loadMapStyle();
//     _setupRoute();
//   }

//   Future<void> _loadMapStyle() async {
//     mapStyle = await DefaultAssetBundle.of(context)
//         .loadString('assets/map_styles/dark_map.json');
//   }

//   void _setupRoute() {
//     markers = {
//       Marker(
//         markerId: const MarkerId("current"),
//         position: widget.currentLocation,
//         infoWindow:  InfoWindow(title: "${widget.currentLocation}"),
//         icon: BitmapDescriptor.defaultMarkerWithHue(
//             BitmapDescriptor.hueRed),
//       ),
//       Marker(
//         markerId: const MarkerId("hub"),
//         position: widget.hubLocation,
//         infoWindow:  InfoWindow(title:widget.hub.chargingHubName),
//         icon: BitmapDescriptor.defaultMarkerWithHue(
//             BitmapDescriptor.hueOrange),
//       ),
//     };

//     polylines = {
//       Polyline(
//         polylineId: const PolylineId("route"),
//         points: [widget.currentLocation, widget.hubLocation],
//         color: Colors.green,
//         width: 5,
//       ),
//     };

//     distanceInKm = Geolocator.distanceBetween(
//           widget.currentLocation.latitude,
//           widget.currentLocation.longitude,
//           widget.hubLocation.latitude,
//           widget.hubLocation.longitude,
//         ) /
//         1000;

//     setState(() {});
//   }

//   void _fitMarkers() {
//     if (mapController == null) return;

//     final bounds = LatLngBounds(
//       southwest: LatLng(
//         widget.currentLocation.latitude < widget.hubLocation.latitude
//             ? widget.currentLocation.latitude
//             : widget.hubLocation.latitude,
//         widget.currentLocation.longitude < widget.hubLocation.longitude
//             ? widget.currentLocation.longitude
//             : widget.hubLocation.longitude,
//       ),
//       northeast: LatLng(
//         widget.currentLocation.latitude > widget.hubLocation.latitude
//             ? widget.currentLocation.latitude
//             : widget.hubLocation.latitude,
//         widget.currentLocation.longitude > widget.hubLocation.longitude
//             ? widget.currentLocation.longitude
//             : widget.hubLocation.longitude,
//       ),
//     );

//     mapController!
//         .animateCamera(CameraUpdate.newLatLngBounds(bounds, 60));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//       Expanded(
//   child: ClipRRect(
//     borderRadius: BorderRadius.circular(12),
//     child: Stack(
//       children: [
//         GoogleMap(
//           initialCameraPosition: CameraPosition(
//             target: widget.currentLocation,
//             zoom: 14,
//           ),
//           onMapCreated: (controller) {
//             mapController = controller;
//             if (mapStyle != null) {
//               mapController!.setMapStyle(mapStyle);
//             }
//             Future.delayed(
//               const Duration(milliseconds: 300),
//               _fitMarkers,
//             );
//           },
//           markers: markers,
//           polylines: polylines,
//           gestureRecognizers: {
//     Factory<OneSequenceGestureRecognizer>(
//       () => EagerGestureRecognizer(),
//     ),
//   },
//           zoomControlsEnabled: false,
//           compassEnabled: false,
//           mapToolbarEnabled: false,
//           buildingsEnabled: false,
//           trafficEnabled: false,
//           zoomGesturesEnabled: true,
//           scrollGesturesEnabled: true,
//           rotateGesturesEnabled: true,
//         ),

//         /// 🔥 Direction button (right side)
//         Positioned(
//           right: 12,
//           bottom: 12,
//           child: FloatingActionButton(
//             mini: true,
//             backgroundColor: Colors.white,
//             onPressed: () {
//               openMaps(
//                 latitude: widget.hubLocation.latitude,
//                 longitude: widget.hubLocation.longitude,
//               );
//             },
//             child: const Icon(
//               Icons.directions,
//               color: Colors.black,
//             ),
//           ),
//         ),
//       ],
//     ),
//   ),
// ),


//         const SizedBox(height: 8),
       
//       ],
//     );
//   }


// }
