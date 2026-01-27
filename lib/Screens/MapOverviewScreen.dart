import 'dart:ui';

import 'package:ev_charging_app/Provider/HubProvider.dart';
import 'package:ev_charging_app/Screens/MapStationCardScreen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../Utils/LocationConvert.dart';
import '../model/ChargingcomprehensiveHubResponse.dart';
import 'Controller/map_controller.dart';

class MapOverviewScreen extends StatefulWidget {
  final ChargingHub hub;
  final Position location;
  const MapOverviewScreen({super.key,
    required this.hub, required this.location});

  @override
  State<MapOverviewScreen> createState() => _MapOverviewScreenState();
}

class _MapOverviewScreenState extends State<MapOverviewScreen> {
  // GoogleMapController? mapController;
  // final LatLng center = const LatLng(17.4444, 78.3772);

  bool showSheet = false; // controls animation
  late MapController controller;
  late String mapsStyle;
  @override
  void initState() {
    super.initState();
    controller = MapController();
     loadData();
    // Delay to trigger animation after screen loads
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        showSheet = true;
      });
    });

  }

  loadData() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      mapsStyle = await DefaultAssetBundle.of(context)
          .loadString('assets/map_styles/dark_map.json');
      context.read<HubProvider>().loadHubs(context);
    //
      LatLng targetLocation = LocationConvert.getLatLngFromHub(widget.hub)!;
      if (targetLocation != null) {
        context.read<HubProvider>().drawRoute(LatLng(0.0, 0.0), targetLocation);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HubProvider>(
        builder: (_, hubProvider, __) {
          return Scaffold(
            body: Stack(
              children: [
                // Google Map
                Positioned.fill(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      // target location
                      target: LatLng(widget.location.latitude, widget.location.longitude),
                      // target: hubProvider.firstMarkerPosition!,
                      zoom: 12,
                      tilt: 45,
                      bearing: 0,
                    ),
                    myLocationEnabled: false,
                    myLocationButtonEnabled: false,
                    markers: hubProvider.markers,
                    onMapCreated: controller.onMapCreated,
                    onCameraIdle: () {
                      // hubProvider.loadHubs(context);
                    },
                    zoomControlsEnabled: false,
                    style: mapsStyle,
                    compassEnabled: false,
                    mapToolbarEnabled: false,
                    buildingsEnabled: false,
                    trafficEnabled: false,
                    polylines: hubProvider.polyLines,
                    onTap: (LatLng) {
                      print('MapScreen Click');
                      // hubProvider.clearRoute();
                    },
                    onLongPress: (LatLong) async {
                      print('MapScreen Click');
                      hubProvider.clearRoute();
                      // final Position position = await MapController().getCurrentPosition();
                      // // drawRoute(LatLng(19.262147, 72.983966), LatLng(19.193039, 72.953840));
                      // hubProvider.drawRoute(LatLng(position.latitude, position.longitude), LatLng(19.196262, 72.962967));

                    },
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
                    height: 350,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: MapStationCardScreen(hub: widget.hub,),
                  ),
                ),
              ],
            ),
          );
        }

    );
  }
}

Future<BitmapDescriptor> createDotMarker(Color color) async {
  final PictureRecorder recorder = PictureRecorder();
  final Canvas canvas = Canvas(recorder);
  final Paint paint = Paint()
    ..color = color;

  const double size = 18; // dot diameter
  canvas.drawCircle(const Offset(size / 2, size / 2), size / 2, paint);

  final image =
  await recorder.endRecording().toImage(size.toInt(), size.toInt());
  final bytes = await image.toByteData(format: ImageByteFormat.png);

  return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
}
