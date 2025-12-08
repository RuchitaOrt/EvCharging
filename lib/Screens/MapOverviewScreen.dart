import 'dart:ui';

import 'package:ev_charging_app/Screens/MapStationCardScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapOverviewScreen extends StatefulWidget {
  const MapOverviewScreen({super.key});

  @override
  State<MapOverviewScreen> createState() => _MapOverviewScreenState();
}

class _MapOverviewScreenState extends State<MapOverviewScreen> {
  GoogleMapController? mapController;

  final LatLng center = const LatLng(17.4444, 78.3772);

  bool showSheet = false; // controls animation

  Set<Marker> markers = {
    Marker(
      markerId: MarkerId("station1"),
      position: LatLng(17.440460, 78.391060),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    ),
    Marker(
      markerId: MarkerId("station2"),
      position: LatLng(17.443830, 78.385940),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    )
  };

  @override
  void initState() {
    super.initState();
loadPointerIcon();
    // Delay to trigger animation after screen loads
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        showSheet = true;
      });
    });
  }
Set<Polyline> _polylines = {};

void _addDummyRoute() {
  final start = LatLng(17.440460, 78.391060);
  final end   = LatLng(17.443830, 78.385940);

  List<LatLng> points = [
    start,
    LatLng(17.441100, 78.389900),
    LatLng(17.442200, 78.388000),
    end,
  ];

  _polylines = {
    Polyline(
      polylineId: PolylineId('dummy_route'),
      color: Color(0xFF00FF66), // bright neon green
      width: 2,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      jointType: JointType.round,
      points: points,
    )
  };

  setState(() {});
}

BitmapDescriptor? pointerIcon;

Future<void> loadPointerIcon() async {
  pointerIcon = await BitmapDescriptor.fromAssetImage(
    ImageConfiguration(size: Size(30, 30)),
    "assets/inages/location.png",
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Google Map
       Positioned.fill(
  child:GoogleMap(
  initialCameraPosition: CameraPosition(
    target: LatLng(17.440460, 78.391060),
    zoom: 14,
  ),
  onMapCreated: (controller) async {
    mapController = controller;

    String style = await DefaultAssetBundle.of(context)
        .loadString('assets/map_styles/dark_map.json');

    mapController!.setMapStyle(style);

    Future.delayed(Duration(milliseconds: 300), () {
      _addDummyRoute();
    });
  },
  polylines: _polylines,
  markers: markers,
  zoomControlsEnabled: false,
),

),



          // === Animated Bottom Sheet ===
          AnimatedPositioned(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            left: 0,
            right: 0,

            // when hidden → place below screen
            // when visible → stick to bottom
            bottom: showSheet ? 0 : -260,

            child: Container(
              padding: const EdgeInsets.all(16),
              height: 340,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: MapStationCardScreen(),
            ),
          ),
        ],
      ),
    );
  }
}
Future<BitmapDescriptor> createDotMarker(Color color) async {
  final PictureRecorder recorder = PictureRecorder();
  final Canvas canvas = Canvas(recorder);
  final Paint paint = Paint()..color = color;

  const double size = 18; // dot diameter
  canvas.drawCircle(const Offset(size / 2, size / 2), size / 2, paint);

  final image = await recorder.endRecording().toImage(size.toInt(), size.toInt());
  final bytes = await image.toByteData(format: ImageByteFormat.png);

  return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
}
