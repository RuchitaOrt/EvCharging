import 'package:ev_charging_app/Screens/MapOverviewScreen.dart';
import 'package:ev_charging_app/Utils/CommonAppBar.dart';
import 'package:ev_charging_app/Utils/commoncolors.dart';
import 'package:ev_charging_app/Utils/commonimages.dart';
import 'package:ev_charging_app/Utils/sizeConfig.dart';
import 'package:ev_charging_app/main.dart';
import 'package:ev_charging_app/model/ChargingcomprehensiveHubResponse.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StationDetailsScreen extends StatelessWidget {
  final ChargingHub hub;

  StationDetailsScreen({
    super.key,
    required this.hub,
  });
  GoogleMapController? mapController;

  final LatLng center = const LatLng(17.4444, 78.3772);

  Set<Marker> markers = {
    Marker(
      markerId: MarkerId("station1"),
      position: LatLng(17.4444, 78.3772),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    ),
    Marker(
      markerId: MarkerId("station2"),
      position: LatLng(17.4500, 78.3800),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    )
  };

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: CommonColors.neutral200,
      appBar: CommonAppBar(
        title: "Station Details",
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // map placeholder
            Container(
              height: w * 0.5,
              decoration: BoxDecoration(
                color: CommonColors.mapDark,
                borderRadius: BorderRadius.circular(12),
              ),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(target: center, zoom: 13),
                onMapCreated: (controller) async {
                  mapController = controller;

                  String style = await DefaultAssetBundle.of(context)
                      .loadString('assets/map_styles/dark_map.json');

                  mapController!.setMapStyle(style);
                },
                markers: markers,
                zoomControlsEnabled: false,
              ),
            ),

            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: CommonColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: CommonColors.neutral50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          CommonImagePath.frame,
                          fit: BoxFit.cover,
                          height: SizeConfig.blockSizeVertical * 8,
                        ),
                        SizedBox(width: SizeConfig.blockSizeHorizontal * 2),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      hub.chargingHubName ?? "Charging Station",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: CommonColors.primary,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                hub.addressLine1 ?? "Address not available",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: CommonColors.primary,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  _filterButtons(),
                  const SizedBox(height: 12),
                  Divider(
                    color: CommonColors.neutral200,
                    thickness: 2,
                  ),
                  chargerDetail()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
Widget chargerDetail() {
  final stations = hub.stations ?? [];

  if (stations.isEmpty) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text("No stations available"),
    );
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Stations",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 8),

      /// 🔹 Stations List
      Column(
        children: stations.map((station) {
          final chargers = station.chargers ?? [];

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: CommonColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Station header
                  Text(
                    station.chargePointName ?? "Station",
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${station.availableChargers}/${station.totalChargers} Chargers Available",
                    style: const TextStyle(
                        fontSize: 12, color: CommonColors.neutral500),
                  ),

                  const Divider(height: 20),

                  /// 🔹 Chargers under station
                  Column(
                    children: chargers.map((charger) {
                      final isAvailable =
                          charger.lastStatus == "Available";

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: CommonColors.neutral50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(CommonImagePath.station),
                              const SizedBox(width: 10),

                              /// Charger info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      charger.connectorName ??
                                          "Connector",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                  charger.lastMeter==null?"":    charger.lastMeter.toString() ?? "",
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color:
                                              CommonColors.neutral500),
                                    ),
                                  ],
                                ),
                              ),

                              /// Status
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: isAvailable
                                      ? CommonColors.darkgreen
                                          .withOpacity(0.15)
                                      : Colors.red.withOpacity(0.15),
                                  borderRadius:
                                      BorderRadius.circular(20),
                                ),
                                child: Text(
                                  charger.lastStatus ?? "Unknown",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: isAvailable
                                        ? CommonColors.darkgreen
                                        : Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),

      const SizedBox(height: 16),

      /// 🔹 Amenities (STATIC)
      // const Text(
      //   "Amenities",
      //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      // ),
      // const SizedBox(height: 6),
      // _staticAmenities(),

      const SizedBox(height: 16),

      /// 🔹 Navigate Button (STATIC)
      _navigateButton(),
    ],
  );
}
Widget _staticAmenities() {
  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: CommonColors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 6,
          offset: Offset(0, 2),
        )
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _amenity(CommonImagePath.coffee, "Cafe"),
        _amenity(CommonImagePath.wifi, "Wi-Fi"),
        _amenity(CommonImagePath.washroom, "Washroom"),
      ],
    ),
  );
}

