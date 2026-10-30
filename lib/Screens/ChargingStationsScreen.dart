
import 'package:HyCharge/Provider/charging_hub_provider.dart';
import 'package:HyCharge/Screens/Controller/map_controller.dart';
import 'package:HyCharge/Screens/Controller/station_card_widget.dart';
import 'package:HyCharge/Screens/MainTab.dart';
import 'package:HyCharge/Screens/SearchScreen.dart';
import 'package:HyCharge/Screens/StationDetailsScreen.dart';
import 'package:HyCharge/Utils/CommonAppBar.dart';
import 'package:HyCharge/Utils/InternetConnection.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/Utils/commonimages.dart';
import 'package:HyCharge/Utils/commonstrings.dart';
import 'package:HyCharge/Utils/googleMap.dart';
import 'package:HyCharge/Utils/sizeConfig.dart';
import 'package:HyCharge/main.dart';
import 'package:HyCharge/widget/GlobalLists.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../Utils/LocationConvert.dart';
import '../Utils/iconresizer.dart';

class ChargingStationsScreen extends StatefulWidget {
  const ChargingStationsScreen({super.key});

  @override
  State<ChargingStationsScreen> createState() => _ChargingStationsScreenState();
}

class _ChargingStationsScreenState extends State<ChargingStationsScreen> {
  final ScrollController _scrollController = ScrollController();

final TextEditingController _searchController = TextEditingController();

String _searchQuery = '';
bool _sortByDistance = false;


bool _isGettingLocation = false;

double? _distanceForHub(dynamic hub) {
  final current = _currentPosition;

  if (current == null) return null;

  final LatLng? stationLocation =
      LocationConvert.getLatLngFromUnifiedHub(hub);

  if (stationLocation == null) return null;

  final distanceInMeters = Geolocator.distanceBetween(
    current.latitude,
    current.longitude,
    stationLocation.latitude,
    stationLocation.longitude,
  );

  return distanceInMeters / 1000.0;
}

// double? _distanceForHub(dynamic hub) {
//   final current = _currentPosition;
//   final location = LocationConvert.getLatLngFromUnifiedHub(hub);

//   if (current == null || location == null) return null;

//   return Geolocator.distanceBetween(
//         current.latitude,
//         current.longitude,
//         location.latitude,
//         location.longitude,
//       ) /
//       1000;
// }

// List<dynamic> _getVisibleHubs(List<dynamic> hubs) {
//   final query = _searchQuery.trim().toLowerCase();

//   final result = hubs.where((hub) {
//     final name = (hub.name ?? '').toString().toLowerCase();
//     return name.contains(query);
//   }).toList();

//   if (_sortByDistance) {
//     result.sort((a, b) {
//       final distanceA = _distanceForHub(a);
//       final distanceB = _distanceForHub(b);

//       if (distanceA == null && distanceB == null) return 0;
//       if (distanceA == null) return 1;
//       if (distanceB == null) return -1;

//       return distanceA.compareTo(distanceB);
//     });
//   }

//   return result;
// }

List<dynamic> _getVisibleHubs(List<dynamic> hubs) {
  final query = _searchQuery.trim().toLowerCase();

  // Apply search first.
  final result = hubs.where((hub) {
    final name = (hub.name ?? '').toString().toLowerCase();
    return name.contains(query);
  }).toList();

  // Sort by actual distance from the current location.
  if (_sortByDistance && _currentPosition != null) {
    result.sort((a, b) {
      final distanceA = _distanceForHub(a);
      final distanceB = _distanceForHub(b);

      // Stations without coordinates appear last.
      if (distanceA == null && distanceB == null) return 0;
      if (distanceA == null) return 1;
      if (distanceB == null) return -1;

      // Nearest station first.
      return distanceA.compareTo(distanceB);
    });
  }

  return result;
}

@override
void dispose() {
  _searchController.dispose();
  _scrollController.dispose();
  super.dispose();
}

bool  hasInternet=false;
  @override
  void initState() {
    super.initState();
    resetPaginationBlock();
    
  }
  resetPaginationBlock() async {
  final result = await hasInternetConnection();

  setState(() {
    hasInternet = result;
  });

  if (hasInternet) {
    final provider = context.read<ChargingHubProvider>();
    provider.resetPagination();
    _scrollController.addListener(_onScroll);
    _fetchCurrentLocation();
  }
}


void _onScroll() async {
  final provider = context.read<ChargingHubProvider>();

  if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 150 &&
      !provider.loadingMore &&
      !provider.loading &&
      provider.hasMore) {
    final hasInternet = await hasInternetConnection();

    if (hasInternet) {
      provider.loadChargingHubs(context);
    }
  }
}
  Widget _filter24hourChip(dynamic hub) {
    return   (hub.id==CommonStrings.strDummyRecID ||  hub.id ==CommonStrings.strDummyRecID1)?
     Container(
      
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
         color: CommonColors.red.withOpacity(0.15),
        border: Border.all(
          color: CommonColors.brownRed.withOpacity(0.15), // choose your color here
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Restricted",
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w400,color: CommonColors.brownRed),
          ),
        ],
      ),
     )
    :Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Color(0xFFD7F9DE),
        // border: Border.all(
        //   color: CommonColors.darkgreen
        //       .withOpacity(0.15), // choose your color here
        //   width: 1.5,
        // ),
        borderRadius: BorderRadius.circular(24),
       ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(CommonImagePath.clock_green,width: 14,height: 14,),
          SizedBox(width: 5,),
          Text(
            "24 hrs Available",
            style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: CommonColors.darkgreen),
          ),
        ],
      ),
    );
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: CommonColors.neutral50,
    appBar: CommonAppBar(
      title: "Charging Hubs",
      onBack: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MainTab(
              isLoggedIn: GlobalLists.islLogin,
            ),
          ),
        );
      },
    ),
    body: Consumer<ChargingHubProvider>(
      builder: (context, provider, _) {
        final hubs = _getVisibleHubs(provider.filteredHubs);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted &&
              provider.hubs.isEmpty &&
              !provider.loading &&
              hasInternet) {
            provider.pageNumber = 1;
            provider.loadChargingHubs(context);
          }
        });

        if (provider.loading && provider.hubs.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Column(
          children: [
            // Search and distance sorting
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: ()
                      {
                          Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchScreen(
        
        ),
      ),
    );
                      },
                      child: AbsorbPointer(
                        child: SizedBox(
                          height: 42,
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                              });
                            },
                            style: const TextStyle(
                              fontSize: 13,
                              color: CommonColors.primary,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search hubs',
                              hintStyle: const TextStyle(
                                fontSize: 13,
                                color: CommonColors.neutral500,
                              ),
                              prefixIcon: const Icon(
                                Icons.search,
                                size: 19,
                                color: CommonColors.neutral500,
                              ),
                              suffixIcon: _searchQuery.isNotEmpty
                                  ? IconButton(
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() {
                                          _searchQuery = '';
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.close,
                                        size: 17,
                                      ),
                                    )
                                  : null,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 10),
                              filled: true,
                              fillColor: CommonColors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: const BorderSide(
                                  color: CommonColors.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 42,
                    child: 

OutlinedButton(
  onPressed: () async {
    if (!_sortByDistance) {
      // Get the user's location before sorting.
      if (_currentPosition == null) {
        await _fetchCurrentLocation();
      }

      if (!mounted) return;

      if (_currentPosition == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Unable to get your location. Please enable location access.',
            ),
          ),
        );
        return;
      }
    }

    setState(() {
      _sortByDistance = !_sortByDistance;
    });
  },
  style: OutlinedButton.styleFrom(
    foregroundColor: CommonColors.primary,
    backgroundColor: CommonColors.background,
    side: const BorderSide(
      color: CommonColors.hintGrey,
      width: 0.3,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12),
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        _sortByDistance
            ? Icons.location_on_rounded
            : Icons.swap_vert_rounded,
        size: 15,
        color: CommonColors.blacklight,
      ),
      const SizedBox(width: 4),
      Text(
        _sortByDistance
            ? 'Distance: Near first'
            : 'Sort by distance',
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: CommonColors.blacklight,
        ),
      ),
    ],
  ),
)

                    // OutlinedButton(
                    //   onPressed: () {
                    //     setState(() {
                    //       _sortByDistance = !_sortByDistance;
                    //     });
                    //   },
                    //   style: OutlinedButton.styleFrom(
                    //     foregroundColor: CommonColors.primary,
                    //     backgroundColor: CommonColors.background,
                    //     side: const BorderSide(
                    //       color: CommonColors.hintGrey,
                    //       width: 0.3,
                    //     ),
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(24),
                    //     ),
                    //     padding: const EdgeInsets.symmetric(
                    //       horizontal: 12,
                    //     ),
                    //   ),
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.min,
                    //     children: [
                    //       Text(
                    //         _sortByDistance
                    //             ? 'Distance: Near first'
                    //             : 'Sort by distance',
                    //         style:  TextStyle(
                    //           fontSize: 10,
                    //           fontWeight: FontWeight.w400,
                    //           color: CommonColors.blacklight
                    //         ),
                    //       ),
                         
                    //     ],
                    //   ),
                    // ),
                  ),
                ],
              ),
            ),

            // Charging hub cards
            Expanded(
              child: hubs.isEmpty
                  ? Center(
                      child: Text(
                        _searchQuery.isNotEmpty
                            ? 'No matching charging hubs found'
                            : 'No charging hubs found',
                        style: const TextStyle(
                          color: CommonColors.neutral500,
                          fontSize: 14,
                        ),
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.only(
                        top: 2,
                        bottom: 16,
                      ),
                      itemCount: hubs.length +
                          (provider.loadingMore &&
                                  _searchQuery.isEmpty
                              ? 1
                              : 0),
                      itemBuilder: (context, index) {
                        if (index == hubs.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        return _stationBottomCard(hubs[index], hubs);
                      },
                    ),
            ),
          ],
        );
      },
    ),
  );
}

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: CommonColors.neutral50,
//       appBar: CommonAppBar(
//         title: "Charging Hubs",
//         onBack: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => MainTab(isLoggedIn: GlobalLists.islLogin),
//             ),
//           );
//         },
//       ),
//       body: Consumer<ChargingHubProvider>(
//         builder: (context, provider, _) {
//             final list = provider.filteredHubs;
//           /// FIRST LOAD
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             if (provider.hubs.isEmpty && !provider.loading && hasInternet) {
//               provider.pageNumber = 1;
//               provider.loadChargingHubs(context);
//             }
//           });

//         if (provider.loading && provider.hubs.isEmpty) {
//   return const Center(
//     child: CircularProgressIndicator(),
//   );
// }


//           return Column(
//             children: [
             
//             (!provider.loading && provider.filteredHubs.isEmpty) ? Expanded(
//     child: Center(
//       child: Text(
//         'No charging hubs found',
//         style: TextStyle(color: Colors.grey),
//       ),
//     ),
//   ):   Expanded(
//                 child: ListView.builder(
//                   controller: _scrollController,
                

// itemCount: list.length + (provider.loadingMore ? 1 : 0),

// itemBuilder: (context, index) {
//   if (index == list.length) {
//     return const Padding(
//       padding: EdgeInsets.all(16),
//       child: Center(child: CircularProgressIndicator()),
//     );
//   }

//   final hub = list[index];
//   return _stationBottomCard(hub,list);
// },
               
//                 ),
//               ),
//               SizedBox(height: 20,)
//             ],
//           );
//         },
//       ),
//     );
//   }

  // ---------------- Station Card ----------------
   Position? _currentPosition;
  //   void _fetchCurrentLocation() async {
  //   Position? position = await MapController().getCurrentPosition();
  //   if (position != null) {
  //     setState(() {
  //       _currentPosition = position;
  //     });
  //     // print(
  //     //     "Current Location: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}");
  //   }
  // }

Future<void> _fetchCurrentLocation() async {
  if (_isGettingLocation) return;

  _isGettingLocation = true;

  try {
    final Position? position =
        await MapController().getCurrentPosition();

    if (!mounted) return;

    setState(() {
      _currentPosition = position;
    });
  } catch (e) {
    debugPrint('Unable to get current location: $e');
  } finally {
    _isGettingLocation = false;
  }
}

  double distance=0.0;

Widget _stationBottomCard(dynamic hub, List<dynamic> nearbyHubs) {
  final location = LocationConvert.getLatLngFromUnifiedHub(hub);
  final distance = _distanceForHub(hub);
  final rating = hub.averageRating;

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
    child: Material(
      color: CommonColors.white,
      borderRadius: BorderRadius.circular(22),
      elevation: 1.5,
      shadowColor: Colors.black.withOpacity(0.06),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () async {
          if (location == null) return;

          final activeMarkerIcon = await getResizedMarker(
            'assets/images/targetMarker.png',
            width: 125,
          );

          if (!mounted) return;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StationDetailsScreen(
                nearbyHubs: nearbyHubs,
                hub: hub,
                marker: Marker(
                  markerId: MarkerId(hub.id.toString()),
                  position: location,
                  icon: activeMarkerIcon ??
                      BitmapDescriptor.defaultMarker,
                ),
                location: location,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  CommonImagePath.stationImage,
                  width: 62,
                  height: 68,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hub.name ?? 'Unnamed Station',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: CommonColors.black,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Wrap(
                      spacing: 9,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                               CommonImagePath.locationred,
                                height: 13,
                                width: 13,
                                color: CommonColors.black.withOpacity(0.5),
                              ),
                            const SizedBox(width: 3),
                            Text(
                              distance == null
                                  ? '-- KM'
                                  : '${distance.toStringAsFixed(2)} KM',
                              style: const TextStyle(
                                fontSize: 10,
                                color: CommonColors.neutral500,
                              ),
                            ),
                          ],
                        ),

                        if (rating != null)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                               CommonImagePath.stargold,
                                height: 13,
                                width: 13,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                rating.toStringAsFixed(0),
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: CommonColors.neutral500,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),

                    const SizedBox(height: 7),

                    _filter24hourChip(hub),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Material(
                color: const Color(0xFFEAF0FC),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {
                    if (location == null) return;

                    openMaps(
                      latitude: location.latitude,
                      longitude: location.longitude,
                    );
                  },
                  child: SizedBox(
                    width: 42,
                    height: 42,
                    child: Center(
                      child:  Icon(
                            Icons.near_me_outlined,
                            color: CommonColors.blue,
                            size: 20,
                          ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

//   Widget _stationBottomCard(dynamic hub,List<dynamic> nearbyHubs) {
  
//     final opening = "";
//     //hub.openingTime ?? 'N/A';
//     final closing = "";
//     // hub.closingTime ?? 'N/A';
  

//     LatLng? location = LocationConvert.getLatLngFromUnifiedHub(hub);
//  if (_currentPosition != null) {
//        distance  = Geolocator.distanceBetween(
//               _currentPosition!.latitude,
//               _currentPosition!.longitude,
//             location!.latitude,
//               location!.longitude) /
//           1000;
//     }
//     return GestureDetector(
//       onTap: () async {
//         LatLng? location = LocationConvert.getLatLngFromUnifiedHub(hub);
//         if (location != null) {
//           BitmapDescriptor?  activeMarkerIcon = await getResizedMarker(
//             'assets/images/targetMarker.png',
//             width: 125,
//           );
//           Navigator.push(
//             routeGlobalKey.currentContext!,
//             MaterialPageRoute(builder: (_) => StationDetailsScreen(
//               nearbyHubs: nearbyHubs,
//               hub: hub,
//               marker: Marker(
//                 markerId: MarkerId(hub.id),
//                 position: location,
//                 icon: activeMarkerIcon,
//               )
//               ,location: location,)),
//           );
//         }
       
//       },
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//         child: Container(
//           padding: const EdgeInsets.all(10),
//           // height: 170,
//           decoration: BoxDecoration(
//             color: CommonColors.white,
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // TOP
//               Container(
//                 decoration: BoxDecoration(
//                   color: CommonColors.neutral50,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 padding: const EdgeInsets.all(4),
//                 child: Row(
//                   children: [
//     //                  hub.chargingHubImage != null
//     // ? HubImage(
//     //     imageId: hub.chargingHubImage!,
//     //     height: SizeConfig.blockSizeVertical * 5,
//     //     width: SizeConfig.blockSizeVertical * 5,
//     //   )
//     // : 
//     // Image.asset(
//     //     CommonImagePath.frame,
//     //     height: SizeConfig.blockSizeVertical * 6,
//     //   ),
//      ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child: Image.asset(
//                     CommonImagePath.stationImage,
//                     height: 68,
//                     width: 68,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                     // Image.asset(CommonImagePath.frame, height: 50),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   hub.name ?? 'Unnamed Station',
//                                   style: const TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w600,
//                                     color: CommonColors.primary,
//                                   ),
//                                 ),
//                               ),
//                               // const Icon(Icons.more_vert,
//                               //     color: CommonColors.blue),
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               _infoTag(
//                                   CommonImagePath.redpin,
//                                   distance != null
//                                       ? "${distance.toStringAsFixed(2)} KM"
//                                       : "N/A"),
//                               const SizedBox(width: 4),
//                               _infoTag(
//                                   CommonImagePath.star,
//                               hub.averageRating==null?"":      hub.averageRating.toStringAsFixed(0) ?? 0.0
//                                   ),
//                               const SizedBox(width: 4),
//                               // _infoTag(
//                               //     CommonImagePath.clock, "$opening - $closing"),
//                               //      const SizedBox(width: 4),
//                               // Image.asset(  CommonImagePath.clock),
//                                const SizedBox(width: 2),
//                                    _filter24hourChip(hub)
                                  
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 8),

//               // Amenities
//               // Text(
//               //   hub.amenities ?? "",
//               //   maxLines: 2,
//               //   overflow: TextOverflow.ellipsis,
//               //   style: const TextStyle(
//               //       fontSize: 12, color: CommonColors.neutral500),
//               // ),
// ExpandableText(
//   text: "",
//   // hub.amenities ?? "",
//   trimLines: 2,
//   style: const TextStyle(
//     fontSize: 10,
//     color: CommonColors.neutral500,
//   ),
// ),

//               const SizedBox(height: 14),

//               // Pricing
//               Row(
//                 children: [
//                   // _typeInfo("Station A", "₹${hub.typeATariff ?? '--'} / kWh"),
//                   // const SizedBox(width: 20),
//                   // Expanded(
//                   //     child: _typeInfo(
//                   //         "Station B", "₹${hub.typeBTariff ?? '--'} / kWh")),
//                   GestureDetector(
//                     onTap: ()
//                     {
//                      LatLng? location =
//                               LocationConvert.getLatLngFromUnifiedHub(hub);
//                           print(location!.latitude);
//                           print(location!.longitude);
//                           openMaps(
//                             latitude: location.latitude,
//                             longitude: location.longitude,
//                           );
//                     },
//                     child: SvgPicture.asset(CommonImagePath.direction)),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

  Widget _infoTag(String icon, String text) {
    return Row(
      children: [
        Image.asset(icon, height: 14),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 10)),
      ],
    );
  }

  Widget _typeInfo(String type, String price) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(type,
            style:
                const TextStyle(fontSize: 14, color: CommonColors.neutral500)),
        const SizedBox(height: 2),
        Text(
          price,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: CommonColors.primary,
          ),
        ),
      ],
    );
  }
}
class ExpandableText extends StatefulWidget {
  final String text;
  final int trimLines;
  final TextStyle? style;

  const ExpandableText({
    super.key,
    required this.text,
    this.trimLines = 2,
    this.style,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textSpan = TextSpan(text: widget.text, style: widget.style);
        final tp = TextPainter(
          text: textSpan,
          maxLines: widget.trimLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        final isOverflowing = tp.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: Text(
                widget.text,
                style: widget.style,
                maxLines: _expanded ? null : widget.trimLines,
                overflow:
                    _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
              ),
            ),
            if (isOverflowing)
              GestureDetector(
                onTap: () {
                  setState(() => _expanded = !_expanded);
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    _expanded ? "Read less" : "Read more",
                    style: const TextStyle(
                      fontSize: 12,
                      color: CommonColors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
