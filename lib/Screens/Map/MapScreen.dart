// import 'package:HyCharge/Provider/ActiveSessionProvider.dart';
// import 'package:HyCharge/Provider/HubProvider.dart';
// import 'package:HyCharge/Screens/ActiveSessionsScreen.dart';
// import 'package:HyCharge/Screens/Controller/filter_chips_widget.dart';

// import 'package:HyCharge/Screens/Controller/map_controller.dart';
// import 'package:HyCharge/Screens/Controller/station_card_widget.dart';
// import 'package:HyCharge/Screens/Map/ActiveSessionCardWidget.dart';
// import 'package:HyCharge/Screens/SearchBarWidget.dart';
// import 'package:HyCharge/Screens/auth/LoginSwitchWidget.dart';
// import 'package:HyCharge/Screens/auth/login_bottom_sheet.dart';
// import 'package:HyCharge/Utils/AuthStorage.dart';
// import 'package:HyCharge/main.dart';
// import 'package:flutter/material.dart';

// import 'package:flutter/services.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:provider/provider.dart';

// class MapScreen extends StatefulWidget {
//   final bool isLogin;

//   const MapScreen({super.key, this.isLogin = false});

//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   late MapController controller;
//   String? mapsStyle;

//   @override
//   void initState() {
//     super.initState();
//     controller = MapController();
//     final provider = context.read<HubProvider>();
//     provider.listenToScroll(350);
//     print("LOGGED IN init");
//     loadData();
//   }
//  bool isLoggedIn=false;
//   loadData() async {
//     final style = await DefaultAssetBundle.of(context)
//         .loadString('assets/map_styles/dark_map.json');
//     setState(() {
//       mapsStyle = style;
//     });
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       //horizontal on map
//       context.read<HubProvider>().loadHubs(context);
//       // if (!widget.isLogin) {
//       //   showLoginSheet(context);
//       // }
//        isLoggedIn = await AuthStorage.isLoggedIn();
//       print("LOGGED IN ${isLoggedIn}");
//       if (!isLoggedIn) {
//         showLoginSheet(context);
//       }else{
//          final provider = context.read<ActiveSessionProvider>();
//       provider.fetchActiveSessions(context,"Active");
//       }

     
//     });
//   }

//   void showLoginSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isDismissible: false,
//       enableDrag: false,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) {
//         return WillPopScope(
//           onWillPop: () async => false,
//           child: const LoginSheetWidget(),
//         );
//       },
//     );


//   }

//   @override
//   Widget build(BuildContext context) {
    
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//         statusBarBrightness: Brightness.light,
//         statusBarIconBrightness: Brightness.light));
//     return Consumer<HubProvider>(
//       builder: (_, hubProvider, __) {
//         return Scaffold(
//           resizeToAvoidBottomInset: false,
//           body: Stack(
//             children: [
//               GoogleMap(
//                indoorViewEnabled: true,
//                 initialCameraPosition: CameraPosition(
//                   // target location
//                   target: controller.center,
//                   // target: hubProvider.firstMarkerPosition!,
//                   zoom: 12,
//                   tilt: 45,
//                   bearing: 0,
//                 ),
//                 myLocationEnabled: true,
//                 myLocationButtonEnabled: false,
//                 markers: hubProvider.markers,
//                  mapType: MapType.normal, // 👈 IMPORTANT
//   buildingsEnabled: true, // 👈 REQUIRED
//                 // onMapCreated: controller.onMapCreated,
//                 onMapCreated: (controller) {
//                   context
//                       .read<HubProvider>()
//                       .mapController
//                       .onMap2Created(controller);
//                   // context.read<HubProvider>().initFirstItem(350); // card width + spacing
//                 },
//                 onCameraIdle: () {
//                   // hubProvider.loadHubs(context);
//                 },
//                 zoomControlsEnabled: false,
//                 style: mapsStyle,
//                 compassEnabled: false,
//                 mapToolbarEnabled: false,
//                 // buildingsEnabled: false,
//                 trafficEnabled: false,
//                 polylines: hubProvider.polyLines,
//                 onTap: (LatLng) {
//                   print('MapScreen Click');
//                   // hubProvider.clearRoute();
//                 },
//                 onLongPress: (LatLong) async {
//                   print('MapScreen Click');
//                   // hubProvider.clearRoute();
//                 },
//               ),
//               Positioned(
//                   top: 20,
//                   left: 20,
//                   right: 20,
//                   child: SearchBarWidget(
//                     onSearch: _onSearchHub,
//                   )),
//              //  const Positioned(top: 130, left: 20, child: FilterChipsWidget()),
//               Positioned(
//                 top: 100,
//                 right: 20,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(color: Colors.black26, blurRadius: 4),
//                     ],
//                   ),
//                   child: IconButton(
//                     icon: const Icon(Icons.gps_fixed, color: Colors.black),
//                     onPressed: () async {
//                       await context
//                           .read<HubProvider>()
//                           .mapController
//                           .moveToCurrentLocation();
//                     },
//                   ),
//                 ),
//               ),
//               // const Positioned(
//               //     top: 130, right: 20, child: DiscountWidget(label: "10 %")),
//               if (hubProvider.isRouteLoading)
//                 const Center(
//                     child: CircularProgressIndicator(
//                   color: Colors.green,
//                 )),
//               Consumer<ActiveSessionProvider>(
//                 builder: (_, sessionProvider, __) {
//                   if (sessionProvider.loading ||
//                       sessionProvider.sessions.isEmpty) {
//                     return const SizedBox.shrink();
//                   }

