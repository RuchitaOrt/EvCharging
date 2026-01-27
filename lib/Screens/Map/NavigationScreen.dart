import 'package:ev_charging_app/Provider/NavigationProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../Utils/commoncolors.dart';
import '../../Utils/commonimages.dart';
import '../../model/ChargingcomprehensiveHubResponse.dart';
import '../Controller/map_controller.dart';
import '../MapStationCardScreen.dart';

class NavigationScreen extends StatefulWidget {
  final ChargingHub hub;
  NavigationScreen({super.key,
    required this.hub});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {

  bool showSheet = false; // controls animation


  late MapController controller;
  String? mapsStyle;

  @override
  void initState() {
    super.initState();
    controller = MapController();
    loadData();
      Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        showSheet = true;
      });
    });
  }

  loadData() async {
    final style = await DefaultAssetBundle.of(context)
        .loadString('assets/map_styles/dark_map.json');
    setState(() {
      mapsStyle = style;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // mapsStyle = await DefaultAssetBundle.of(context)
      //     .loadString('assets/map_styles/dark_map.json');
      context.read<NavigationProvider>().drawRouteWithInfo(widget.hub);
    });
  }



  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light));
    final h = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        // bool exit = await showDialog(
        //     context: context, builder: (_) => const ReachedPopup()) ??
        //     false;
        // return exit;
        return true;
      },
      child: Consumer<NavigationProvider>(
        builder: (_,naviProvider,__){
          return Scaffold(
            body: Stack(
              children: [
                // Map background
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    // target location
                    target: controller.center,
                    // target: hubProvider.firstMarkerPosition!,
                    zoom: 12,
                    tilt: 45,
                    bearing: 0,
                  ),
                  myLocationEnabled: false,
                  myLocationButtonEnabled: false,
                  markers: naviProvider.markers,
                  // onMapCreated: controller.onMapCreated,
                  onMapCreated: (controller) {
                    context.read<NavigationProvider>()
                        .mapController
                        .onMapCreated(controller);
                  },
                  onCameraIdle: () {
                    // hubProvider.loadHubs(context);
                  },
                  zoomControlsEnabled: false,
                  style: mapsStyle,
                  compassEnabled: false,
                  mapToolbarEnabled: false,
                  buildingsEnabled: false,
                  trafficEnabled: false,
                  zoomGesturesEnabled: !naviProvider.isDriving,
                  scrollGesturesEnabled: !naviProvider.isDriving,
                  rotateGesturesEnabled: !naviProvider.isDriving,
                  tiltGesturesEnabled: !naviProvider.isDriving,


                  polylines: naviProvider.polyLines,
                  onTap: (LatLng) {
                    print('MapScreen Click');
                    // hubProvider.clearRoute();
                  },
                  onLongPress: (LatLong) async {
                    print('MapScreen Click');
                    // naviProvider.clearRoute();
                    // final Position position = await MapController().getCurrentPosition();
                    // // drawRoute(LatLng(19.262147, 72.983966), LatLng(19.193039, 72.953840));
                    // naviProvider.drawRoute(LatLng(position.latitude, position.longitude), LatLng(19.196262, 72.962967));
                  },
                ),

                // center route indicator (mock)
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.only(top: 40),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.drive_eta, color: naviProvider.isDriving ? Colors.green: Colors.red,),
                        SizedBox(width: 4,),
                        Text('Navigating — ${naviProvider.durationText?? ''} • ${naviProvider.distanceText??''}',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),

                // bottom navigation card
                Positioned(
                  bottom: 28,
                  left: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: CommonColors.cardWhite,
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        if (naviProvider.isArrived)
                          const Text("You have arrived!", style: TextStyle(color: Colors.green)),
                        Container(
                          // height: 100,
                          child: Row(
                            children: [
                              ElevatedButton(
                                onPressed: naviProvider.isDriving ? null : naviProvider.startDriving,
                                child: const Text("Start Driving"),
                              ),
                              ElevatedButton(
                                onPressed: naviProvider.isDriving ? naviProvider.stopDriving : null,
                                child: const Text("Stop Driving"),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${naviProvider.durationText}',
                                        style: TextStyle(fontWeight: FontWeight.bold)),
                                    SizedBox(height: 4),
                                    Text('${naviProvider.distanceText}',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: CommonColors.blue.withOpacity(0.8),
                                            fontWeight: FontWeight.w800)),
                                    Row(
                                      children: [
                                        Text('${convertDistanceToMeters(naviProvider.distanceText??'')} meters',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color:
                                                CommonColors.black.withOpacity(0.6),
                                                fontWeight: FontWeight.w800)),
                                        SizedBox(width: 4),
                                        SvgPicture.asset(
                                          CommonImagePath.arrowup,
                                          width: 30,
                                          height: 30,
                                        )
                                      ],
                                    ),
                                  ]),
                            ),
                            SvgPicture.asset(CommonImagePath.greydirection),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // show reached popup for demo
                                naviProvider.isDriving ? naviProvider.stopDriving : null;
                                showDialog(
                                    context: context,
                                    builder: (_) => const ReachedPopup());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: CommonColors.red,
                                foregroundColor: CommonColors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  // side: BorderSide(
                                  //   // color: CommonColors.blue.withOpacity(0.4),
                                  //   // width: 0.8,
                                  // ),
                                ),
                              ),
                              child: const Text(
                                'Exit',
                                style: TextStyle(
                                    color: CommonColors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        }
      )

      ,
    );
  }
  double convertDistanceToMeters(String distanceText) {
    distanceText = distanceText.toLowerCase().trim();
    if (distanceText.contains("km")) {
      final value = double.parse(
        distanceText.replaceAll("km", "").trim(),
      );
      return value * 1000; // km → meters
    } else if (distanceText.contains("m")) {
      final value = double.parse(
        distanceText.replaceAll("m", "").trim(),
      );
      return value; // already meters
    } else {
      return 0;
    }
  }

}