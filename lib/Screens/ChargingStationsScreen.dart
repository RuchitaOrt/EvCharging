// import 'package:ev_charging_app/Screens/StationDetailsScreen.dart';
// import 'package:ev_charging_app/Utils/CommonAppBar.dart';
// import 'package:ev_charging_app/Utils/commoncolors.dart';
// import 'package:ev_charging_app/Utils/commonimages.dart';
// import 'package:ev_charging_app/Utils/sizeConfig.dart';
// import 'package:ev_charging_app/main.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// import 'MapStationCardScreen.dart';
// class StationModel {
//   final String name;
//   final String distance;
//   final String rating;
//   final String time;
//   final String typeA;
//   final String typeB;

//   StationModel({
//     required this.name,
//     required this.distance,
//     required this.rating,
//     required this.time,
//     required this.typeA,
//     required this.typeB,
//   });
// }

// class ChargingStationsScreen extends StatelessWidget {
  
//    ChargingStationsScreen({super.key});
//   List<StationModel> stationList = [
//   StationModel(
//     name: "Hitech EV",
//     distance: "4.8 KM",
//     rating: "4.5",
//     time: "9:00AM - 12:00PM",
//     typeA: "₹12.99 / kWh",
//     typeB: "₹12.99 / kWh",
//   ),
//   StationModel(
//     name: "IOC Madinaguda",
//     distance: "4.8 KM",
//     rating: "4.5",
//     time: "9:00AM - 12:00PM",
//     typeA: "₹12.99 / kWh",
//     typeB: "₹12.99 / kWh",
//   ),
//   StationModel(
//     name: "Galleria Mall | Panjagutta",
//     distance: "4.8 KM",
//     rating: "4.5",
//     time: "9:00AM - 12:00PM",
//     typeA: "₹12.99 / kWh",
//     typeB: "₹12.99 / kWh",
//   ),
// ];

//   Widget _searchBar() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       height: 48,
//       decoration: BoxDecoration(
//       color: CommonColors.neutral50,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: CommonColors.hintGrey, // choose your color here
//           width: 0.3,
//         ),
//         // boxShadow: [
//         //   BoxShadow(color: Colors.black12, blurRadius: 8),
//         // ],
//       ),
//       child: Row(
//         children: [
//           Icon(
//             Icons.search,
//             color: CommonColors.hintGrey,
//           ),
//           SizedBox(width: 12),
//           Expanded(
//               child: Text(
//             "Search station",
//             style: TextStyle(color: CommonColors.hintGrey),
//           )),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: CommonColors.neutral50,
      
