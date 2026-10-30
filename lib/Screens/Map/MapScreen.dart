
import 'package:HyCharge/Bottomsheet/showMyVehiclesBottomSheet.dart';
import 'package:HyCharge/Provider/ActiveSessionProvider.dart';
import 'package:HyCharge/Provider/HubProvider.dart';
import 'package:HyCharge/Provider/ProfileProvider.dart';
import 'package:HyCharge/Provider/VehicleProvider.dart';
import 'package:HyCharge/Provider/WalletProvider.dart';
import 'package:HyCharge/Screens/ActiveSessionsScreen.dart';
import 'package:HyCharge/Screens/Controller/map_controller.dart';
import 'package:HyCharge/Screens/Controller/station_card_widget.dart';
import 'package:HyCharge/Screens/Map/ActiveSessionCardWidget.dart';
import 'package:HyCharge/Screens/SearchBarWidget.dart';
import 'package:HyCharge/Screens/SearchScreen.dart';
import 'package:HyCharge/Screens/auth/login_bottom_sheet.dart';
import 'package:HyCharge/Utils/AuthStorage.dart';
import 'package:HyCharge/Utils/FilterBottomSheet.dart' show FilterBottomSheet, StationFilters;

import 'package:HyCharge/Utils/ShowDialog.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/Utils/commonimages.dart';
import 'package:HyCharge/enum/enum.dart';
import 'package:HyCharge/main.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
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
  StationFilters appliedFilters = const StationFilters();
Future<void> _openFilters() async {
  final result = await showModalBottomSheet<StationFilters>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    useSafeArea: true,
    builder: (_) => FilterBottomSheet(
      initialFilters: appliedFilters,
    ),
  );

  if (result == null || !mounted) return;

  setState(() {
    appliedFilters = result;
  });

  final provider = context.read<HubProvider>();

  // Preserve existing network selection behavior.
  provider.changeTab(result.network);

  // Start the station carousel from the first card.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (provider.scrollController.hasClients) {
      provider.scrollController.jumpTo(0);
    }
  });
}

  late MapController controller;
  String? mapsStyle;
  bool isLoggedIn = false;