//                   return Positioned(
//                     bottom: 190,
//                     left: 20,
//                     child: GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                               routeGlobalKey.currentContext!,
//                               MaterialPageRoute(
//                                   builder: (context) =>
//                                       ActiveSessionsScreen()));
//                         },
//                         child: ActiveSessionCardWidget()),
//                   );
//                 },
//               ),

//           isLoggedIn==false?Container():     (hubProvider.loading)?
//                  Center(child: CircularProgressIndicator()):
//                Positioned(
//                 bottom: 40,
//                 left: 0,
//                 right: 0,
//                 child: StationCardWidget(),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _onSearchHub(String value) {
//     context.read<HubProvider>().searchAndFocusHub(value);
//   }
// }

import 'package:HyCharge/Provider/ActiveSessionProvider.dart';
import 'package:HyCharge/Provider/HubProvider.dart';
import 'package:HyCharge/Screens/ActiveSessionsScreen.dart';
import 'package:HyCharge/Screens/Controller/map_controller.dart';
import 'package:HyCharge/Screens/Controller/station_card_widget.dart';
import 'package:HyCharge/Screens/Map/ActiveSessionCardWidget.dart';
import 'package:HyCharge/Screens/SearchBarWidget.dart';
import 'package:HyCharge/Screens/auth/login_bottom_sheet.dart';
import 'package:HyCharge/Utils/AuthStorage.dart';
import 'package:HyCharge/main.dart';
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
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    controller = MapController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HubProvider>().listenToScroll(350);
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final style = await rootBundle.loadString(
      'assets/map_styles/dark_map.json',
    );

    if (!mounted) return;

    setState(() {
      mapsStyle = style;
    });

    context.read<HubProvider>().loadHubs(context);

    final loggedIn = await AuthStorage.isLoggedIn();
    if (!mounted) return;

    setState(() {
      isLoggedIn = loggedIn;
    });

    if (!loggedIn) {
      _showLoginSheet(context);
    } else {
      context
          .read<ActiveSessionProvider>()
          .fetchActiveSessions(context, "Active");
    }
  }

  void _showLoginSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return PopScope(
          canPop: false,
          child: const LoginSheetWidget(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Consumer<HubProvider>(
      builder: (_, hubProvider, __) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: controller.center,
                  zoom: 12,
                  tilt: 45,
                ),
                onMapCreated: (mapController) {
                  hubProvider.mapController.onMap2Created(mapController);
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                markers: hubProvider.markers,
                polylines: hubProvider.polyLines,
                zoomControlsEnabled: false,
                compassEnabled: false,
                mapToolbarEnabled: false,
                buildingsEnabled: true,
                indoorViewEnabled: true,
                mapType: MapType.normal,
                trafficEnabled: false,
                style: mapsStyle,
              ),

              /// Search
              Positioned(
                top: 20,
                left: 20,
                right: 20,
                child: SearchBarWidget(onSearch: _onSearchHub),
              ),

              /// GPS Button
              Positioned(
                top: 100,
                right: 20,
                child: _gpsButton(),
              ),

              /// Route loading
              if (hubProvider.isRouteLoading)
                const Center(
                  child: CircularProgressIndicator(color: Colors.green),
                ),

              /// Active Session Card
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
                            builder: (_) => ActiveSessionsScreen(),
                          ),
                        );
                      },
                      child: const ActiveSessionCardWidget(),
                    ),
                  );
                },
              ),

              /// Station Card
              if (isLoggedIn)
                hubProvider.loading
                    ? const Center(child: CircularProgressIndicator())
                    : const Positioned(
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

  Widget _gpsButton() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 4),
        ],
      ),
      child: IconButton(
        icon: const Icon(Icons.gps_fixed, color: Colors.black),
        onPressed: () {
          context.read<HubProvider>().mapController.moveToCurrentLocation();
        },
      ),
    );
  }

  void _onSearchHub(String value) {
    context.read<HubProvider>().searchAndFocusHub(value);
  }
}
