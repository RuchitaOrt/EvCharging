import 'package:ev_charging_app/Provider/ActiveSessionProvider.dart';
import 'package:ev_charging_app/Provider/HubProvider.dart';
import 'package:ev_charging_app/Screens/ActiveSessionsScreen.dart';
import 'package:ev_charging_app/Screens/Controller/filter_chips_widget.dart';

import 'package:ev_charging_app/Screens/Controller/map_controller.dart';
import 'package:ev_charging_app/Screens/Controller/station_card_widget.dart';
import 'package:ev_charging_app/Screens/Map/ActiveSessionCardWidget.dart';
import 'package:ev_charging_app/Screens/SearchBarWidget.dart';
import 'package:ev_charging_app/Screens/auth/login_bottom_sheet.dart';
import 'package:ev_charging_app/Utils/AuthStorage.dart';
import 'package:ev_charging_app/main.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  final bool isLogin;

  const MapScreen({super.key, this.isLogin = false});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapController controller;
  String? mapsStyle;

  @override
  void initState() {
    super.initState();
    controller = MapController();
    final provider = context.read<HubProvider>();
    provider.listenToScroll(350);
    print("LOGGED IN init");
    loadData();
  }

  loadData() async {
    final style = await DefaultAssetBundle.of(context)
        .loadString('assets/map_styles/dark_map.json');
    setState(() {
      mapsStyle = style;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<HubProvider>().loadHubs(context);
      // if (!widget.isLogin) {
      //   showLoginSheet(context);
      // }
      final isLoggedIn = await AuthStorage.isLoggedIn();
      print("LOGGED IN ${isLoggedIn}");
      if (!isLoggedIn) {
        showLoginSheet(context);
      }else{
         final provider = context.read<ActiveSessionProvider>();
      provider.fetchActiveSessions(context,"Active");
      }

     
    });
  }

  void showLoginSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return WillPopScope(
          onWillPop: () async => false,
          child: const LoginSheetWidget(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light));
    return Consumer<HubProvider>(
      builder: (_, hubProvider, __) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  // target location
                  target: controller.center,
                  // target: hubProvider.firstMarkerPosition!,
                  zoom: 12,
                  tilt: 45,
                  bearing: 0,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                markers: hubProvider.markers,
                // onMapCreated: controller.onMapCreated,
                onMapCreated: (controller) {
                  context
                      .read<HubProvider>()
                      .mapController
                      .onMap2Created(controller);
                  // context.read<HubProvider>().initFirstItem(350); // card width + spacing
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
                polylines: hubProvider.polyLines,
                onTap: (LatLng) {
                  print('MapScreen Click');
                  // hubProvider.clearRoute();
                },
                onLongPress: (LatLong) async {
                  print('MapScreen Click');
                  // hubProvider.clearRoute();
                },
              ),
              Positioned(
                  top: 20,
                  left: 20,
                  right: 20,
                  child: SearchBarWidget(
                    onSearch: _onSearchHub,
                  )),
             //  const Positioned(top: 130, left: 20, child: FilterChipsWidget()),
              Positioned(
                top: 100,
                right: 20,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 4),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.gps_fixed, color: Colors.black),
                    onPressed: () async {
                      await context
                          .read<HubProvider>()
                          .mapController
                          .moveToCurrentLocation();
                    },
                  ),
                ),
              ),
              // const Positioned(
              //     top: 130, right: 20, child: DiscountWidget(label: "10 %")),
              if (hubProvider.isRouteLoading)
                const Center(
                    child: CircularProgressIndicator(
                  color: Colors.green,
                )),
              Consumer<ActiveSessionProvider>(
                builder: (_, sessionProvider, __) {
                  if (sessionProvider.loading ||
                      sessionProvider.sessions.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Positioned(
                    bottom: 190,
                    left: 20,
                    child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              routeGlobalKey.currentContext!,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ActiveSessionsScreen()));
                        },
                        child: ActiveSessionCardWidget()),
                  );
                },
              ),

              if (hubProvider.loading)
                const Center(child: CircularProgressIndicator()),
              const Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: StationCardWidget(),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onSearchHub(String value) {
    context.read<HubProvider>().searchAndFocusHub(value);
  }
}
