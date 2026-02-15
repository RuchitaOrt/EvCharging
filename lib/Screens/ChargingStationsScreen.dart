
import 'package:HyCharge/Provider/charging_hub_provider.dart';
import 'package:HyCharge/Screens/Controller/map_controller.dart';
import 'package:HyCharge/Screens/Controller/station_card_widget.dart';
import 'package:HyCharge/Screens/MainTab.dart';
import 'package:HyCharge/Screens/StationDetailsScreen.dart';
import 'package:HyCharge/Utils/CommonAppBar.dart';
import 'package:HyCharge/Utils/InternetConnection.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/Utils/commonimages.dart';
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

Future<void> _onScroll() async {
  final provider = context.read<ChargingHubProvider>();

  if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200 &&
      !provider.loading &&
      provider.hasMore) {
          hasInternet = await hasInternetConnection();
     print("hasInterne");
    print("hasInterne ${hasInternet}");
                      if(hasInternet==true)
                      {
                         print("hasInternet1");
    provider.pageNumber++;
    provider.loadChargingHubs(context);
                      }
  }
}

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // ---------------- Search Bar ----------------
  Widget _searchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 40,
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
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search Hub",
                hintStyle: TextStyle(color: CommonColors.hintGrey),
              ),
              onChanged: (value) {
  context.read<ChargingHubProvider>().searchHub(value);
},

              // onChanged: (value) {
              //   setState(() {
              //     _searchQuery = value.toLowerCase().trim();
              //   });
              // },
            ),
          ),
          if (_searchQuery.isNotEmpty)
            IconButton(
              icon: Icon(Icons.clear, size: 18, color: CommonColors.hintGrey),
              // onPressed: () {
              //   setState(() {
              //     _searchQuery = '';
              //     _searchController.clear();
              //   });
              // },
              onPressed: () {
  _searchController.clear();
  context.read<ChargingHubProvider>().clearSearch();
},

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
              builder: (_) => MainTab(isLoggedIn: GlobalLists.islLogin),
            ),
          );
        },
      ),
      body: Consumer<ChargingHubProvider>(
        builder: (context, provider, _) {
            final list = provider.filteredHubs;
          /// FIRST LOAD
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (provider.hubs.isEmpty && !provider.loading && hasInternet) {
              provider.pageNumber = 1;
              provider.loadChargingHubs(context);
            }
          });

          if (provider.loading) {
            return const Center(child: CircularProgressIndicator());
          }


        return Center(
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(maxWidth: 1100),
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(child: _searchBar()),
                        const SizedBox(width: 10),
                        Image.asset(
                          CommonImagePath.filter,
                          height: 40,
                        ),
                      ],
                    ),
                  ),

                  (!provider.loading &&
                          provider.filteredHubs.isEmpty)
                      ? const Expanded(
                          child: Center(
                            child: Text(
                              'No charging hubs found',
                              style:
                                  TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            physics:
                                const BouncingScrollPhysics(),
                            itemCount: list.length +
                                (provider.loading ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == list.length) {
                                return const Padding(
                                  padding:
                                      EdgeInsets.all(16),
                                  child: Center(
                                      child:
                                          CircularProgressIndicator()),
                                );
                              }

                              final hub = list[index];
                              return _stationBottomCard(hub);
                            },
                          ),
                        ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }


  // ---------------- Station Card ----------------
   Position? _currentPosition;
    void _fetchCurrentLocation() async {
    Position? position = await MapController().getCurrentPosition();
    if (position != null) {
      setState(() {
        _currentPosition = position;
      });
      // print(
      //     "Current Location: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}");
    }
  }
  double distance=0.0;
  Widget _stationBottomCard(dynamic hub) {
  
    final opening = hub.openingTime ?? 'N/A';
    final closing = hub.closingTime ?? 'N/A';
  

    LatLng? location = LocationConvert.getLatLngFromHub(hub);
 if (_currentPosition != null) {
       distance  = Geolocator.distanceBetween(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
            location!.latitude,
              location!.longitude) /
          1000;
    }
    return GestureDetector(
      onTap: () async {
        LatLng? location = LocationConvert.getLatLngFromHub(hub);
        if (location != null) {
          BitmapDescriptor?  activeMarkerIcon = await getResizedMarker(
            'assets/images/targetMarker.png',
            width: 125,
          );
          Navigator.push(
            routeGlobalKey.currentContext!,
            MaterialPageRoute(builder: (_) => StationDetailsScreen(hub: hub,
              marker: Marker(
                markerId: MarkerId(hub.recId),
                position: location,
                icon: activeMarkerIcon,
              )
              ,location: location,)),
          );
        }
        // Navigator.push(
        //   routeGlobalKey.currentContext!,
        //   MaterialPageRoute(builder: (_) => StationDetailsScreen(hub: hub)),
        // );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Container(
          padding: const EdgeInsets.all(10),
          // height: 170,
          decoration: BoxDecoration(
            color: CommonColors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TOP
              Container(
                decoration: BoxDecoration(
                  color: CommonColors.neutral50,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                     hub.chargingHubImage != null
    ? HubImage(
        imageId: hub.chargingHubImage!,
        height: SizeConfig.blockSizeVertical * 5,
        width: SizeConfig.blockSizeVertical * 5,
      )
    : Image.asset(
        CommonImagePath.frame,
        height: SizeConfig.blockSizeVertical * 6,
      ),
                    // Image.asset(CommonImagePath.frame, height: 50),
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
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: CommonColors.primary,
                                  ),
                                ),
                              ),
                              // const Icon(Icons.more_vert,
                              //     color: CommonColors.blue),
                            ],
                          ),
                          Row(
                            children: [
                              _infoTag(
                                  CommonImagePath.redpin,
                                  distance != null
                                      ? "${distance.toStringAsFixed(2)} KM"
                                      : "N/A"),
                              const SizedBox(width: 4),
                              _infoTag(
                                  CommonImagePath.star,
                                   hub.averageRating.toStringAsFixed(0) ?? 0.0
                                  ),
                              const SizedBox(width: 4),
                              _infoTag(
                                  CommonImagePath.clock, "$opening - $closing"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Amenities
              // Text(
              //   hub.amenities ?? "",
              //   maxLines: 2,
              //   overflow: TextOverflow.ellipsis,
              //   style: const TextStyle(
              //       fontSize: 12, color: CommonColors.neutral500),
              // ),
ExpandableText(
  text: hub.amenities ?? "",
  trimLines: 2,
  style: const TextStyle(
    fontSize: 12,
    color: CommonColors.neutral500,
  ),
),

              const SizedBox(height: 14),

              // Pricing
              Row(
                children: [
                  _typeInfo("Type A", "₹${hub.typeATariff ?? '--'} / kWh"),
                  const SizedBox(width: 20),
                  Expanded(
                      child: _typeInfo(
                          "Type B", "₹${hub.typeBTariff ?? '--'} / kWh")),
                  GestureDetector(
                    onTap: ()
                    {
                     LatLng? location =
                              LocationConvert.getLatLngFromHub(hub);
                          print(location!.latitude);
                          print(location!.longitude);
                          openGoogleMaps(
                            latitude: location.latitude,
                            longitude: location.longitude,
                          );
                    },
                    child: SvgPicture.asset(CommonImagePath.direction)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoTag(String icon, String text) {
    return Row(
      children: [
        Image.asset(icon, height: 14),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
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
            fontSize: 14,
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
