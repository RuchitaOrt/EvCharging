import 'dart:async';

import 'package:ev_charging_app/Provider/ChargingGunStatusProvider.dart';
import 'package:ev_charging_app/Provider/ChargingHubReviewProvider.dart';
import 'package:ev_charging_app/Provider/ChargingProvider.dart';
import 'package:ev_charging_app/Screens/ChargingEstimateScreen.dart';
import 'package:ev_charging_app/Screens/Controller/map_controller.dart';
import 'package:ev_charging_app/Screens/Map/MiniMapWidget.dart';
import 'package:ev_charging_app/Screens/SessionChargingScreen.dart';
import 'package:ev_charging_app/Utils/AuthStorage.dart';
import 'package:ev_charging_app/Utils/CommonAppBar.dart';
import 'package:ev_charging_app/Utils/LocationConvert.dart';
import 'package:ev_charging_app/Utils/ShowDialog.dart';
import 'package:ev_charging_app/Utils/commoncolors.dart';
import 'package:ev_charging_app/Utils/commonimages.dart';
import 'package:ev_charging_app/Utils/sizeConfig.dart';
import 'package:ev_charging_app/main.dart';
import 'package:ev_charging_app/model/ChargingHubReviewResponse.dart';
import 'package:ev_charging_app/model/ChargingcomprehensiveHubResponse.dart';
import 'package:ev_charging_app/widget/LogoutConfirmationSheet.dart';
import 'package:ev_charging_app/widget/custom_text_field_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class StationDetailsScreen extends StatefulWidget {
  final ChargingHub hub;
  final Marker marker;
  final LatLng location;

  StationDetailsScreen({
    super.key,
    required this.hub,
    required this.marker,
    required this.location,
  });

  @override
  State<StationDetailsScreen> createState() => _StationDetailsScreenState();
}

class _StationDetailsScreenState extends State<StationDetailsScreen> {
  GoogleMapController? mapController;

  Set<Marker> markers = {};

  Charger? _selectedCharger;
  String? selectedStationID;
  Position? _currentPosition;
  Timer? _statusTimer;

  void _startPolling() {
    _statusTimer = Timer.periodic(
      const Duration(seconds: 10), // 👈 every 10 sec
      (_) {
        // final chargers = widget.hub.stations
        //     ?.expand((s) => s.chargers ?? [])
        //     .toList() ?? [];
        final chargers =
            (widget.hub.stations?.expand((s) => s.chargers ?? []).toList() ??
                    [])
                .cast<Charger>();

        context.read<ChargingGunStatusProvider>().refreshAll(
              context: context,
              chargers: chargers,
            );
      },
    );
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _startPolling();
    context.read<ChargingHubReviewProvider>().fetchReviews(
          context: context,
          hubId: widget.hub.recId,
        );
    _fetchCurrentLocation();
  }
@override
void deactivate() {
  _statusTimer?.cancel();
  super.deactivate();
}

