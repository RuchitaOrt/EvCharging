import 'dart:typed_data';

import 'package:HyCharge/Screens/Controller/map_controller.dart';
import 'package:HyCharge/Screens/MapOverviewScreen.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/Utils/commonimages.dart';
import 'package:HyCharge/Utils/googleMap.dart';
import 'package:HyCharge/Utils/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'
    show LatLng, BitmapDescriptor, Marker, MarkerId;
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

import '../../Provider/HubProvider.dart';
import '../../Utils/LocationConvert.dart';
import '../../Utils/iconresizer.dart';
import '../../main.dart';
import '../../model/ChargingcomprehensiveHubResponse.dart';
import '../StationDetailsScreen.dart';
// import '../../model/ChargingHubResponse.dart';

import 'package:flutter/gestures.dart';

class StationCardWidget extends StatelessWidget {
  const StationCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 145,
      
      child: Consumer<HubProvider>(
        builder: (context, value, _) {
          return ScrollConfiguration(
            behavior: const MaterialScrollBehavior().copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
                PointerDeviceKind.trackpad,
              },
            ),
            child: ListView.separated(
              controller: value.scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: value.recordsStation.length +
                  (value.isMoreLoading ? 1 : 0),
              separatorBuilder: (_, __) =>
                  const SizedBox(width: 12),
              itemBuilder: (context, index) {
                if (index >= value.recordsStation.length) {
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

                final isSelected =
                    value.currentVisibleIndex == index;

                return _StationCard(
                  chargingHub: value.recordsStation[index],
                  isSelected: isSelected,
                  cardWidth: screenWidth * 0.88,
                );
              },
            ),
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
  final position = await MapController().getCurrentPosition();
  if (!mounted) return; // ✅ IMPORTANT

  if (position != null) {
    setState(() {
      _currentPosition = position;
    });
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
    final screenWidth = MediaQuery.of(context).size.width;
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
        : '₹ 0 / kWh';

    final typeBPrice = widget.chargingHub.typeBTariff?.isNotEmpty == true
        ? '₹${widget.chargingHub.typeBTariff} / kWh'
        : '₹ 0 / kWh';

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
        width:kIsWeb && screenWidth >= 768
      ? 600
      : widget.cardWidth,
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
              // widget.chargingHub.chargingHubImage!=null?Text("data"):    Image.asset(
              //       CommonImagePath.frame,
              //       height: SizeConfig.blockSizeVertical * 6,
              //     ),
              widget.chargingHub.chargingHubImage != null
    ? HubImage(
        imageId: widget.chargingHub.chargingHubImage!,
        height: SizeConfig.blockSizeVertical * 5,
        width: SizeConfig.blockSizeVertical * 5,
      )
    : 
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
                                maxLines: 1,
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
                            //  _InfoTag(icon: CommonImagePath.star, text: "${widget.chargingHub!.averageRating!.toString()}"),
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
          const SizedBox(width: 2),
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
  Future<Uint8List?>? _imageFuture;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(covariant HubImage oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 🔁 Reload only if imageId changes
    if (oldWidget.imageId != widget.imageId) {
      _loadImage();
    }
  }

  void _loadImage() {
    _imageFuture =
        context.read<HubProvider>().downloadImage(widget.imageId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: _imageFuture,
      builder: (context, snapshot) {
        // ⏳ Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: widget.height,
            width: widget.width,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        // ❌ Error / No Image
        if (!snapshot.hasData || snapshot.data == null) {
          return Image.asset(
            CommonImagePath.frame,
            height: widget.height,
            width: widget.width,
            fit: BoxFit.cover,
          );
        }

        // ✅ Success
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