Set<ChargerFilterType> selectedFilters = {};
Future<void> _loadWalletBalance() async {
  if (!mounted || !isLoggedIn) return;

  context.read<WalletProvider>().fetchWallet(context);
}
  @override
  void initState() {
    super.initState();
    controller = MapController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HubProvider>().listenToUnifiedScroll(350);
      // .listenToScroll(350);
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

    // context.read<HubProvider>().loadHubs(context);
  
    final loggedIn = await AuthStorage.isLoggedIn();
    if (!mounted) return;

    setState(() {
      isLoggedIn = loggedIn;
    });

    if (!loggedIn) {
      _showLoginSheet(context);
    } else {
      print("RUCHITA HERE FOR DATA");
      context.read<HubProvider>().loadUnifiedHubs(context);
      context
          .read<ActiveSessionProvider>()
          .fetchActiveSessions(context, "Active");
            context
          .read<ActiveSessionProvider>()
          .fetchAUnifiedctiveSessions(context, "Active");
             WidgetsBinding.instance.addPostFrameCallback((_) async {
context.read<ProfileProvider>().loadProfile(context);
   
   
  context.read<VehicleProvider>().getManufacturers(context);
  context.read<VehicleProvider>().getEvModels(context);
  context.read<VehicleProvider>().getUserVehicleList(context);
  if (!loggedIn) {
  _showLoginSheet(context);
} else {
  // Wallet API runs independently.
  _loadWalletBalance();

  // Keep your existing API calls unchanged.
  context.read<HubProvider>().loadUnifiedHubs(context);

  context
      .read<ActiveSessionProvider>()
      .fetchActiveSessions(context, "Active");

  context
      .read<ActiveSessionProvider>()
      .fetchAUnifiedctiveSessions(context, "Active");

  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<VehicleProvider>().getManufacturers(context);
    context.read<VehicleProvider>().getEvModels(context);
    context.read<VehicleProvider>().getUserVehicleList(context);
  });
}

    });
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
               //  myLocationEnabled: true,
                 myLocationEnabled: false,
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

 // TOP HEADER: Greeting + Wallet + Vehicle + Search + Tabs
 Positioned(
   top: 0,
   left: 0,
   right: 0,
   child: SafeArea(
     bottom: false,
     child: Padding(
       padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
       child: Column(
         mainAxisSize: MainAxisSize.min,
         children: [
           // Row 1: Greeting and Wallet
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
             Consumer<ProfileProvider>(
  builder: (context, profileProvider, child) {
    final firstName =
        profileProvider.profile?.user?.firstName?.trim() ?? '';

    return Text(
      firstName.isNotEmpty ? 'Hi $firstName' : '',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    );
  },
),
               // Wallet balance
               Row(
                 children: [
                     const Text(
                 'UAT',
                 style: TextStyle(
                   color: Colors.white,
                   fontSize: 12,
                   fontWeight: FontWeight.bold,
                 ),
               ),
               SizedBox(width: 10,),
                Consumer<WalletProvider>(
  builder: (context, walletProvider, child) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            CommonImagePath.transaction,
            width: 16,
            height: 16,
            color: CommonColors.blue,
          ),
          const SizedBox(width: 6),
          Text(
            '₹ ${walletProvider.currentBalance.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Color(0xFF142D70),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  },
),
                 ],
               ),
             ],
           ),

           const SizedBox(height: 5),

           // Row 2: Vehicle on left, UAT on right
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Expanded(
                 child: Consumer<VehicleProvider>(
                   builder: (context, vehicleProvider, child) {
                     if (vehicleProvider.evModels.isEmpty ||
                         vehicleProvider.userVehicles.isEmpty) {
                       return const SizedBox.shrink();
                     }

                     final vehicle = vehicleProvider.defaultVehicle;

                     if (vehicle == null) {
                       return const SizedBox.shrink();
                     }

                     final modelName = vehicleProvider.getModelName(
                       vehicle.carModelID,
                     );

                     return GestureDetector(
                       onTap: () {
                         showMyVehiclesBottomSheet(
                           routeGlobalKey.currentContext!,
                         );
                       },
                       child: Row(
                         mainAxisSize: MainAxisSize.min,
                         children: [
                         SvgPicture.asset(CommonImagePath.carIcons,width: 18,height: 18,),
                           const SizedBox(width: 4),
                           Flexible(
                             child: Text(
                               '${modelName ?? ""} · '
                               '${vehicle.carRegistrationNumber ?? ""}',
                               maxLines: 1,
                               overflow: TextOverflow.ellipsis,
                               style: const TextStyle(
                                 color: Colors.white,
                                 fontSize: 13,
                                 fontWeight: FontWeight.bold,
                               ),
                             ),
                           ),
                           const Icon(
                             Icons.keyboard_arrow_down,
                             color: Colors.white,
                             size: 19,
                           ),
                         ],
                       ),
                     );
                   },
                 ),
               ),

              //  const SizedBox(width: 8),

               // Environment label
              
             ],
           ),

           const SizedBox(height: 12),

           // Row 3: Search bar and filter
           Row(
             children: [
               Expanded(
                 child:
                 GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchScreen(
        
        ),
      ),
    );
  },
  child: AbsorbPointer(
    child: SearchBarWidget(
      onSearch: (_) {},
    ),
  ),
)
                //   SearchBarWidget(
                //    onSearch: _onSearchHub,
                //  ),
               ),
               const SizedBox(width: 8),

               // Filter button
              GestureDetector(
                 onTap: _openFilters,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: CommonColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      CommonImagePath.filterwhite,
                      width: 20,
                      height: 20,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
             ],
           ),

           const SizedBox(height: 10),

           // Row 4: All / HyCharge / Partner tabs
           Consumer<HubProvider>(
             builder: (_, provider, __) {
               return Container(
                 padding: const EdgeInsets.all(4),
                 decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.circular(28),
                 ),
                 child: Row(
                   children: [
                     Expanded(
                       child: _tab(
                         title: 'All',
                         selected: provider.selectedTab == HubTab.All,
                         onTap: () {
                           provider.changeTab(HubTab.All);
                         },
                       ),
                     ),
                     Expanded(
                       child: _tab(
                         title: 'HyCharge',
                         selected:
                             provider.selectedTab == HubTab.HyCharge,
                         onTap: () {
                           provider.changeTab(HubTab.HyCharge);
                         },
                       ),
                     ),
                     Expanded(
                       child: _tab(
                         title: 'Partner',
                         selected:
                             provider.selectedTab == HubTab.Partner,
                         onTap: () {
                           provider.changeTab(HubTab.Partner);
                         },
                       ),
                     ),
                   ],
                 ),
               );
             },
           ),
         ],
       ),
     ),
   ),
 ),

//                Positioned(
//   top: 10,
//   left: 20,

//   child: Row(
//     mainAxisAlignment: MainAxisAlignment.start,
//     children: [
//       /// 🔍 SEARCH BAR (takes full remaining width)
//     Consumer<VehicleProvider>(
//   builder: (context, vehicleProvider, child) {
   
//     if (vehicleProvider.evModels.isEmpty ||
//         vehicleProvider.userVehicles.isEmpty) {
//       return const SizedBox();
//     }

