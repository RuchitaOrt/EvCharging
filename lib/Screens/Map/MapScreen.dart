
import 'package:HyCharge/Provider/ActiveSessionProvider.dart';
import 'package:HyCharge/Provider/HubProvider.dart';
import 'package:HyCharge/Screens/ActiveSessionsScreen.dart';
import 'package:HyCharge/Screens/Controller/map_controller.dart';
import 'package:HyCharge/Screens/Controller/station_card_widget.dart';
import 'package:HyCharge/Screens/Map/ActiveSessionCardWidget.dart';
import 'package:HyCharge/Screens/SearchBarWidget.dart';
import 'package:HyCharge/Screens/auth/login_bottom_sheet.dart';
import 'package:HyCharge/Utils/AuthStorage.dart';
import 'package:HyCharge/Utils/ShowDialog.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/Utils/commonimages.dart';
import 'package:HyCharge/enum/enum.dart';
import 'package:HyCharge/main.dart';
import 'package:HyCharge/widget/FilterBottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
Set<ChargerFilterType> selectedFilters = {};
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
              Positioned(
  top: 10,
  left: 20,
  right: 20,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      /// 🔍 SEARCH BAR (takes full remaining width)
      Text("UAT",style: TextStyle(color: CommonColors.background,fontSize: 14,fontWeight: FontWeight.bold),),
    ])),

              /// Search
              Positioned(
  top: 30,
  left: 20,
  right: 20,
  child: Row(
    children: [
      /// 🔍 SEARCH BAR (takes full remaining width)
      Expanded(
        child: SearchBarWidget(
          onSearch: _onSearchHub,
        ),
      ),

      // const SizedBox(width: 10),

      /// 🔽 FILTER ICON
//       GestureDetector(
//        onTap: () async {
//   final result = await showModalBottomSheet<Set<ChargerFilterType>>(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.white,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//     ),
//     builder: (_) => FilterBottomSheet(selectedFilters: selectedFilters),
//   );

//   if (result != null) {
//     setState(() {
//       selectedFilters = result;
//     });

//     applyFilters(); // 🔥 IMPORTANT
//   }
// },
//         child:
//        Stack(
//   children: [
//      Image.asset(
//         CommonImagePath.filter,
//         height: 40,
//         width: 40,
       
//       ),
//     /// 🔴 ACTIVE DOT
//     if (selectedFilters.isNotEmpty)
//       Positioned(
//         right: 4,
//         top: 4,
//         child: Container(
//           height: 8,
//           width: 8,
//           decoration: BoxDecoration(
//             color: Colors.red,
//             shape: BoxShape.circle,
//           ),
//         ),
//       ),
//   ],
// )
//       ),
    ],
  ),
),
              // Positioned(
              //   top: 20,
              //   left: 20,
              //   right: 20,
              //   child: 
              //   SearchBarWidget(onSearch: _onSearchHub),
              // ),

              /// GPS Button
              Positioned(
                top: 100,
                right: 20,
                child: _gpsButton(),
              ),
  // Positioned(
  //               bottom: 200,
  //               right: 20,
  //               child: _gpsButton(),
  //             ),

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
void _onSearchHub(String value) async {
  if (value.trim().isEmpty) return;

  final result =
      await context.read<HubProvider>().searchAndFocusHub(value);

  switch (result) {
    case SearchHubResult.notFound:
   
      showToast("We couldn’t find any nearby chargers for this location.",gravity: ToastGravity.CENTER);
      break;

    case SearchHubResult.sameLocation:
     
      // showToast( "You're already viewing this charging station.",gravity: ToastGravity.CENTER);
      break;

    case SearchHubResult.found:
     
      // showToast( "Charging station located successfully.",gravity: ToastGravity.CENTER);
      break;
  }
}
  // void _onSearchHub(String value) {
  //   context.read<HubProvider>().searchAndFocusHub(value);
  // }
  void applyFilters() {
  // if (selectedFilters.isEmpty) {
  //   filteredList = originalList;
  // } else {
  //   filteredList = originalList.where((station) {
  //     return selectedFilters.any((filter) {
  //       switch (filter) {
  //         case ChargerFilterType.ac:
  //           return station.type == "AC";
  //         case ChargerFilterType.dc:
  //           return station.type == "DC";
  //         case ChargerFilterType.car:
  //           return station.vehicle == "Car";
  //         case ChargerFilterType.bike:
  //           return station.vehicle == "Bike";
  //         case ChargerFilterType.both:
  //           return station.vehicle == "Both";
  //         case ChargerFilterType.fast:
  //           return station.isFast == true;
  //       }
  //     });
  //   }).toList();
  // }

  setState(() {});
}
}
