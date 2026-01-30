import 'package:ev_charging_app/Screens/Controller/map_controller.dart';
import 'package:ev_charging_app/Screens/MapOverviewScreen.dart';
import 'package:ev_charging_app/Utils/commoncolors.dart';
import 'package:ev_charging_app/Utils/commonimages.dart';
import 'package:ev_charging_app/Utils/googleMap.dart';
import 'package:ev_charging_app/Utils/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'
    show LatLng, BitmapDescriptor, Marker, MarkerId;
import 'package:provider/provider.dart';

import '../../Provider/HubProvider.dart';
import '../../Utils/LocationConvert.dart';
import '../../Utils/iconresizer.dart';
import '../../main.dart';
import '../../model/ChargingcomprehensiveHubResponse.dart';
import '../StationDetailsScreen.dart';
// import '../../model/ChargingHubResponse.dart';

class StationCardWidget extends StatelessWidget {
  const StationCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 135,
      child: Consumer<HubProvider>(
        builder: (context, value, _) {
          return ListView.separated(
            controller: value.scrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: value.recordsStation.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final isSelected = value.currentVisibleIndex == index;
              return _StationCard(
                chargingHub: value.recordsStation[index],
                isSelected: isSelected,
                cardWidth: screenWidth * 0.88,
              );
            },
          );
        },
      ),
    );
  }
}

class _StationCard extends StatefulWidget {
  final ChargingHub chargingHub;
  final bool isSelected;
  final double cardWidth;

  const _StationCard({
    required this.chargingHub,
    required this.isSelected,
    required this.cardWidth,
  });

  @override
  State<_StationCard> createState() => _StationCardState();
}

class _StationCardState extends State<_StationCard> {