//     final vehicle = vehicleProvider.defaultVehicle;

//     if (vehicle == null) {
//       return const SizedBox();
//     }

//     final modelName = vehicleProvider.getModelName(
//       vehicle.carModelID,
//     );

//     return GestureDetector(
//       onTap: ()
//       {
//          showMyVehiclesBottomSheet(
//         routeGlobalKey.currentContext!, 
        
//       );
//       },
//       child: Container(
//         padding: EdgeInsets.only(left: 8,right: 8),
//         decoration: BoxDecoration(color: CommonColors.greyText,
//         borderRadius: BorderRadius.all(Radius.circular(10))),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                Text(modelName?? "",    style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                   ),),
             
//                 Text(
//                "${vehicle?.carRegistrationNumber ?? ""} ",
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//             Icon(Icons.arrow_drop_down,color: CommonColors.white,)
//           ],
          
//         ),
//       ),
//     );
//   },
// ),
//     ])),
//               Positioned(
//   top: 10,
//   left: 20,
//   right: 20,
//   child: Row(
//     mainAxisAlignment: MainAxisAlignment.end,
//     children: [
//       /// 🔍 SEARCH BAR (takes full remaining width)
//       Text("UAT",style: TextStyle(color: CommonColors.background,fontSize: 14,fontWeight: FontWeight.bold),),
//     ])),
// Positioned(
//   top: 60,
//   left: 20,
//   right: 20,
//   child: Consumer<HubProvider>(
//     builder: (_, provider, __) {
//       return Row(
//         children: [

//           _tab(
//             title: "All",
//             selected: provider.selectedTab == HubTab.All,
//             onTap: () {
//               provider.changeTab(HubTab.All);
//             },
//           ),

//           const SizedBox(width: 10),

//           _tab(
//             title: "HyCharge",
//             selected: provider.selectedTab == HubTab.HyCharge,
//             onTap: () {
//               provider.changeTab(HubTab.HyCharge);
//             },
//           ),

//           const SizedBox(width: 10),

//           _tab(
//             title: "Partner",
//             selected: provider.selectedTab == HubTab.Partner,
//             onTap: () {
//               provider.changeTab(HubTab.Partner);
//             },
//           ),
//         ],
//       );
//     },
//   ),
// ),
//               /// Search
//               Positioned(
//                 top: 100,
//   // top: 60,
//   left: 20,
//   right: 20,
//   child: Row(
//     children: [
//       /// 🔍 SEARCH BAR (takes full remaining width)
//       Expanded(
//         child: SearchBarWidget(
//           onSearch: _onSearchHub,
//         ),
//       ),

      
//     ],
//   ),
// ),
            

              /// GPS Button
              Positioned(
                bottom: 210,
                  // top: 140,
                // top: 120,
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
                  if(sessionProvider.loading)
                  {
                    return const SizedBox.shrink();
                  }
                  if (
                      sessionProvider.sessions.length==0 && sessionProvider.partnerSessions.length==0) {
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
                            builder: (_) => ActiveSessionsScreen(
                              
                              selectedTabIndex: 
                              sessionProvider.partnerSessions.length>0?1:0),
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
                    : 
                     Positioned(
                        bottom: 40,
                        left: 0,
                        right: 0,
                        child: StationCardWidget(filters: appliedFilters,),
                      ),
            ],
          ),
        );
      },
    );
  }

  Widget _gpsButton() {
    return Container(
      padding: EdgeInsets.all(9),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 4),
        ],
      ),
      child: 
      GestureDetector(
        onTap: ()
        {
            context.read<HubProvider>().showCurrentLocationMarker();
        },
        child: SvgPicture.asset(CommonImagePath.currentloc,width: 22,height: 22,))
      // IconButton(
      //   icon: const Icon(Icons.gps_fixed, color: Colors.black),
      //   onPressed: () {
      //     context.read<HubProvider>().showCurrentLocationMarker();
      //     // moveToCurrentLocation();
      //   },
      // ),
    );
  }
  Widget _tab({
  required String title,
  required bool selected,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: selected
            ? CommonColors.primary:Colors.white
            ,
        borderRadius: BorderRadius.circular(20),
        // border: Border.all(
        //   color: selected? Colors.white:CommonColors.primary,
        // ),
      ),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 13,
            color: selected
                ? 
                 Colors.white:CommonColors.primary,
          ),
        ),
      ),
    ),
  );
}
void _onSearchHub(String value) async {
  if (value.trim().isEmpty) return;

  // final result =
  //     await context.read<HubProvider>().searchAndFocusHub(value);
final result =
    await context.read<HubProvider>().searchUnifiedHub(value);
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

}
