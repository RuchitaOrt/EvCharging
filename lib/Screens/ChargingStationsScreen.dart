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
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StationModel {
  final String name;
  final String distance;
  final String rating;
  final String time;
  final String typeA;
  final String typeB;

  StationModel({
    required this.name,
    required this.distance,
    required this.rating,
    required this.time,
    required this.typeA,
    required this.typeB,
  });
}

class ChargingStationsScreen extends StatelessWidget {
  ChargingStationsScreen({super.key});

  List<StationModel> stationList = [
    StationModel(
      name: "Hitech EV",
      distance: "4.8 KM",
      rating: "4.5",
      time: "9:00AM - 12:00PM",
      typeA: "₹12.99 / kWh",
      typeB: "₹12.99 / kWh",
    ),
    StationModel(
      name: "IOC Madinaguda",
      distance: "4.8 KM",
      rating: "4.5",
      time: "9:00AM - 12:00PM",
      typeA: "₹12.99 / kWh",
      typeB: "₹12.99 / kWh",
    ),
    StationModel(
      name: "Galleria Mall | Panjagutta",
      distance: "4.8 KM",
      rating: "4.5",
      time: "9:00AM - 12:00PM",
      typeA: "₹12.99 / kWh",
      typeB: "₹12.99 / kWh",
    ),
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColors.neutral50,
      appBar: CommonAppBar(title: "Charging Stations",
      onBack: ()  {
Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MainTab()),
      );
      }),

      // ---------------- Body -------------------

      body: Column(
        children: [
          // 🔎 Search bar + Filter icon
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Expanded(child: _searchBar()),
                SizedBox(width: 10),
                Image.asset(CommonImagePath.filter, height: 40),
              ],
            ),
          ),

          // 🔽 Scrollable List
          Expanded(
            child: ListView.builder(
              itemCount: stationList.length,
              itemBuilder: (context, index) {
                return _stationBottomCard(stationList[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- Station Card ----------------

  Widget _stationBottomCard(StationModel station) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          routeGlobalKey.currentContext!,
          MaterialPageRoute(builder: (context) => StationDetailsScreen()),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Container(
          padding: const EdgeInsets.all(10),
          height: 160,
          decoration: BoxDecoration(
            color: CommonColors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ----------- TOP (Image + Title) ------------
              Container(
                decoration: BoxDecoration(
                  color: CommonColors.neutral50,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    Image.asset(
                      CommonImagePath.frame,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 8),

                    // Title + tags
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  station.name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: CommonColors.primary,
                                  ),
                                ),
                              ),
                              Icon(Icons.more_vert, color: CommonColors.blue),
                            ],
                          ),

                          Row(
                            children: [
                              _infoTag(CommonImagePath.redpin, station.distance),
                              SizedBox(width: 4),
                              _infoTag(CommonImagePath.star, station.rating),
                              SizedBox(width: 4),
                              _infoTag(CommonImagePath.clock, station.time),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 8),

              // ----------- FEATURES ------------
              Row(
                children: [
                  Text("4 Plugs",
                      style: TextStyle(fontSize: 12, color: CommonColors.neutral500)),
                  SizedBox(width: 6),
                  circularDot(CommonColors.blue, 5),
                  SizedBox(width: 4),
                  Text("Wifi",
                      style: TextStyle(fontSize: 12, color: CommonColors.neutral500)),
                  SizedBox(width: 6),
                  circularDot(CommonColors.blue, 5),
                  SizedBox(width: 4),
                  Text("Cafe",
                      style: TextStyle(fontSize: 12, color: CommonColors.neutral500)),
                  SizedBox(width: 6),
                  circularDot(CommonColors.blue, 5),
                  SizedBox(width: 4),
                  Text("Restaurant",
                      style: TextStyle(fontSize: 12, color: CommonColors.neutral500)),
                ],
              ),

              SizedBox(height: 14),

              // ----------- charging types + direction icon -----------
              Row(
                children: [
                  _typeInfo("Type A", station.typeA),
                  SizedBox(width: 20),
                  Expanded(child: _typeInfo("Type B", station.typeB)),
                  SvgPicture.asset(CommonImagePath.direction),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- Helper Widgets ----------------

  Widget _infoTag(String icon, String text) {
    return Row(
      children: [
        Image.asset(icon, height: 14),
        SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _typeInfo(String type, String price) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(type, style: TextStyle(fontSize: 14, color: CommonColors.neutral500)),
        SizedBox(height: 2),
        Text(
          price,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: CommonColors.primary,
          ),
        ),
      ],
    );
  }

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
}