  void _openReviewsBottomSheet({
    required BuildContext context,
    required String stationId,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: CommonColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Consumer<ChargingHubReviewProvider>(
          builder: (context, provider, _) {
            if (provider.loading) {
              return const SizedBox(
                height: 300,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final reviews = provider.response?.reviews
                    // ?.where((r) => r.chargingStationId == stationId)
                    ?.toList() ??
                [];

            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.6, // 👈 60%
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // drag handle (optional but nice)
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

                    const Text(
                      "Customer Reviews",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 24),

                    /// ✅ THIS FIXES OVERFLOW
                    Expanded(
                      child: reviews.isEmpty
                          ? const Center(
                              child: Text("No reviews for this station"),
                            )
                          : ListView.builder(
                              itemCount: reviews.length,
                              itemBuilder: (context, index) {
                                return _reviewCard(reviews[index]);
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _reviewCard(ChargingHubReview review) {
    final initials = _getInitials(review.userName);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Username + rating
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 👤 Avatar
            CircleAvatar(
              radius: 18,
              backgroundColor: CommonColors.blue.withOpacity(0.15),
              child: Text(
                initials,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: CommonColors.blue,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.userName ?? "UnKnown",
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    formatReviewTime("${review.reviewTime}") ?? "UnKnown",
                    style: const TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 9,
                    ),
                  ),
                  Text(
                    review.description ?? "UnKnown",
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 12,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(5, (index) {
                      return Icon(
                        index < (review.rating ?? 0)
                            ? Icons.star
                            : Icons.star_border,
                        size: 14,
                        color: Colors.amber,
                      );
                    }),
                  ),
                ],
              ),
            ),

            MoreOptionsMenu(
              onEdit: () {
                _openWriteReviewBottomSheet(
                    hubID: widget.hub.recId,
                    stationId: review.chargingStationId!,
                    stationName: widget.hub.chargingHubName ?? "Station",
                    rating: review.rating,
                    description: review.description,
                    isEdit: true,
                    recId: review.recId);
              },
              onDelete: () async {
                showModalBottomSheet(
                  backgroundColor: CommonColors.white,
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  isScrollControlled: true,
                  builder: (_) => ConfirmationSheet(
                    title: "Are you sure you want to delete? ",
                    singleButton: "",
                    imagePath: CommonImagePath.delete, // Your SVG/PNG
                    isSingleButton: false,
                    onBackToHome: () {},
                    onCancel: () => Navigator.pop(context),
                    onLogout: () async {
                      final updatedResponse = await context
                          .read<ChargingHubReviewProvider>()
                          .deleteReview(context, review.recId!);

                      if (updatedResponse != null) {
                        showToast(updatedResponse.message);
                      } else {
                        showToast('Something went wrong');
                      }

                      Navigator.pop(context);
                    },
                    firstbutton: 'Cancel',
                    secondButton: 'Delete',
                    subHeading: '',
                  ),
                );
              },
            )
          ],
        ),
        Divider(
          color: CommonColors.hintGrey.withOpacity(0.1),
        ),
        const SizedBox(height: 6),
      ],
    );
  }

  String formatReviewTime(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString);

    return DateFormat('EEE ddMMM yyyy, HH.mm').format(dateTime);
  }

  String _getInitials(String? name) {
    if (name == null || name.trim().isEmpty) {
      return "U";
    }

    final parts = name.trim().split(RegExp(r'\s+'));

    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }

    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

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

  double distanceInKm = 0;
  @override
  Widget build(BuildContext context) {
    final reviewProvider = context.watch<ChargingHubReviewProvider>();
    final totalReviews = reviewProvider.response?.reviews?.length ?? 0;

    LatLng? location = LocationConvert.getLatLngFromHub(widget.hub);
    print("Cuurent");

    print("Hub Location");
    print(location!.latitude);
    print(location!.longitude);
    if (_currentPosition != null) {
      distanceInKm = Geolocator.distanceBetween(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
              location!.latitude,
              location!.longitude) /
          1000;
    }
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark));
    final w = MediaQuery.of(context).size.width;
    markers.add(widget.marker);
    return Scaffold(
      backgroundColor: CommonColors.white,
      appBar: CommonAppBar(
        title: "Station Details",
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _navigateButton(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // map placeholder
            _currentPosition == null
                ? Center(
                    child: CircularProgressIndicator(
                      color: CommonColors.blue,
                    ),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height *
                        0.35, // 35% of screen height
                    decoration: BoxDecoration(
                      color: CommonColors.mapDark,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: MiniMapWidget(
                      hub: widget.hub,
                      currentLocation: LatLng(_currentPosition!.latitude,
                          _currentPosition!.longitude),
                      hubLocation: LatLng(
                        location!.latitude ?? 0,
                        location!.longitude ?? 0,
                      ),
                    ),
                  ),

            // Container(
            //   height: w * 0.5,
            //   decoration: BoxDecoration(
            //     color: CommonColors.mapDark,
            //     borderRadius: BorderRadius.circular(12),
            //   ),
            //   child: GoogleMap(
            //     initialCameraPosition: CameraPosition(
            //       target: widget.location,
            //       zoom: 16,
            //       tilt: 45,
            //       bearing: 0,
            //     ),
            //     myLocationEnabled: false,
            //     myLocationButtonEnabled: false,
            //     onMapCreated: (controller) async {
            //       mapController = controller;
            //       String style = await DefaultAssetBundle.of(context)
            //           .loadString('assets/map_styles/dark_map.json');
            //       mapController!.setMapStyle(style);
            //     },
            //     markers: markers,
            //     zoomControlsEnabled: false,
            //     zoomGesturesEnabled: false,
            //     compassEnabled: false,
            //     mapToolbarEnabled: false,
            //     buildingsEnabled: false,
            //     trafficEnabled: false,
            //     tiltGesturesEnabled: false,
            //   ),
            // ),

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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                CommonImagePath.frame,
                                fit: BoxFit.cover,
                                height: SizeConfig.blockSizeVertical * 8,
                              ),
                              SizedBox(
                                  width: SizeConfig.blockSizeHorizontal * 2),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            widget.hub.chargingHubName ??
                                                "Charging Station",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: CommonColors.primary,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      widget.hub.addressLine1 ??
                                          "Address not available",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: CommonColors.primary,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print("open bottom ${widget.hub.recId!}");
                            _openReviewsBottomSheet(
                              context: context,
                              stationId: widget.hub.recId!, // fallback
                            );
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "${totalReviews} Reviews",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: CommonColors.blue,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                  height: 2), // 👈 SPACE between text & line
                              Container(
                                width: 40,
                                height: 1.5,
                                color: CommonColors.blue,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  _filterButtons(
                      opening: widget.hub.openingTime,
                      closing: widget.hub.closingTime,
                      availablePorts: widget.hub.availableChargers,
                      totalPorts: widget.hub.totalChargers),
                  const SizedBox(height: 12),
                  // Divider(
                  //   color: CommonColors.neutral200,
                  //   thickness: 2,
                  // ),
                  _stationsList(widget.hub.stations),
                  // chargerDetail()
                  // _navigateButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stationReviews(String stationId, String stationName, String hubId) {
    final provider = context.watch<ChargingHubReviewProvider>();
    final allReviews = provider.response?.reviews ?? [];

    final stationReviews =
        allReviews.where((r) => r.chargingStationId == stationId).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (stationReviews.isNotEmpty)
          ...stationReviews.map((review) => _reviewCard(review)).toList()
        else
          _reviewPlaceholder(),

        const SizedBox(height: 12),

        // ✍️ WRITE REVIEW BUTTON
        Center(
          child: OutlinedButton.icon(
            onPressed: () {
              _openWriteReviewBottomSheet(
                  hubID: hubId,
                  stationId: stationId,
                  stationName: stationName,
                  isEdit: false);
            },
            label: const Text(
              "Write a Review",
              style: TextStyle(color: CommonColors.blue),
            ),
          ),
        ),
      ],
    );
  }

