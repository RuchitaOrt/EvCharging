import 'package:ev_charging_app/Utils/commoncolors.dart';
import 'package:ev_charging_app/Utils/commonimages.dart';
import 'package:ev_charging_app/Utils/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng, BitmapDescriptor, Marker, MarkerId;
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
    return SizedBox(
      height: 160,
      child: Consumer <HubProvider>(
        builder: (BuildContext context, HubProvider value, Widget? child) {
          return ListView.separated(
            controller: value.scrollController, // from provider
            padding: const EdgeInsets.symmetric(horizontal: 8),
            scrollDirection: Axis.horizontal,
            itemCount: value.recordsStation.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            // itemBuilder: (BuildContext context, int index) => _StationCard(value.recordsStation[index]),
            itemBuilder: (BuildContext context, int index) {
              final isSelected = value.currentVisibleIndex == index;
              return GestureDetector(
                  onTap: () {
                    // value.selectStation(index); // auto scroll here
                  },
                  child: _StationCard(
                    chargingHub: value.recordsStation[index],
                    isSelected: isSelected,
                  ),
              );

            },
          );
        },
      ),
    );
  }
}

class _StationCard extends StatelessWidget {
  final ChargingHub chargingHub;
  final bool isSelected;

  const _StationCard({
    super.key,
    required this.chargingHub,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final openingTime = _formatTime(chargingHub.openingTime);
    final closingTime = _formatTime(chargingHub.closingTime);
    final hours = '$openingTime - $closingTime';

    final distance = chargingHub.distanceKm != null
        ? '${chargingHub.distanceKm} KM'
        : 'N/A';

    // final rating = chargingHub.averageRating?? 'N/A';
    final rating = 'N/A';

    final typeAPrice = chargingHub.typeATariff?.isNotEmpty == true
        ? '₹${chargingHub.typeATariff} / kWh'
        : '₹12.99 / kWh';

    final typeBPrice = chargingHub.typeBTariff?.isNotEmpty == true
        ? '₹${chargingHub.typeBTariff} / kWh'
        : '₹12.99 / kWh';

    // Parse amenities
    final amenitiesStr = chargingHub.amenities?.toString() ?? '';
    final amenitiesList = amenitiesStr.isNotEmpty
        ? amenitiesStr.split(',').map((a) => a.trim()).where((a) => a.isNotEmpty).toList()
        : [];
    return SizedBox(
      width: 338,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// --- HEADER ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  CommonImagePath.frame,
                  height: SizeConfig.blockSizeVertical * 8,
                ),
                SizedBox(width: SizeConfig.blockSizeHorizontal * 2),

                /// --- INFO ---
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              chargingHub.chargingHubName ?? "Station Name",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Icon(Icons.more_vert, color: CommonColors.blue),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children:  [
                          _InfoTag(icon: CommonImagePath.redpin, text: distance),
                          SizedBox(width: 2),
                          _InfoTag(icon: CommonImagePath.star, text: 'NA'),
                          SizedBox(width: 2),
                          Expanded(
                            child: _InfoTag(
                              icon: CommonImagePath.clock,
                              text: hours,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// --- FOOTER ---
            Row(
              children: [
                  _TypeInfo(type: "Type 1", price: typeAPrice),
                SizedBox(width: SizeConfig.blockSizeHorizontal * 2),
                  _TypeInfo(type: "Type 2", price: typeBPrice),
                SizedBox(width: SizeConfig.blockSizeHorizontal * 2),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      // context.read<HubProvider>().getDirection(context, '243245');
                      // context.read<HubProvider>().getDirectionOfRoute(context, chargingHub);
                      LatLng? location = LocationConvert.getLatLngFromHub(chargingHub);
                      if (location != null) {
                        BitmapDescriptor?  activeMarkerIcon = await getResizedMarker(
                          'assets/images/targetMarker.png',
                          width: 125,
                        );
                        Navigator.push(
                          routeGlobalKey.currentContext!,
                          MaterialPageRoute(builder: (_) => StationDetailsScreen(hub: chargingHub,
                            marker: Marker(
                              markerId: MarkerId(chargingHub.recId),
                              position: location,
                              icon: activeMarkerIcon,
                            )
                            ,location: location,)),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      // backgroundColor: Colors.white,
                      backgroundColor: isSelected ? Colors.lightGreen : Colors.white,
                      foregroundColor: CommonColors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: CommonColors.blue.withOpacity(0.4),
                          width: 0.8,
                        ),
                      ),
                    ),
                    child: Text(
                      "Get Directions",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
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
class _InfoTag extends StatelessWidget {
  final String icon;
  final String text;

  const _InfoTag({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      decoration: BoxDecoration(
        color: CommonColors.neutral200,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Image.asset(icon, height: 14),
          // const SizedBox(width: 4),
          Text(text, maxLines: 1,  overflow: TextOverflow.fade, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class _TypeInfo extends StatelessWidget {
  final String type;
  final String price;

  const _TypeInfo({
    required this.type,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          type,
          style: TextStyle(
            fontSize: 12,
            color: CommonColors.neutral500,
          ),
        ),
        Text(
          price,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: CommonColors.primary,
          ),
        ),
      ],
    );
  }
}