Widget _amenity(String icon, String label) {
  return Row(
    children: [
      SvgPicture.asset(icon),
      const SizedBox(width: 6),
      Text(label,
          style: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w600)),
    ],
  );
}
Widget _navigateButton() {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () {
        Navigator.push(
          routeGlobalKey.currentContext!,
          MaterialPageRoute(builder: (_) => MapOverviewScreen()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: CommonColors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      child: const Text(
        "Navigate to Station",
        style: TextStyle(color: CommonColors.white),
      ),
    ),
  );
}

  // Widget chargerDetail() {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         "Chargers",
  //         style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  //       ),
  //       // chargers list (compact)
  //       Column(
  //         children: List.generate(3, (i) {
  //           return Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Container(
  //               decoration: BoxDecoration(
  //                   color: CommonColors.white,
  //                   boxShadow: const [
  //                     BoxShadow(
  //                       color: Colors.black12,
  //                       blurRadius: 6,
  //                       offset: Offset(0, 2),
  //                     )
  //                   ],
  //                   borderRadius: BorderRadius.circular(8)),
  //               child: Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Column(
  //                   children: [
  //                     Container(
  //                       decoration: BoxDecoration(
  //                           color: CommonColors.neutral50,
  //                           borderRadius: BorderRadius.circular(8)),
  //                       child: Padding(
  //                         padding: const EdgeInsets.all(16),
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           crossAxisAlignment: CrossAxisAlignment.center,
  //                           children: [
  //                             // left: charger name
  //                             Expanded(
  //                               child: Row(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: [
  //                                   SvgPicture.asset(CommonImagePath.station),
  //                                   const SizedBox(width: 6),
  //                                   Text('Type A',
  //                                       style: TextStyle(
  //                                           fontWeight: FontWeight.w600)),
  //                                   const SizedBox(width: 6),
  //                                   Container(
  //                                     padding: const EdgeInsets.symmetric(
  //                                         vertical: 8, horizontal: 16),
  //                                     decoration: BoxDecoration(
  //                                       color: CommonColors.darkgreen
  //                                           .withOpacity(0.15),
  //                                       borderRadius: BorderRadius.circular(24),
  //                                     ),
  //                                     child: Text('Available',
  //                                         style: TextStyle(
  //                                             fontSize: 12,
  //                                             color: CommonColors.darkgreen,
  //                                             fontWeight: FontWeight.w500)),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                             // right: price / status
  //                             Column(
  //                               crossAxisAlignment: CrossAxisAlignment.end,
  //                               children: [
  //                                 const SizedBox(height: 6),
  //                                 const Text('₹25/kW',
  //                                     style: TextStyle(
  //                                         fontWeight: FontWeight.w600)),
  //                               ],
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       height: 6,
  //                     ),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Column(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Text('Charger Type',
  //                                 style: TextStyle(
  //                                     fontWeight: FontWeight.w200,
  //                                     fontSize: 12)),
  //                             Text('CCS2',
  //                                 style: TextStyle(
  //                                     fontWeight: FontWeight.w600,
  //                                     fontSize: 13)),
  //                           ],
  //                         ),
  //                         Column(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Text('Power Output',
  //                                 style: TextStyle(
  //                                     fontWeight: FontWeight.w200,
  //                                     fontSize: 12)),
  //                             Text('50-150KW',
  //                                 style: TextStyle(
  //                                     fontWeight: FontWeight.w600,
  //                                     fontSize: 13)),
  //                           ],
  //                         ),
  //                         Column(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Text('Plug Type',
  //                                 style: TextStyle(
  //                                     fontWeight: FontWeight.w200,
  //                                     fontSize: 12)),
  //                             Text('Type 2',
  //                                 style: TextStyle(
  //                                     fontWeight: FontWeight.w600,
  //                                     fontSize: 13)),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           );
  //         }),
  //       ),

  //       const SizedBox(height: 16),
  //       // amenities
  //       Text(
  //         "Amenities",
  //         style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  //       ),
  //       SizedBox(
  //         height: 6,
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Container(
  //           decoration: BoxDecoration(
  //               color: CommonColors.white,
  //               boxShadow: const [
  //                 BoxShadow(
  //                   color: Colors.black12,
  //                   blurRadius: 6,
  //                   offset: Offset(0, 2),
  //                 )
  //               ],
  //               borderRadius: BorderRadius.circular(8)),
  //           child: Padding(
  //             padding: EdgeInsets.symmetric(vertical: 14, horizontal: 8),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     SvgPicture.asset(CommonImagePath.coffee),
  //                     SizedBox(
  //                       width: 5,
  //                     ),
  //                     Text('Cafe',
  //                         style: TextStyle(
  //                             fontWeight: FontWeight.w600, fontSize: 13)),
  //                   ],
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     SvgPicture.asset(CommonImagePath.wifi),
  //                     SizedBox(
  //                       width: 5,
  //                     ),
  //                     Text('Wi-Fi',
  //                         style: TextStyle(
  //                             fontWeight: FontWeight.w600, fontSize: 13)),
  //                   ],
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     SvgPicture.asset(CommonImagePath.washroom),
  //                     SizedBox(
  //                       width: 5,
  //                     ),
  //                     Text('Washroom',
  //                         style: TextStyle(
  //                             fontWeight: FontWeight.w600, fontSize: 13)),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),

  //       const SizedBox(height: 16),
  //       SizedBox(
  //         width: double.infinity,
  //         child: ElevatedButton(
  //           onPressed: () {
  //             Navigator.push(
  //               routeGlobalKey.currentContext!,
  //               MaterialPageRoute(builder: (context) => MapOverviewScreen()),
  //             );
  //           },
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: CommonColors.blue,
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(12),
  //             ),
  //             padding: const EdgeInsets.symmetric(vertical: 14),
  //           ),
  //           child: const Text(
  //             'Navigate to Station',
  //             style: TextStyle(color: CommonColors.white),
  //           ),
  //         ),
  //       )
  //     ],
  //   );
  // }

  Widget _filterButtons({
    double? distance,
    String? opening,
    String? closing,
    int? availablePorts,
    int? totalPorts,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _filterChip(distance != null ? "${distance} Km" : "Distance N/A"),
          const SizedBox(width: 10),
          _filterChip(
            opening != null && closing != null
                ? "$opening - $closing"
                : "Timing N/A",
          ),
          const SizedBox(width: 10),
          _filterChip(
            availablePorts != null && totalPorts != null
                ? "$availablePorts/$totalPorts Ports Available"
                : "Ports N/A",
          ),
        ],
      ),
    );
  }

  //  Widget _filterButtons() {
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: Row(
  //       children: [
  //         _filterChip("4.9Km"),
  //         const SizedBox(width: 10),
  //         _filterChip("Open 24/7"),
  //         const SizedBox(width: 10),
  //         _filterChip("3/8 Ports Available"),
  //         const SizedBox(width: 10),

  //       ],
  //     ),
  //   );
  // }
  Widget _filterChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(
          color: CommonColors.neutral200, // choose your color here
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