  void _openWriteReviewBottomSheet(
      {required String stationId,
      required String stationName,
      required String hubID,
      int? rating,
      String? description,
      bool? isEdit,
      String? recId}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: CommonColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return _WriteReviewSheet(
          hubId: hubID,
          stationId: stationId,
          stationName: stationName,
          initialRating: rating,
          initialDescription: description,
          isEdit: isEdit!,
          recId: recId,
        );
      },
    );
  }

  // void _openWriteReviewBottomSheet({
  //   required String stationId,
  //   required String stationName,
  //   required String hubID
  // }) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (_) {
  //       return _WriteReviewSheet(
  //         hubId:hubID ,
  //         stationId: stationId,
  //         stationName: stationName,
  //       );
  //     },
  //   );
  // }

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
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }

  final Map<String, int> _stationTabIndex = {};
  Widget _stationTabs({
    required String stationId,
    required void Function(int index) onChanged,
  }) {
    final selectedIndex = _stationTabIndex[stationId] ?? 0;

    return Row(
      children: [
        Expanded(
          child: _tabButton(
            title: "Charger",
            isSelected: selectedIndex == 0,
            onTap: () => onChanged(0),
          ),
        ),
        Expanded(
          child: _tabButton(
            title: "Review",
            isSelected: selectedIndex == 1,
            onTap: () => onChanged(1),
          ),
        ),
      ],
    );
  }

  Widget _tabButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? CommonColors.blue : Colors.transparent,
              width: 2, // underline thickness
            ),
          ),
        ),
        alignment: Alignment.center, // center the text
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? CommonColors.blue : CommonColors.neutral500,
          ),
        ),
      ),
    );
  }

  Widget _chargerCard({
    required Charger charger,
    required bool isSelected,
    required bool isAvailable,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: isAvailable ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Material(
          elevation: 4, // 👈 card elevation
          borderRadius: BorderRadius.circular(10),
          color: CommonColors.white,
          shadowColor: Colors.black26,
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected
                  ? CommonColors.blue.withOpacity(0.1)
                  : CommonColors.white,
              border: Border.all(
                color: isSelected ? CommonColors.blue : Colors.transparent,
                width: 1.2,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color:
                        //  isSelected
                        //     ? CommonColors.blue.withOpacity(0.1)
                        //     :
                        CommonColors.neutral50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color:
                          // isSelected ? CommonColors.blue :
                          Colors.transparent,
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        CommonImagePath.station,
                        color: isAvailable ? null : CommonColors.blue,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Connector - ${charger.connectorName}" ??
                                  "Connector",
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "₹ 25/kW",
                              style: const TextStyle(
                                  fontSize: 12, color: CommonColors.blue),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isAvailable
                              ? CommonColors.darkgreen.withOpacity(0.15)
                              : Colors.red.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Consumer<ChargingGunStatusProvider>(
                          builder: (context, statusProvider, _) {
                            // Find the latest status for this charger
                            // final updatedCharger = statusProvider.chargers
                            //     .firstWhere(
                            //         (c) => c.connectorId == charger.connectorId,
                            //         orElse: () => charger);
// final updatedIsAvailable = statusProvider.gunStatusMap[charger.connectorId] ?? charger.lastStatus;

//       // final updatedIsAvailable = updatedCharger. == "Available";

//       return Text(
//        updatedIsAvailable ?? "Unknown",
//         style: TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.w500,
//           color: updatedIsAvailable ? CommonColors.darkgreen : Colors.red,
//         ),
//       );
                            final updatedCharger =
                                statusProvider.chargers[charger.connectorId] ??
                                    charger;
                            final updatedIsAvailable =
                                updatedCharger.lastStatus == "Available";

                            return Text(
                              updatedCharger.lastStatus ?? "Unknown",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: updatedIsAvailable
                                    ? CommonColors.darkgreen
                                    : Colors.red,
                              ),
                            );
                          },
                        ),
                      ),

                      // Container(
                      //   padding: const EdgeInsets.symmetric(
                      //       horizontal: 12, vertical: 6),
                      //   decoration: BoxDecoration(
                      //     color: isAvailable
                      //         ? CommonColors.darkgreen.withOpacity(0.15)
                      //         : Colors.red.withOpacity(0.15),
                      //     borderRadius: BorderRadius.circular(20),
                      //   ),
                      //   child: Text(
                      //     charger.lastStatus ?? "Unknown",
                      //     style: TextStyle(
                      //       fontSize: 12,
                      //       fontWeight: FontWeight.w500,
                      //       color: isAvailable
                      //           ? CommonColors.darkgreen
                      //           : Colors.red,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:  [
                        Text('Charger Type',
                            style: TextStyle(
                                fontWeight: FontWeight.w200, fontSize: 12)),
                        Text('${charger.chargerTypeName}',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 13)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:  [
                        Text('Power Output',
                            style: TextStyle(
                                fontWeight: FontWeight.w200, fontSize: 12)),
                        Text('${charger.powerOutput} KW',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 13)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:  [
                        Text('Plug Type',
                            style: TextStyle(
                                fontWeight: FontWeight.w200, fontSize: 12)),
                        Text('Type ${charger.chargerTariff}',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _stationsList(List<ChargingStation> stations) {
    return Column(
      children: stations.map((station) {
        final chargers = station.chargers ?? [];
        final selectedTab = _stationTabIndex[station.recId] ?? 0;

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
                const SizedBox(height: 12),
                _stationTabs(
                  stationId: station.recId!,
                  onChanged: (index) {
                    setState(() {
                      _stationTabIndex[station.recId!] = index;
                    });
                  },
                ),
                const SizedBox(height: 12),
                if (selectedTab == 0)
                  Column(
                    children: chargers.map((charger) {
                      final isAvailable = charger.lastStatus == "Available";
                      final isSelected = _selectedCharger?.connectorId ==
                              charger.connectorId &&
                          selectedStationID == station.recId;

                      return _chargerCard(
                        charger: charger,
                        isSelected: isSelected,
                        isAvailable: isAvailable,
                        onTap: () {
                          setState(() {
                            _selectedCharger = charger;
                            selectedStationID = station.recId;
                          });
                        },
                      );
                    }).toList(),
                  ),
                if (selectedTab == 1)
                  _stationReviews(station.recId!, station.chargePointName!,
                      widget.hub.recId),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _navigateButton() {
    final provider = context.watch<ChargingProvider>();

    final bool hasSelection = _selectedCharger != null;
    final bool isLoading = provider.loading;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: (!hasSelection || isLoading)
            ? null
            : () async {
                //  Navigator.push(
                //     routeGlobalKey.currentContext!,
                //     MaterialPageRoute(
                //       builder: (_) => ChargingEstimateScreen(),
                //     ),
                //   );

                final userId = await AuthStorage.getUserId();
                if (userId == null) return;

                final response = await provider.startSession(
                  context: context,
                  chargingGunId: _selectedCharger!.connectorName!,
                  chargingStationId: selectedStationID!,
                  userId: userId,
                  chargeTagId: "B4A63CDF",
                  connectorId:
                      int.parse(_selectedCharger!.connectorId!.toString()),
                  startMeterReading: "0",
                  chargingTariff: "typeATariff",
                );

                if (response != null && response.success) {
                  showToast("Charging session started successfully!");
                  print("SeesionID ${response.data!.session!.recId!}");
                  _statusTimer?.cancel();
                  Navigator.push(
                    routeGlobalKey.currentContext!,
                    MaterialPageRoute(
                      builder: (_) => SessionChargingScreen(
                        intitalResponse: response,
                      ),
                    ),
                  );
                } else {
                  showToast("Failed to start session");
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              hasSelection ? CommonColors.blue : CommonColors.hintGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(CommonColors.white),
                ),
              )
            : Text(
                hasSelection ? "Start Charging" : "Select a Charger",
                style: const TextStyle(color: CommonColors.white),
              ),
      ),
    );
  }

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
          _currentPosition != null
              ? _filterChip(distanceInKm != null
                  ? "${distanceInKm.toStringAsFixed(2)} km"
                  : "Distance N/A")
              : Container(),
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

  Widget _reviewPlaceholder() {
    return Container(
      width: SizeConfig.blockSizeHorizontal * 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CommonColors.neutral50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        "No reviews yet",
        style: TextStyle(
          fontSize: 13,
          color: CommonColors.neutral500,
        ),
      ),
    );
  }

  //  Widget _filterButtons() {
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

// class _WriteReviewSheet extends StatefulWidget {
//   final String hubId;
//   final String stationId;
//   final String stationName;

//   const _WriteReviewSheet({
//     required this.stationId,
//     required this.stationName, required this.hubId,
//   });

//   @override
//   State<_WriteReviewSheet> createState() => _WriteReviewSheetState();
// }
class _WriteReviewSheet extends StatefulWidget {
  final String hubId;
  final String stationId;
  final String stationName;
  final bool isEdit;

  /// 👇 optional for edit
  final int? initialRating;
  final String? initialDescription;
  final String? recId;

  const _WriteReviewSheet(
      {Key? key,
      required this.hubId,
      required this.stationId,
      required this.stationName,
      this.initialRating,
      this.initialDescription,
      required this.isEdit,
      this.recId})
      : super(key: key);

  @override
  State<_WriteReviewSheet> createState() => _WriteReviewSheetState();
}

class _WriteReviewSheetState extends State<_WriteReviewSheet> {
  int rating = 0;
  TextEditingController reviewCtrl = TextEditingController();
  @override
  void initState() {
    super.initState();

    rating = widget.initialRating ?? 0;
    reviewCtrl = TextEditingController(
      text: widget.initialDescription ?? '',
    );
  }

  @override
  void dispose() {
    reviewCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            widget.stationName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),

          // ⭐ Rating
          Row(
            children: List.generate(5, (index) {
              final starIndex = index + 1;

              return IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  setState(() {
                    if (rating == starIndex) {
                      rating = starIndex - 1; // 👈 remove only this star
                    } else {
                      rating = starIndex;
                    }
                  });
                },
                icon: Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 28,
                ),
              );
            }),
          ),

          // ✍️ Review Text
          CustomTextFieldWidget(
            isMandatory: false,
            title: "",
            hintText: "Share your experience",
            onChange: (val) {},
            textFieldLines: 4,
            textEditingController: reviewCtrl,
            autovalidateMode: AutovalidateMode.disabled,
          ),

          const SizedBox(height: 8),

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (rating == 0 || reviewCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please add rating & review"),
                    ),
                  );
                  return;
                }

                if (widget.isEdit) {
                  context.read<ChargingHubReviewProvider>().updateReview(
                      context: context,
                      chargingHubId: widget.hubId,
                      chargingStationId: widget.stationId,
                      rating: rating,
                      description: reviewCtrl.text,
                      recId: widget.recId!);
                } else {
                  context.read<ChargingHubReviewProvider>().addReview(
                        context: context,
                        chargingHubId: widget.hubId,
                        chargingStationId: widget.stationId,
                        rating: rating,
                        description: reviewCtrl.text,
                      );
                }

                // 🔥 CALL API HERE
                // context.read<ChargingHubReviewProvider>()
                //   .submitReview(widget.stationId, rating, reviewCtrl.text);

                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: CommonColors.blue,
                foregroundColor: CommonColors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: CommonColors.blue.withOpacity(0.4),
                    width: 0.8,
                  ),
                ),
              ),
              child: const Text(
                "Submit",
                style: TextStyle(
                    fontSize: 12,
                    color: CommonColors.white,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MoreOptionsMenu extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MoreOptionsMenu({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: const Icon(Icons.more_vert, color: CommonColors.blue),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) {
        if (value == 1) onEdit();
        if (value == 2) onDelete();
      },
      itemBuilder: (context) => const [
        PopupMenuItem(value: 1, child: Text("Edit")),
        PopupMenuItem(value: 2, child: Text("Delete")),
      ],
    );
  }
}