   Position? _currentPosition;
    void _fetchCurrentLocation() async {
    Position? position = await MapController().getCurrentPosition();
    if (position != null) {
      setState(() {
        _currentPosition = position;
      });
      print(
          "Current Location: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}");
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchCurrentLocation();
  }
  @override
  Widget build(BuildContext context) {
    final openingTime = _formatTime(widget.chargingHub.openingTime);
    final closingTime = _formatTime(widget.chargingHub.closingTime);
    final hours = '$openingTime - $closingTime';

    // final distance =
    //     widget.chargingHub.distanceKm != null ? '${widget.chargingHub.distanceKm} KM' : 'N/A';
     double distance=0.0;

    LatLng? location = LocationConvert.getLatLngFromHub(widget.chargingHub);
 if (_currentPosition != null) {
       distance  = Geolocator.distanceBetween(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
            location!.latitude,
              location!.longitude) /
          1000;
    }
    final typeAPrice = widget.chargingHub.typeATariff?.isNotEmpty == true
        ? '₹${widget.chargingHub.typeATariff} / kWh'
        : '₹12.99 / kWh';

    final typeBPrice = widget.chargingHub.typeBTariff?.isNotEmpty == true
        ? '₹${widget.chargingHub.typeBTariff} / kWh'
        : '₹12.99 / kWh';

    return GestureDetector(
      onTap: () async {
        LatLng? location = LocationConvert.getLatLngFromHub(widget.chargingHub);
        if (location != null) {
          BitmapDescriptor icon = await getResizedMarker(
            'assets/images/targetMarker.png',
            width: 120,
          );
          Navigator.push(
            routeGlobalKey.currentContext!,
            MaterialPageRoute(
              builder: (_) => StationDetailsScreen(
                hub: widget.chargingHub,
                marker: Marker(
                  markerId: MarkerId(widget.chargingHub.recId!),
                  position: location,
                  icon: icon,
                ),
                location: location,
              ),
            ),
          );
        }
      },
      child: SizedBox(
        width: widget.cardWidth,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 6),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ---------------- HEADER ----------------
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    CommonImagePath.frame,
                    height: SizeConfig.blockSizeVertical * 6,
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
                                widget.chargingHub.chargingHubName ?? 'Station Name',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            // const Icon(Icons.more_vert,
                            //     color: CommonColors.blue),
                        
                          ],
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: [
                            _InfoTag(
                                icon: CommonImagePath.redpin, text: "${distance.toStringAsFixed(2)} km"),
_InfoTag(icon: CommonImagePath.star, text: "${widget.chargingHub!.averageRating!.toStringAsFixed(0)}",),
                            // _InfoTag(icon: CommonImagePath.star, text: "${widget.chargingHub!.averageRating!.toString()}"),
                            _InfoTag(icon: CommonImagePath.clock, text: hours),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const Spacer(),

              /// ---------------- FOOTER ----------------
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 6,
                      children: [
                        _TypeInfo(type: 'Type 1', price: typeAPrice),
                        _TypeInfo(type: 'Type 2', price: typeBPrice),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 36,
                      child: ElevatedButton(
                        onPressed: () async {
                          LatLng? location =
                              LocationConvert.getLatLngFromHub(widget.chargingHub);
                          print(location!.latitude);
                          print(location!.longitude);
                          openGoogleMaps(
                            latitude: location.latitude,
                            longitude: location.longitude,
                          );
                          // final Position position =
                          //     await MapController().getCurrentPosition();

                          // if (position.longitude != null) {
                          //   Navigator.push(
                          //     routeGlobalKey.currentContext!,
                          //     MaterialPageRoute(
                          //         builder: (_) => MapOverviewScreen(
                          //               hub: chargingHub,
                          //               location: position,
                          //             )),
                          //   );
                          // }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              // widget.isSelected ? Colors.lightGreen :
                               Colors.white,
                          foregroundColor: CommonColors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color:
                                  CommonColors.blue.withOpacity(0.4),
                            ),
                          ),
                        ),
                        child: const FittedBox(
                          child: Text(
                            'Get Directions',
                            style: TextStyle(
                              fontSize: 12,
                              color: CommonColors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ---------------- HELPERS ----------------

String _formatTime(String? time) {
  if (time == null || time.isEmpty) return 'N/A';
  try {
    final parts = time.split(':');
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = parts[1];
    final displayHour = hour == 0
        ? 12
        : hour > 12
            ? hour - 12
            : hour;
    return '$displayHour:$minute';
  } catch (_) {
    return time;
  }
}

class _InfoTag extends StatelessWidget {
  final String icon;
  final String text;
  final Color background;

  const _InfoTag({required this.icon, required this.text,  this.background=CommonColors.neutral200});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(icon, height: 12),
          const SizedBox(width: 4),
          Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _TypeInfo extends StatelessWidget {
  final String type;
  final String price;

  const _TypeInfo({required this.type, required this.price});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          type,
          style: const TextStyle(
            fontSize: 11,
            color: CommonColors.neutral500,
          ),
        ),
        Text(
          price,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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

// class StationCardWidget extends StatelessWidget {
//  const StationCardWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 160,
//       child: Consumer <HubProvider>(
//         builder: (BuildContext context, HubProvider value, Widget? child) {
//           return ListView.separated(
//             controller: value.scrollController, // from provider
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             scrollDirection: Axis.horizontal,
//             itemCount: value.recordsStation.length,
//             separatorBuilder: (_, __) => const SizedBox(width: 12),
//             // itemBuilder: (BuildContext context, int index) => _StationCard(value.recordsStation[index]),
//             itemBuilder: (BuildContext context, int index) {
//               final isSelected = value.currentVisibleIndex == index;
//               return GestureDetector(
//                   onTap: () {
//                     // value.selectStation(index); // auto scroll here
//                   },
//                   child: _StationCard(
//                     chargingHub: value.recordsStation[index],
//                     isSelected: isSelected,
//                   ),
//               );

//             },
//           );
//         },
//       ),
//     );
//   }
// }

// class _StationCard extends StatelessWidget {
//   final ChargingHub chargingHub;
//   final bool isSelected;

//   const _StationCard({
//     super.key,
//     required this.chargingHub,
//     required this.isSelected,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final openingTime = _formatTime(chargingHub.openingTime);
//     final closingTime = _formatTime(chargingHub.closingTime);
//     final hours = '$openingTime - $closingTime';

//     final distance = chargingHub.distanceKm != null
//         ? '${chargingHub.distanceKm} KM'
//         : 'N/A';

//     // final rating = chargingHub.averageRating?? 'N/A';
//     final rating = 'N/A';

//     final typeAPrice = chargingHub.typeATariff?.isNotEmpty == true
//         ? '₹${chargingHub.typeATariff} / kWh'
//         : '₹12.99 / kWh';

//     final typeBPrice = chargingHub.typeBTariff?.isNotEmpty == true
//         ? '₹${chargingHub.typeBTariff} / kWh'
//         : '₹12.99 / kWh';

//     // Parse amenities
//     final amenitiesStr = chargingHub.amenities?.toString() ?? '';
//     final amenitiesList = amenitiesStr.isNotEmpty
//         ? amenitiesStr.split(',').map((a) => a.trim()).where((a) => a.isNotEmpty).toList()
//         : [];
//     return SizedBox(
//       width: 338,
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 6,
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// --- HEADER ---
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Image.asset(
//                   CommonImagePath.frame,
//                   height: SizeConfig.blockSizeVertical * 8,
//                 ),
//                 SizedBox(width: SizeConfig.blockSizeHorizontal * 2),

//                 /// --- INFO ---
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               chargingHub.chargingHubName ?? "Station Name",
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                           Icon(Icons.more_vert, color: CommonColors.blue),
//                         ],
//                       ),
//                       const SizedBox(height: 6),
//                       Row(
//                         children:  [
//                           _InfoTag(icon: CommonImagePath.redpin, text: distance),
//                           SizedBox(width: 2),
//                           _InfoTag(icon: CommonImagePath.star, text: 'NA'),
//                           SizedBox(width: 2),
//                           Expanded(
//                             child: _InfoTag(
//                               icon: CommonImagePath.clock,
//                               text: hours,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 12),

//             /// --- FOOTER ---
//             Row(
//               children: [
//                   _TypeInfo(type: "Type 1", price: typeAPrice),
//                 SizedBox(width: SizeConfig.blockSizeHorizontal * 4),
//                   _TypeInfo(type: "Type 2", price: typeBPrice),
//                 SizedBox(width: SizeConfig.blockSizeHorizontal * 4),

//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       // context.read<HubProvider>().getDirection(context, '243245');
//                       // context.read<HubProvider>().getDirectionOfRoute(context, chargingHub);
//                       LatLng? location = LocationConvert.getLatLngFromHub(chargingHub);
//                       if (location != null) {
//                         BitmapDescriptor?  activeMarkerIcon = await getResizedMarker(
//                           'assets/images/targetMarker.png',
//                           width: 125,
//                         );
//                         Navigator.push(
//                           routeGlobalKey.currentContext!,
//                           MaterialPageRoute(builder: (_) => StationDetailsScreen(hub: chargingHub,
//                             marker: Marker(
//                               markerId: MarkerId(chargingHub.recId),
//                               position: location,
//                               icon: activeMarkerIcon,
//                             )
//                             ,location: location,)),
//                         );
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       // backgroundColor: Colors.white,
//                       minimumSize: const Size(80, 30),
//                       backgroundColor: isSelected ? Colors.lightGreen : Colors.white,
//                       foregroundColor: CommonColors.blue,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         side: BorderSide(
//                           color: CommonColors.blue.withOpacity(0.4),
//                           width: 0.8,
//                         ),
//                       ),
//                     ),
//                     child: Text(
//                       "Get Directions",
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// // Helper method to format time
// String _formatTime(String? time) {
//   if (time == null || time.isEmpty) return "N/A";

//   try {
//     final parts = time.split(':');
//     if (parts.length >= 2) {
//       final hour = int.tryParse(parts[0]) ?? 0;
//       final minute = parts[1];
//       final period = hour >= 12 ? 'PM' : 'AM';
//       final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
//       return '$displayHour:$minute ';
//     }
//     return time;
//   } catch (e) {
//     return time;
//   }
// }
// class _InfoTag extends StatelessWidget {
//   final String icon;
//   final String text;

//   const _InfoTag({required this.icon, required this.text});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
//       decoration: BoxDecoration(
//         color: CommonColors.neutral200,
//         borderRadius: BorderRadius.circular(4),
//       ),
//       child: Row(
//         children: [
//           Image.asset(icon, height: 14),
//            const SizedBox(width: 4),
//           Text(text, maxLines: 1,  overflow: TextOverflow.fade, style: const TextStyle(fontSize: 12)),
//         ],
//       ),
//     );
//   }
// }

// class _TypeInfo extends StatelessWidget {
//   final String type;
//   final String price;

//   const _TypeInfo({
//     required this.type,
//     required this.price,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           type,
//           style: TextStyle(
//             fontSize: 12,
//             color: CommonColors.neutral500,
//           ),
//         ),
//         Text(
//           price,
//           style: TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w600,
//             color: CommonColors.primary,
//           ),
//         ),
//       ],
//     );
//   }
// }
