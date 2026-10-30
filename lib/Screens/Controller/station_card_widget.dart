

import 'dart:typed_data';

import 'package:HyCharge/Utils/FilterBottomSheet.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/Utils/commonimages.dart';
import 'package:HyCharge/Utils/commonstrings.dart';
import 'package:HyCharge/Utils/googleMap.dart';
import 'package:HyCharge/model/UnifiedComprehensiveResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../Provider/HubProvider.dart';
import '../../Utils/LocationConvert.dart';


class StationCardWidget extends StatelessWidget {
  final StationFilters filters;

  const StationCardWidget({
    super.key,
    this.filters = const StationFilters(),
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 150,
      child: Consumer<HubProvider>(
        builder: (context, provider, _) {
          final allLocations = provider.locations;
          final position = provider.currentPosition;

          // Apply the distance filter to the actual station list.
          final List<Location> filteredLocations =
              allLocations.where((station) {
            if (filters.distance == 'Any' || position == null) {
              return true;
            }

            final stationPosition =
                LocationConvert.getLatLngFromUnifiedHub(station);

            if (stationPosition == null) {
              return false;
            }

            final distanceKm = Geolocator.distanceBetween(
                  position.latitude,
                  position.longitude,
                  stationPosition.latitude,
                  stationPosition.longitude,
                ) /
                1000;

            final maxDistance = double.tryParse(
              filters.distance.replaceAll(
                RegExp(r'[^0-9.]'),
                '',
              ),
            );

            if (maxDistance == null) return true;

            return distanceKm <= maxDistance;
          }).toList();

          return NotificationListener<ScrollEndNotification>(
            onNotification: (notification) {
              final itemWidth = screenWidth * 0.87 + 14;

              final filteredIndex =
                  (provider.scrollController.offset / itemWidth).round();

              if (filteredLocations.isNotEmpty) {
                final safeIndex = filteredIndex.clamp(
                  0,
                  filteredLocations.length - 1,
                );

                // The provider uses the original locations list.
                final originalIndex = allLocations.indexOf(
                  filteredLocations[safeIndex],
                );

                if (originalIndex >= 0) {
                  provider.onStationScrollSettled(originalIndex);
                }
              }

              return false;
            },
            child: filteredLocations.isEmpty
                ? const Center(
                    child: Text(
                      'No charging stations found for this distance.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  )
                : ListView.separated(
                    key: ValueKey(
                      '${filters.distance}_${filteredLocations.length}',
                    ),
                    controller: provider.scrollController,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: filteredLocations.length +
                        (provider.isMoreLoading ? 1 : 0),
                    separatorBuilder: (_, __) =>
                        const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      if (index >= filteredLocations.length) {
                        return const SizedBox(
                          width: 80,
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: CommonColors.white,
                            ),
                          ),
                        );
                      }

                      final station = filteredLocations[index];
                      final originalIndex =
                          allLocations.indexOf(station);

                      return Padding(
                        padding: const EdgeInsets.only(left: 2),
                        child: _StationCard(
                          chargingHub: station,
                          isSelected:
                              provider.currentVisibleIndex == originalIndex,
                          cardWidth: screenWidth * 0.87,
                          nearbyHubs: allLocations,
                        ),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}


// class StationCardWidget extends StatelessWidget {
//   const StationCardWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
    
//     final screenWidth = MediaQuery.of(context).size.width;

//     return SizedBox(
//       height: 150,
//       child: Consumer<HubProvider>(
//         builder: (context, value, _) {
//           print("16july Ruchita ${value.locations.length}");
//           return NotificationListener<ScrollEndNotification>(
//              onNotification: (notification) {
//     final itemWidth = screenWidth * 0.87 + 14;

//     final index =
//         (value.scrollController.offset / itemWidth).round();

//     context.read<HubProvider>().onStationScrollSettled(index);

//     return false;
//   },
//             child: ListView.separated(
//               controller: value.scrollController,
//               scrollDirection: Axis.horizontal,
//               padding: const EdgeInsets.symmetric(horizontal: 8),
//               itemCount:
//               value.locations.length +
//               // value.recordsStation.length +
//                 (value.isMoreLoading ? 1 : 0),
//               //  value.recordsStation.length,
//               separatorBuilder: (_, __) => const SizedBox(width: 12),
//               itemBuilder: (context, index) {
//               if (index >= value.locations.length) {
//                 return const SizedBox(
//                   width: 80,
//                   child: Center(
//                     child: CircularProgressIndicator(strokeWidth: 2,color: CommonColors.white,),
//                   ),
//                 );
//               }
            
//               final isSelected = value.currentVisibleIndex == index;
             
//               return Padding(
//                 padding: const EdgeInsets.only(left: 2),
//                 child: _StationCard(
//                   chargingHub: value.locations[index],
//                   isSelected: isSelected,
//                   cardWidth: screenWidth *0.87,
//                   nearbyHubs: value.locations,
//                 ),
//               );
//             },
            
            
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

class _StationCard extends StatefulWidget {
  final Location chargingHub;
  final bool isSelected;
  final double cardWidth;
  final List<dynamic> nearbyHubs;

  const _StationCard({
    required this.chargingHub,
    required this.isSelected,
    required this.cardWidth, required this.nearbyHubs,
  });

  @override
  State<_StationCard> createState() => _StationCardState();
}

class _StationCardState extends State<_StationCard> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<HubProvider>().loadCurrentPosition();
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    final currentPosition = context.select<HubProvider, Position?>(
      (provider) => provider.currentPosition,
    );

    final stationLocation =
        LocationConvert.getLatLngFromUnifiedHub(widget.chargingHub);

    double? distance;

    if (currentPosition != null && stationLocation != null) {
      distance = Geolocator.distanceBetween(
        currentPosition.latitude,
        currentPosition.longitude,
        stationLocation.latitude,
        stationLocation.longitude,
      ) / 1000;
    }

    const typeAPrice = '₹0';
    const typeBPrice = '₹0';

    final isDummyStation =
        widget.chargingHub.id == CommonStrings.strDummyRecID ||
        widget.chargingHub.id == CommonStrings.strDummyRecID1;

    return SizedBox(
      width: widget.cardWidth,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 12, 20, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Station image, name, distance and rating
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    CommonImagePath.stationImage,
                    height: 68,
                    width: 68,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.chargingHub.name ?? 'Station Name',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF101A35),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _InfoTag(
                            icon: CommonImagePath.locationred,
                            text: distance == null
                                ? '-- km'
                                : '${distance.toStringAsFixed(2)} km',
                            background: const Color(0xFFEEF0F5),
                          ),
                          if (widget.chargingHub.averageRating != null)
                            _InfoTag(
                              icon: CommonImagePath.stargold,
                              text: widget.chargingHub.averageRating!
                                  .toStringAsFixed(0),
                              background: const Color(0xFFEEF0F5),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Divider
            Container(
              height: 1.5,
              color: const Color(0xFFDDE2EA),
            ),

            const SizedBox(height: 8),

            // Pricing and Go button
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: _TypeInfo(
                          type: isDummyStation ? 'AC Station' : 'Station 1',
                          price: typeAPrice,
                        ),
                      ),
                      if (!isDummyStation)
                        Expanded(
                          child: _TypeInfo(
                            type: 'Station 2',
                            price: typeBPrice,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Material(
                  color: const Color(0xFF142D78),
                  borderRadius: BorderRadius.circular(40),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(40),
                    onTap: () {
                      if (stationLocation != null) {
                        openMaps(
                          latitude: stationLocation.latitude,
                          longitude: stationLocation.longitude,
                        );
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.near_me_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 2),
                          Text(
                            'Go',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                           SizedBox(width: 6),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// class _StationCardState extends State<_StationCard> {


// @override
// void initState() {
//   super.initState();

//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     context.read<HubProvider>().loadCurrentPosition();
//   });
// }

  
//   @override
//   Widget build(BuildContext context) {
//     final openingTime ="";
//     //  _formatTime(widget.chargingHub.openingTime);
//     final closingTime="";
//     // _formatTime(widget.chargingHub.closingTime);
    
//   final currentPosition = context.select<HubProvider, Position?>(
//   (provider) => provider.currentPosition,
// );

// final location =
//     LocationConvert.getLatLngFromUnifiedHub(widget.chargingHub);

// double? distance;

// if (currentPosition != null && location != null) {
//   distance = Geolocator.distanceBetween(
//     currentPosition.latitude,
//     currentPosition.longitude,
//     location.latitude,
//     location.longitude,
//   ) / 1000;
// }
    
//     final typeAPrice =
    
//         '₹ 0 / kWh';

//     final typeBPrice =
  
//         '₹ 0 / kWh';

//     return GestureDetector(
//       onTap: () async {
//         LatLng? location = LocationConvert.getLatLngFromUnifiedHub(widget.chargingHub);
//         if (location != null) {
//           BitmapDescriptor icon = await getResizedMarker(
//             'assets/images/targetMarker.png',
//             width: 120,
//           );
//           Navigator.push(
//             routeGlobalKey.currentContext!,
//             MaterialPageRoute(
//               builder: (_) => StationDetailsScreen(
//                 nearbyHubs: widget.nearbyHubs,
//                 hub: widget.chargingHub,
//                 marker: Marker(
//                   markerId: MarkerId(widget.chargingHub.id!),
//                   position: location,
//                   icon: icon,
//                 ),
//                 location: location,
//               ),
//             ),
//           );
//         }
//       },
//       child: SizedBox(
//         width: widget.cardWidth,
//         child: Container(
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: const [
//               BoxShadow(color: Colors.black12, blurRadius: 6),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               /// ---------------- HEADER ----------------
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
             
//     //           widget.chargingHub.chargingHubImage != null
//     // ? HubImage(
//     //     imageId: widget.chargingHub.chargingHubImage!,
//     //     height: SizeConfig.blockSizeVertical * 5,
//     //     width: SizeConfig.blockSizeVertical * 5,
//     //   )
//     // : 
//     Image.asset(
//         CommonImagePath.stationImage,
//         height: SizeConfig.blockSizeVertical * 6,
//       ),

   

//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Text(
//                                 "${widget.chargingHub.name}" ?? 'Station Name',
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                             // const Icon(Icons.more_vert,
//                             //     color: CommonColors.blue),
                        
//                           ],
//                         ),
//                         const SizedBox(height: 6),
//                         Wrap(
//                           spacing: 4,
//                           runSpacing: 4,
//                           children: [
//                             _InfoTag(
//   icon: CommonImagePath.redpin,
//   text: distance == null
//       ? '0.0'
//       : '${distance.toStringAsFixed(2)} km',
// ),
                         
//                                 widget.chargingHub!.averageRating==null?Container():
// _InfoTag(icon: CommonImagePath.star, text: "${widget.chargingHub!.averageRating!.toStringAsFixed(0)}",),
                          
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),

//               const Spacer(),

//               /// ---------------- FOOTER ----------------
//               Row(
//                 children: [
//                   Expanded(
//                     flex: 3,
//                     child: Wrap(
//                       spacing: 16,
//                       runSpacing: 6,
//                       children:
//                     (   widget.chargingHub!.id==CommonStrings.strDummyRecID||  widget.chargingHub!.id ==CommonStrings.strDummyRecID1)
//                     ?
//                        [ _TypeInfo(type: 'AC Station', price:typeAPrice)]: 
//                        [
//                         _TypeInfo(type: 'Station 1', price: typeAPrice),
//                         _TypeInfo(type: 'Station 2', price: typeBPrice),
//                       ],
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: ()
//                     {
//                        LatLng? location =
//                               LocationConvert.getLatLngFromUnifiedHub(widget.chargingHub);
//                           print(location!.latitude);
//                           print(location!.longitude);
//                           openMaps(
//                             latitude: location.latitude,
//                             longitude: location.longitude,
//                           );
//                     },
//                     child: SvgPicture.asset(CommonImagePath.direction))
                
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


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
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(icon,width: 12,height: 12,),
          // Image.asset(icon, height: 12),
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
        Row(
          children: [
            Text(
              price,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: CommonColors.black,
              ),
            ),
              Text(
          "/kWh",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: CommonColors.blue,
          ),
        ),
          ],
        ),
       
      ],
    );
  }
}
class HubImage extends StatefulWidget {
  final String imageId;
  final double height;
  final double width;

  const HubImage({
    super.key,
    required this.imageId,
    this.height = 48,
    this.width = 48,
  });

  @override
  State<HubImage> createState() => _HubImageState();
}

class _HubImageState extends State<HubImage> {
  late Future<Uint8List> _imageFuture;

  @override
  void initState() {
    super.initState();
    _imageFuture =
        context.read<HubProvider>().downloadImage(widget.imageId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: _imageFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: widget.height,
            width: widget.width,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        if (!snapshot.hasData) {
          return Image.asset(
            CommonImagePath.frame,
            height: widget.height,
            width: widget.width,
          );
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.memory(
            snapshot.data!,
            height: widget.height,
            width: widget.width,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