//       appBar:
//       CommonAppBar(title: "Charging Stations",),
     
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: ListView(
//           shrinkWrap: true,
//           physics: ScrollPhysics(),
//           children: [
//              Padding(
//                padding: const EdgeInsets.symmetric(horizontal: 10),
//                child: Row(
//                            children: [
//                 SizedBox(
//                   width: SizeConfig.blockSizeHorizontal*73,
//                   child: _searchBar()),
//                   SizedBox(width: 10,),
//                 Image.asset(CommonImagePath.filter)
//                            ],
//                          ),
//              ),
//           Expanded(
//   child: ListView.builder(
//     itemCount: stationList.length,
//     itemBuilder: (context, index) {
//       return _stationBottomCard(stationList[index]);
//     },
//   ),
// )

//           ],
//         ),
//       ),
//     );
//   }

// Widget _stationBottomCard(StationModel station) {
//   return GestureDetector(
//     onTap: () {
//       Navigator.push(
//         routeGlobalKey.currentContext!,
//         MaterialPageRoute(builder: (context) => StationDetailsScreen()),
//       );
//     },
//     child: SizedBox(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Container(
//           padding: const EdgeInsets.all(8),
//           height: 160,
//           decoration: BoxDecoration(
//             color: CommonColors.white,
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // TOP ROW with Image, Title, More Menu
//               Container(
//                 decoration: BoxDecoration(
//                   color: CommonColors.neutral50,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 padding: const EdgeInsets.all(2),
//                 child: Row(
//                   children: [
//                     Image.asset(
//                       CommonImagePath.frame,
//                       height: 70,
//                       fit: BoxFit.cover,
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   station.name,
//                                   style: const TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w600,
//                                     color: CommonColors.primary,
//                                   ),
//                                 ),
//                               ),
//                               const Icon(Icons.more_vert,
//                                   color: CommonColors.blue),
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               _infoTag(CommonImagePath.redpin, station.distance),
//                               const SizedBox(width: 4),
//                               _infoTag(CommonImagePath.star, station.rating),
//                               const SizedBox(width: 4),
//                               _infoTag(CommonImagePath.clock, station.time),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 8),

//               // FEATURES ROW
//               Row(
//                 children: [
//                   Text("4 Plugs", style: TextStyle(fontSize: 12, color: CommonColors.neutral500)),
//                   const SizedBox(width: 6),
//                   circularDot(CommonColors.blue, 5),
//                   const SizedBox(width: 4),
//                   Text("Wifi", style: TextStyle(fontSize: 12, color: CommonColors.neutral500)),
//                   const SizedBox(width: 6),
//                   circularDot(CommonColors.blue, 5),
//                   const SizedBox(width: 4),
//                   Text("Cafe", style: TextStyle(fontSize: 12, color: CommonColors.neutral500)),
//                   const SizedBox(width: 6),
//                   circularDot(CommonColors.blue, 5),
//                   const SizedBox(width: 4),
//                   Text("Restaurant", style: TextStyle(fontSize: 12, color: CommonColors.neutral500)),
//                 ],
//               ),

//               const SizedBox(height: 6),

//               Row(
//                 children: [
//                   _typeInfo("Type A", station.typeA),
//                   const SizedBox(width: 20),
//                   Expanded(child: _typeInfo("Type B", station.typeB)),
//                   SvgPicture.asset(CommonImagePath.direction),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }


//   Widget _infoTag(String icon, String text) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 4, horizontal: 3),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(4),
//       ),
//       child: Row(
//         children: [
//           Image.asset(icon, height: 14),
//           SizedBox(width: 4),
//           Text(text, style: TextStyle(fontSize: 12)),
//         ],
//       ),
//     );
//   }

//   Widget _typeInfo(String type, String price) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(type,
//             style: TextStyle(fontSize: 14, color: CommonColors.neutral500)),
//             SizedBox(height: 2),
//         Text(price,
//             style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: CommonColors.primary)),
//       ],
//     );
//   }
// }

// Widget circularDot(Color color, double size) {
//   return Container(
//     width: size,
//     height: size,
//     decoration: BoxDecoration(
//       color: color,
//       shape: BoxShape.circle,
//     ),
//   );
// }
import 'package:ev_charging_app/Screens/MainTab.dart';
import 'package:ev_charging_app/Screens/StationDetailsScreen.dart';
import 'package:ev_charging_app/Utils/CommonAppBar.dart';
import 'package:ev_charging_app/Utils/commoncolors.dart';
import 'package:ev_charging_app/Utils/commonimages.dart';
import 'package:ev_charging_app/Utils/sizeConfig.dart';
import 'package:ev_charging_app/main.dart';
import 'package:ev_charging_app/widget/GlobalLists.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../Provider/HubProvider.dart';

class ChargingStationsScreen extends StatelessWidget {
  const ChargingStationsScreen({super.key});

  // ---------------- Search Bar ----------------
  Widget _searchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 48,
      decoration: BoxDecoration(
        color: CommonColors.neutral50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CommonColors.hintGrey,
          width: 0.3,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: CommonColors.hintGrey),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Search station",
              style: TextStyle(color: CommonColors.hintGrey),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to format time
  String _formatTime(String? time) {
    if (time == null || time.isEmpty) return "N/A";

    try {
      final parts = time.split(':');
      if (parts.length >= 2) {
        final hour = int.tryParse(parts[0]) ?? 0;
        final minute = parts[1];
        final period = hour >= 12 ? 'PM' : 'AM';
        final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
        return '$displayHour:$minute $period';
      }
      return time;
    } catch (e) {
      return time;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColors.neutral50,
      appBar: CommonAppBar(
        title: "Charging Stations",
        onBack: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainTab(isLoggedIn: GlobalLists.islLogin),
            ),
          );
        },
      ),
      body: Consumer<HubProvider>(
        builder: (context, provider, child) {
          // Load data when screen is first built
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (provider.recordsStation.isEmpty && !provider.loading) {
              provider.loadHubs(context, reset: true);
            }
          });
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Search bar + Filter
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      SizedBox(
                        width: SizeConfig.blockSizeHorizontal * 73,
                        child: _searchBar(),
                      ),
                      SizedBox(width: 10),
                      Image.asset(CommonImagePath.filter, height: 40),
                    ],
                  ),
                ),
                SizedBox(height: 8),

                // Main content area
                Expanded(
                  child: _buildMainContent(context, provider),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper method to build the main content
  Widget _buildMainContent(BuildContext context, HubProvider provider) {
    // Show loading
    if (provider.loading && provider.recordsStation.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    // Show empty state
    if (provider.recordsStation.isEmpty && !provider.loading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No charging stations found',
              style: TextStyle(
                color: CommonColors.neutral500,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                provider.loadHubs(context, reset: true);
              },
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Show stations list
    return RefreshIndicator(
      onRefresh: () async {
        await provider.loadHubs(context, reset: true);
      },
      child: ListView.builder(
        itemCount: provider.recordsStation.length,
        itemBuilder: (context, index) {
          final hub = provider.recordsStation[index];
          return _stationCard(hub);
        },
      ),
    );
  }

  // ---------------- Station Card ----------------
  Widget _stationCard(dynamic hub) {
    // Parse data from API
    final openingTime = _formatTime(hub.openingTime);
    final closingTime = _formatTime(hub.closingTime);
    final hours = '$openingTime - $closingTime';

    final distance = hub.distanceKm != null
        ? '${hub.distanceKm} KM'
        : 'N/A';

    final rating = hub.averageRating?.toString() ?? '4.5';

    final typeAPrice = hub.typeATariff?.isNotEmpty == true
        ? '₹${hub.typeATariff} / kWh'
        : '₹12.99 / kWh';

    final typeBPrice = hub.typeBTariff?.isNotEmpty == true
        ? '₹${hub.typeBTariff} / kWh'
        : '₹12.99 / kWh';

    // Parse amenities
    final amenitiesStr = hub.amenities?.toString() ?? '';
    final amenitiesList = amenitiesStr.isNotEmpty
        ? amenitiesStr.split(',').map((a) => a.trim()).where((a) => a.isNotEmpty).toList()
        : [];

    return GestureDetector(
      onTap: () {
         Navigator.push(
          routeGlobalKey.currentContext!,
          MaterialPageRoute(
            builder: (context) => StationDetailsScreen(
           /*   hubId: hub.recId,
              hubName: hub.chargingHubName,*/
            ),
          ),
        );
      },
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(8),
            height: 180,
            decoration: BoxDecoration(
              color: CommonColors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TOP ROW with Image, Title, More Menu
                Container(
                  decoration: BoxDecoration(
                    color: CommonColors.neutral50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(2),
                  child: Row(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: CommonColors.neutral50,
                          image: hub.chargingHubImage != null
                              ? DecorationImage(
                            image: NetworkImage(
                              'https://your-api-base-url/images/${hub.chargingHubImage}',
                            ),
                            fit: BoxFit.cover,
                          )
                              : DecorationImage(
                            image: AssetImage(CommonImagePath.frame),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    hub.chargingHubName ?? 'Unnamed Station',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: CommonColors.primary,
                                    ),
                                  ),
                                ),
                                const Icon(Icons.more_vert,
                                    color: CommonColors.blue),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                _infoTag(CommonImagePath.redpin, distance),
                                const SizedBox(width: 4),
                                _infoTag(CommonImagePath.star, rating),
                                const SizedBox(width: 4),
                                _infoTag(CommonImagePath.clock, hours),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // FEATURES ROW - Show amenities from API
                if (amenitiesList.isNotEmpty && amenitiesList.length >= 4)
                  Row(
                    children: [
                      for (int i = 0; i < 4 && i < amenitiesList.length; i++) ...[
                        if (i > 0) const SizedBox(width: 6),
                        Text(amenitiesList[i],
                            style: TextStyle(fontSize: 12, color: CommonColors.neutral500)),
                        if (i < 3 && i < amenitiesList.length - 1) ...[
                          const SizedBox(width: 6),
                          circularDot(CommonColors.blue, 5),
                        ]
                      ],
                      // Show "more" indicator if there are more amenities
                      if (amenitiesList.length > 4) ...[
                        const SizedBox(width: 6),
                        circularDot(CommonColors.blue, 5),
                        const SizedBox(width: 4),
                        Text("+${amenitiesList.length - 4} more",
                            style: TextStyle(fontSize: 12, color: CommonColors.neutral500)),
                      ]
                    ],
                  )
                else if (amenitiesList.isNotEmpty)
                  Row(
                    children: [
                      for (int i = 0; i < amenitiesList.length; i++) ...[
                        if (i > 0) const SizedBox(width: 6),
                        Text(amenitiesList[i],
                            style: TextStyle(fontSize: 12, color: CommonColors.neutral500)),
                        if (i < amenitiesList.length - 1) ...[
                          const SizedBox(width: 6),
                          circularDot(CommonColors.blue, 5),
                        ]
                      ]
                    ],
                  )
                else
                // Default amenities if none from API
                  Row(
                    children: [
                      Text("4 Plugs", style: TextStyle(fontSize: 12, color: CommonColors.neutral500)),
                      const SizedBox(width: 6),
                      circularDot(CommonColors.blue, 5),
                      const SizedBox(width: 4),
                      Text("Wifi", style: TextStyle(fontSize: 12, color: CommonColors.neutral500)),
                      const SizedBox(width: 6),
                      circularDot(CommonColors.blue, 5),
                      const SizedBox(width: 4),
                      Text("Cafe", style: TextStyle(fontSize: 12, color: CommonColors.neutral500)),
                      const SizedBox(width: 6),
                      circularDot(CommonColors.blue, 5),
                      const SizedBox(width: 4),
                      Text("Restaurant", style: TextStyle(fontSize: 12, color: CommonColors.neutral500)),
                    ],
                  ),

                const SizedBox(height: 6),

                // PRICING ROW
                Row(
                  children: [
                    _typeInfo("Type A", typeAPrice),
                    const SizedBox(width: 20),
                    Expanded(child: _typeInfo("Type B", typeBPrice)),
                    SvgPicture.asset(CommonImagePath.direction),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper methods
  Widget _infoTag(String icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Image.asset(icon, height: 14),
          SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _typeInfo(String type, String price) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(type,
            style: TextStyle(fontSize: 14, color: CommonColors.neutral500)),
        SizedBox(height: 2),
        Text(price,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: CommonColors.primary)),
      ],
    );
  }

  void _openDirections(double lat, double lng) {
    // TODO: Implement opening directions in Google Maps
    print('Open directions to: $lat, $lng');
  }
}

// Helper widget for circular dot
Widget circularDot(Color color, double size) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
    ),
  );
}