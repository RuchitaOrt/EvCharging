import 'dart:async';
import 'dart:io';

import 'package:HyCharge/Provider/ChargingEstimateProvider.dart';
import 'package:HyCharge/Provider/ChargingGunStatusProvider.dart';
import 'package:HyCharge/Provider/ChargingHubReviewProvider.dart';
import 'package:HyCharge/Provider/ChargingProvider.dart';
import 'package:HyCharge/Provider/FileUploadProvider.dart';
import 'package:HyCharge/Provider/HubProvider.dart';
import 'package:HyCharge/Provider/WalletProvider.dart';
import 'package:HyCharge/Screens/ChargingEstimateScreen.dart';
import 'package:HyCharge/Screens/Controller/map_controller.dart';
import 'package:HyCharge/Screens/Controller/station_card_widget.dart';
import 'package:HyCharge/Screens/MainTab.dart';
import 'package:HyCharge/Screens/Map/MiniMapWidget.dart';
import 'package:HyCharge/Screens/SessionChargingScreen.dart';
import 'package:HyCharge/Utils/AuthStorage.dart';
import 'package:HyCharge/Utils/CommonAppBar.dart';
import 'package:HyCharge/Utils/LocationConvert.dart';
import 'package:HyCharge/Utils/ShowDialog.dart';
import 'package:HyCharge/Utils/ValidationHelper.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/Utils/commonimages.dart';
import 'package:HyCharge/Utils/commonstrings.dart';
import 'package:HyCharge/Utils/sizeConfig.dart';
import 'package:HyCharge/main.dart';
import 'package:HyCharge/model/ChargingGunStatusResponse.dart';
import 'package:HyCharge/model/ChargingHubReviewResponse.dart';
import 'package:HyCharge/model/LocalGunResponseModel.dart';

import 'package:HyCharge/model/UnifiedComprehensiveResponse.dart';
import 'package:HyCharge/widget/CommonButton.dart';
import 'package:HyCharge/widget/GlobalLists.dart';
import 'package:HyCharge/widget/LogoutConfirmationSheet.dart';
import 'package:HyCharge/widget/custom_text_field_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class StationDetailsScreen extends StatefulWidget {
  final Location hub;
  final Marker marker;
  final LatLng location;
  final List<dynamic> nearbyHubs;

  StationDetailsScreen({
    super.key,
    required this.hub,
    required this.marker,
    required this.location,
    required this.nearbyHubs,
  });

  @override
  State<StationDetailsScreen> createState() => _StationDetailsScreenState();
}

class _StationDetailsScreenState extends State<StationDetailsScreen> {
  GoogleMapController? mapController;

  Set<Marker> markers = {};
Map<String, bool> stationExpansionState = {};
  Connector? _selectedCharger;
  String? selectedStationID;
  Position? _currentPosition;
  Timer? _statusTimer;
  double currentWalletPrice = 0.0;
  void _startPolling() {
    final chargers =
        (widget.hub.stations?.expand((s) => s.connectors ?? []).toList() ?? [])
            .cast<Connector>();

    context.read<ChargingGunStatusProvider>().refreshAll(
          context: context,
          chargers: chargers,
        );

    _statusTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) {
        if (!mounted) return;

        print("CHAGRERs");
        print(chargers.length);

        context.read<ChargingGunStatusProvider>().refreshAll(
              context: context,
              chargers: chargers,
            );
      },
    );
  }


  String userId = "";
  getUserInfo() async {
    userId = (await AuthStorage.getUserId())!;
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    print("Current BALNCE");
    
     for (var station in widget.hub.stations ?? []) {
    stationExpansionState.putIfAbsent(station.id!, () => false);
  }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserInfo();
      context.read<WalletProvider>().fetchWallet(context);
      _startPolling();
      context.read<ChargingHubReviewProvider>().fetchReviews(
            context: context,
            hubId: widget.hub.id!,
          );
      _fetchCurrentLocation();
    });
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
          
            CircleAvatar(
              radius: 18,
              backgroundColor: CommonColors.blue.withOpacity(0.15),
              child: review.userProfileImage != null &&
                      review.userProfileImage!.isNotEmpty
                  ? FutureBuilder<Uint8List>(
                      future: context
                          .read<HubProvider>() // 👈 your provider class
                          .downloadImage(review.userProfileImage!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          );
                        }

                        if (snapshot.hasError || !snapshot.hasData) {
                          return Text(
                            initials,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: CommonColors.blue,
                            ),
                          );
                        }

                        return ClipOval(
                          child: Image.memory(
                            snapshot.data!,
                            fit: BoxFit.cover,
                            width: 36,
                            height: 36,
                          ),
                        );
                      },
                    )
                  : Text(
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
                  _buildReviewImages(review),
                ],
              ),
            ),

            review.userId == userId
                ? MoreOptionsMenu(
                    onEdit: () {
                      _openWriteReviewBottomSheet(
                        hubID: widget.hub.id!,
                        stationId: review.chargingStationId!,
                        stationName: widget.hub.name ?? "Station",
                        rating: review.rating,
                        description: review.description,
                        isEdit: true,
                        recId: review.recId,
                        img1: review.reviewImage1,
                        img2: review.reviewImage2,
                        img3: review.reviewImage3,
                        img4: review.reviewImage4,
                      );
                     
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
                              FocusScope.of(context).unfocus();
                              showToast(updatedResponse.message);
                            } else {
                              FocusScope.of(context).unfocus();
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
                : Container()
          ],
        ),
        Divider(
          color: CommonColors.hintGrey.withOpacity(0.1),
        ),
        const SizedBox(height: 6),
      ],
    );
  }

  Widget _buildReviewImages(review) {
    // Collect valid image IDs
    final imageIds = [
      review.reviewImage1,
      review.reviewImage2,
      review.reviewImage3,
      review.reviewImage4,
    ]
        .where((e) => e != null && e.toString().isNotEmpty && e != "string")
        .cast<String>()
        .toList();

    if (imageIds.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: SizedBox(
        height: 55,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: imageIds.length,
          separatorBuilder: (_, __) => const SizedBox(width: 6),
          itemBuilder: (context, index) {
            return _reviewImageBox(imageIds[index]);
          },
        ),
      ),
    );
  }

  void _showFixedImagePopup(BuildContext context, Uint8List bytes) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: SizeConfig.blockSizeHorizontal *
                  80, // same width for all images
              height: SizeConfig.blockSizeVertical *
                  70, // same height for all images
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  /// Image (same size box)
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        bytes,
                        fit: BoxFit.contain, // keeps aspect ratio
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),

                  /// Close Button
                  Positioned(
                    right: 0,
                    top: 0,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.black54,
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _reviewImageBox(String imageId) {
    return FutureBuilder<Uint8List>(
      future: context
          .read<HubProvider>() // 👈 your provider class
          .downloadImage(imageId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _imagePlaceholder();
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return _imagePlaceholder();
        }

        final bytes = snapshot.data!;

        return GestureDetector(
          onTap: () {
            _showFixedImagePopup(context, bytes);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.memory(
              bytes,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const Icon(
        Icons.image,
        size: 18,
        color: Colors.grey,
      ),
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

    LatLng? location = LocationConvert.getLatLngFromUnifiedHub(widget.hub);
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
    final walletProvider = context.watch<WalletProvider>();

    currentWalletPrice = walletProvider.currentBalance;

    markers.add(widget.marker);
    return SafeArea(
      child:
       Scaffold(
        backgroundColor: CommonColors.background,
        // appBar: CommonAppBar(
        //   title: "Station Details",
        // ),
        bottomNavigationBar: SafeArea(
  top: false,
  child: Container(
    padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
     decoration: const BoxDecoration(
    color: CommonColors.cardWhite,
    border: Border(
      top: BorderSide(color: Color(0xFFE1E5EB), width: 1), // outlineVariant divider
    ),
  ),
    // color: Colors.white,
    child: _navigateButton(),
  ),
),
        // bottomNavigationBar: Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: _navigateButton(),
        // ),

body: SingleChildScrollView(
  child: Column(
    children: [
      // MAP SECTION
   Stack(
  children: [
    SizedBox(
      height: MediaQuery.of(context).size.height * 0.22,
      width: double.infinity,
      child: _currentPosition == null
          ? const Center(
              child: CircularProgressIndicator(
                color: CommonColors.blue,
              ),
            )
          : MiniMapWidget(
              nearbyHubs: widget.nearbyHubs,
              hub: widget.hub,
              currentLocation: LatLng(
                _currentPosition!.latitude,
                _currentPosition!.longitude,
              ),
              hubLocation: LatLng(
                location!.latitude,
                location!.longitude,
              ),
            ),
    ),

    // Back button on the left side of the map
    Positioned(
      left: 12,
      top: 12,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MainTab(
                isLoggedIn: GlobalLists.islLogin,
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(
            CommonImagePath.back,
            width: 24,
            height: 24
            ,fit: BoxFit.contain,
          ),
        ),
      ),
    ),
  ],
),
      // STATION DETAILS CARD OVERLAPS MAP
      Transform.translate(
        offset: const Offset(0, -24),
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 0),
          
          decoration: BoxDecoration(
             color: CommonColors.background,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24),topRight: Radius.circular(24)),
            // border: Border.all(
            //   color: const Color(0xFFEDF0F5),
            // ),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.black.withOpacity(0.08),
            //     blurRadius: 16,
            //     offset: const Offset(0, 5),
            //   ),
            // ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                    Container(
                        padding: const EdgeInsets.only(left: 15,right: 15,),
                        // decoration: BoxDecoration(
                        //   color: CommonColors.neutral50,
                        //   borderRadius: BorderRadius.circular(24),
                        // ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                 
                                  // widget.hub.chargingHubImage != null
                                  //     ? HubImage(
                                  //         imageId: widget.hub.chargingHubImage!,
                                  //         height:
                                  //             SizeConfig.blockSizeVertical * 5,
                                  //         width: SizeConfig.blockSizeVertical * 5,
                                  //       )
                                  //     : 
                                      Image.asset(
                                          CommonImagePath.frame,
                                          height:
                                              SizeConfig.blockSizeVertical * 6,
                                        ),
                                  SizedBox(
                                      width: SizeConfig.blockSizeHorizontal * 2),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      CommonImagePath.stationImage,
                      height: 58,
                      width: 58,
                      fit: BoxFit.cover,
                    ),
                  ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      widget.hub.name ??
                                                          "Charging Station",
                                                      style: TextStyle(
                                                         fontFamily: 'Poppins',
                                                          fontSize: 14,
                                                          color: CommonColors.black,
                                                          fontWeight: FontWeight.w800),
                                                    ),
                                                       Text(
                                                                                        widget.hub.addressLine1 ??
                                                "Address not available",
                                                                                        style: TextStyle(
                                                                                           fontFamily: 'Poppins',
                                                fontSize: 12,
                                                color: CommonColors.black,
                                                fontWeight: FontWeight.w300),
                                                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                     
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                print("open bottom ${widget.hub.id!}");
                                _openReviewsBottomSheet(
                                  context: context,
                                  stationId: widget.hub.id!, // fallback
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(CommonImagePath.stargold,width: 14,height: 14,),
                                        SizedBox(width: 5,),
                                        Text(
                                                                          totalReviews==0 ?"Reviews":    "${totalReviews} Reviews",
                                          style: TextStyle(
                                            fontSize: 12,
                                             fontFamily: 'Poppins',
                                            color: CommonColors.blue,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // const SizedBox(
                                    //     height: 2), // 👈 SPACE between text & line
                                    // Container(
                                    //   width: 40,
                                    //   height: 1.5,
                                    //   color: CommonColors.blue,
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
            
                Padding(
                  padding: const EdgeInsets.only(left: 15,right: 15,top: 10),
                  child:
                   _stationsList(widget.hub.stations ?? []),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  ),
),

//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               // map placeholder
//               // map placeholder
// _currentPosition == null
//     ? Center(
//         child: CircularProgressIndicator(
//           color: CommonColors.blue,
//         ),
//       )
//     : Container(
//         height: MediaQuery.of(context).size.height * 0.28,
//         decoration: BoxDecoration(
//           color: CommonColors.mapDark,
//         ),
//         child: MiniMapWidget(
//           nearbyHubs: widget.nearbyHubs,
//           hub: widget.hub,
//           currentLocation: LatLng(
//             _currentPosition!.latitude,
//             _currentPosition!.longitude,
//           ),
//           hubLocation: LatLng(
//             location!.latitude ?? 0,
//             location!.longitude ?? 0,
//           ),
//         ),
//       ),
//               // _currentPosition == null
//               //     ? Center(
//               //         child: CircularProgressIndicator(
//               //           color: CommonColors.blue,
//               //         ),
//               //       )
//               //     : Container(
//               //         height: MediaQuery.of(context).size.height *
//               //             0.28, // 35% of screen height
//               //         decoration: BoxDecoration(
//               //           color: CommonColors.mapDark,
//               //           //  borderRadius: BorderRadius.circular(12),
//               //         ),
//               //         child: MiniMapWidget(
//               //           nearbyHubs: widget.nearbyHubs,
//               //           hub: widget.hub,
//               //           currentLocation: LatLng(_currentPosition!.latitude,
//               //               _currentPosition!.longitude),
//               //           hubLocation: LatLng(
//               //             location!.latitude ?? 0,
//               //             location!.longitude ?? 0,
//               //           ),
//               //         ),
//               //       ),

//               Container(
//                 // margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
//   padding: const EdgeInsets.all(16),
//   decoration: BoxDecoration(
//     color: Colors.white,
//     borderRadius: BorderRadius.circular(22),
//     border: Border.all(
//       color: const Color(0xFFEDF0F5),
//     ),
//     boxShadow: [
//       BoxShadow(
//         color: Colors.black.withOpacity(0.06),
//         blurRadius: 16,
//         offset: const Offset(0, 5),
//       ),
//     ],
//   ),
//                 // padding: const EdgeInsets.all(8),
//                 // decoration: BoxDecoration(
//                 //   color: CommonColors.white,
//                 //   borderRadius: BorderRadius.circular(12),
//                 // ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: CommonColors.neutral50,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
                               
//                                 // widget.hub.chargingHubImage != null
//                                 //     ? HubImage(
//                                 //         imageId: widget.hub.chargingHubImage!,
//                                 //         height:
//                                 //             SizeConfig.blockSizeVertical * 5,
//                                 //         width: SizeConfig.blockSizeVertical * 5,
//                                 //       )
//                                 //     : 
//                                     Image.asset(
//                                         CommonImagePath.frame,
//                                         height:
//                                             SizeConfig.blockSizeVertical * 6,
//                                       ),
//                                 SizedBox(
//                                     width: SizeConfig.blockSizeHorizontal * 2),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: [
//                                       Row(
//                                         children: [
//                                           Expanded(
//                                             child: Text(
//                                               widget.hub.name ??
//                                                   "Charging Station",
//                                               style: TextStyle(
//                                                   fontSize: 18,
//                                                   color: CommonColors.primary,
//                                                   fontWeight: FontWeight.w500),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Text(
//                                         widget.hub.addressLine1 ??
//                                             "Address not available",
//                                         style: TextStyle(
//                                             fontSize: 12,
//                                             color: CommonColors.primary,
//                                             fontWeight: FontWeight.w400),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               print("open bottom ${widget.hub.id!}");
//                               _openReviewsBottomSheet(
//                                 context: context,
//                                 stationId: widget.hub.id!, // fallback
//                               );
//                             },
//                             child: Padding(
//                               padding: const EdgeInsets.only(top: 2),
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Text(
//                                 totalReviews==0 ?"Reviews":    "${totalReviews} Reviews",
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       color: CommonColors.blue,
//                                       fontWeight: FontWeight.w400,
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                       height: 2), // 👈 SPACE between text & line
//                                   Container(
//                                     width: 40,
//                                     height: 1.5,
//                                     color: CommonColors.blue,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     // _filterButtons(
//                     //     opening: widget.hub.openingTime,
//                     //     closing: widget.hub.closingTime,
//                     //     availablePorts: widget.hub.availableChargers,
//                     //     totalPorts: widget.hub.totalChargers
//                     //     ),
//                     // const SizedBox(height: 12),
                    
//                     _stationsList(widget.hub.stations!),
                   
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
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

  void _openWriteReviewBottomSheet({
    required String stationId,
    required String stationName,
    required String hubID,
    int? rating,
    String? description,
    bool? isEdit,
    String? recId,
    String? img1,
    String? img2,
    String? img3,
    String? img4,
  }) {
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
          reviewImage1: img1,
          reviewImage2: img2,
          reviewImage3: img3,
          reviewImage4: img4,
        );
      },
    );
  }

  final Map<String, int> _stationTabIndex = {};

Widget _stationTabs({
  required String stationId,
  required void Function(int index) onChanged,
}) {
  final selectedIndex = _stationTabIndex[stationId] ?? 0;

  return Container(
    height: 44,
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: const Color(0xFFEEF0F5),
      borderRadius: BorderRadius.circular(30),
    ),
    child: Row(
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
    ),
  );
}

Widget _tabButton({
  required String title,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF142F78)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isSelected
              ? Colors.white
              : const Color(0xFF657087),
        ),
      ),
    ),
  );
}

  // Widget _stationTabs({
  //   required String stationId,
  //   required void Function(int index) onChanged,
  // }) {
  //   final selectedIndex = _stationTabIndex[stationId] ?? 0;

  //   return Row(
  //     children: [
  //       Expanded(
  //         child: _tabButton(
  //           title: "Charger",
  //           isSelected: selectedIndex == 0,
  //           onTap: () => onChanged(0),
  //         ),
  //       ),
  //       Expanded(
  //         child: _tabButton(
  //           title: "Review",
  //           isSelected: selectedIndex == 1,
  //           onTap: () => onChanged(1),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _tabButton({
  //   required String title,
  //   required bool isSelected,
  //   required VoidCallback onTap,
  // }) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(vertical: 12),
  //       decoration: BoxDecoration(
  //         border: Border(
  //           bottom: BorderSide(
  //             color: isSelected ? CommonColors.blue : Colors.transparent,
  //             width: 2, // underline thickness
  //           ),
  //         ),
  //       ),
  //       alignment: Alignment.center, // center the text
  //       child: Text(
  //         title,
  //         style: TextStyle(
  //           fontSize: 14,
  //           fontWeight: FontWeight.w600,
  //           color: isSelected ? CommonColors.blue : CommonColors.neutral500,
  //         ),
  //       ),
  //     ),
  //   );
  // }

Widget _chargerCard({
  required Connector charger,
  required bool isSelected,
  required bool isAvailable,
  required VoidCallback onTap,
}) {
  const navy = Color(0xFF142F78);
  const lightGray = Color(0xFFEEF0F5);
  const mutedText = Color(0xFF70798B);

  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFFF4F7FF)
            : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected
              ? navy
              : const Color(0xFFDDE3ED),
          width: isSelected ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Connector header
          Row(
            children: [
             Container(
  width: 42,
  height: 42,
  decoration: const BoxDecoration(
    color: lightGray,
    shape: BoxShape.circle,
  ),
  alignment: Alignment.center,
  child: SvgPicture.asset(
    CommonImagePath.plugdark,
    width: 20,
    height: 20,
    fit: BoxFit.contain,
  ),
),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Connector ${charger.connectorId ?? ''}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF17233F),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      charger.id?.toString() ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10,
                        color: mutedText,
                      ),
                    ),
                  ],
                ),
              ),
              Consumer<ChargingGunStatusProvider>(
                builder: (context, provider, _) {
                  final updatedCharger =
                      provider.chargers[charger.id] ?? charger;

                  final available =
                      updatedCharger.status == "AVAILABLE" ||
                      updatedCharger.status == "Available";

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: available
                          ? const Color(0xFFD8F8E2)
                          : const Color(0xFFFFE4E4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      updatedCharger.status ?? "Unknown",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: available
                            ? const Color(0xFF159447)
                            : const Color(0xFFD64545),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Charger information panel
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: lightGray,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _chargerInfoItem(
                    "Price",
                    "₹${charger.tariff}/kW",
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _chargerInfoItem(
                    "Charger Type",
                    charger.chargerTypeName ?? "N/A",
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _chargerInfoItem(
                    "Power Output",
                    "upto ${charger.powerOutput ?? 'N/A'} kW",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _chargerInfoItem(String label, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 10,
          color: Color(0xFF70798B),
          fontWeight: FontWeight.w400,
        ),
      ),
      const SizedBox(height: 5),
      Text(
        value,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 12,
          height: 1.3,
          color: Color(0xFF17233F),
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}

//   Widget _chargerCard({
//     required Connector charger,
//     required bool isSelected,
//     required bool isAvailable,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap:
//        onTap,
//      // isAvailable ? onTap : null,
//       child: Padding(
//         padding: const EdgeInsets.only(bottom: 10),
//         child: Material(
//           elevation: 4, // 👈 card elevation
//           borderRadius: BorderRadius.circular(10),
//           color: CommonColors.white,
//           shadowColor: Colors.black26,
//           child: Container(
//             //margin: const EdgeInsets.only(bottom: 8),
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: isSelected
//                   ? CommonColors.blue.withOpacity(0.1)
//                   : CommonColors.white,
//               border: Border.all(
//                 color: isSelected ? CommonColors.blue : CommonColors.blue,
//                 width:isSelected? 1.2:0.5,
//               ),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Column(
//               children: [
//                 Container(
//                   margin: const EdgeInsets.only(bottom: 8),
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color:
//                         //  isSelected
//                         //     ? CommonColors.blue.withOpacity(0.1)
//                         //     :
//                         CommonColors.neutral50,
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(
//                       color:
//                           // isSelected ? CommonColors.blue :
//                           Colors.transparent,
//                       width: 1.2,
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       SvgPicture.asset(
//                         CommonImagePath.station,
//                         color: isAvailable ? null : CommonColors.blue,
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               "Connector - ${charger.connectorId} ${charger.id}" ??
//                                   "Connector",
//                               style: const TextStyle(
//                                   fontWeight: FontWeight.w600, fontSize: 13),
//                             ),
//                             //  Text(
//                             //   "Connector - ${charger.recId}" ??
//                             //       "Connector",
//                             //   style: const TextStyle(
//                             //       fontWeight: FontWeight.w600, fontSize: 13),
//                             // ),
//                             const SizedBox(height: 2),
//                             Text(
//                               "₹ ${charger.tariff}/kW",
//                               style: const TextStyle(
//                                   fontSize: 12, color: CommonColors.blue),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Consumer<ChargingGunStatusProvider>(
//                         builder: (context, provider, _) {
//                           // final updatedCharger = provider
//                           //         .chargers[int.parse(charger.connectorId!)] ??
//                           //     charger;
//                           final updatedCharger =
//                               provider.chargers[charger.id] ?? charger;
                           
//                           final isAvailable =
//                                (updatedCharger.status == "AVAILABLE" ||updatedCharger.status == "Available");
// print("Ranga ${updatedCharger.status} ${isAvailable}");
//                           return Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 12, vertical: 6),
//                             decoration: BoxDecoration(
//                               color: isAvailable
//                                   ? CommonColors.darkgreen.withOpacity(0.15)
//                                   : Colors.red.withOpacity(0.15),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Text(
//                                updatedCharger.status ?? "Unknown",
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: isAvailable
//                                     ? CommonColors.darkgreen
//                                     : Colors.red,
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 // Text("${charger.recId}"),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   //spaceBetween
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
                        
//                         Text('Charger Type',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w200, fontSize: 11)),
//                         Text('${charger.chargerTypeName}',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w600, fontSize: 13)),
//                       ],
//                     ),
//                     SizedBox(
//                       width: 20,
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Power Output',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w200, fontSize: 12)),
//                         Text('upto ${charger.powerOutput} KW',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w600, fontSize: 13)),
//                       ],
//                     ),
//                     // Column(
//                     //   crossAxisAlignment: CrossAxisAlignment.start,
//                     //   children: [
//                     //     Text('Plug Type',
//                     //         style: TextStyle(
//                     //             fontWeight: FontWeight.w200, fontSize: 12)),
//                     //     Text('Type ${charger.chargerTariff}',
//                     //         style: TextStyle(
//                     //             fontWeight: FontWeight.w600, fontSize: 13)),
//                     //   ],
//                     // ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

Widget _stationsList(List<Station> stations) {
  const navy = Color(0xFF142F78);
  const mutedText = Color(0xFF70798B);

  return Column(
    children: stations.map((station) {
      final chargers = station.connectors ?? [];
      final stationId = station.id!;
      final selectedTab = _stationTabIndex[stationId] ?? 0;
      final isExpanded = stationExpansionState[stationId] ?? false;

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          // border: Border.all(
          //   color: const Color(0xFFE5E9F0),
          // ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // Station header
            InkWell(
              onTap: () {
                setState(() {
                  stationExpansionState.forEach((key, value) {
                    stationExpansionState[key] = false;
                  });

                  stationExpansionState[stationId] = !isExpanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE9EEFF),
                        shape: BoxShape.circle,
                      ),
                      child:station.id == CommonStrings.strDummyBikeRecId? Icon(
                        station.id == CommonStrings.strDummyBikeRecId
                            ? Icons.pedal_bike_rounded
                            : Icons.bolt_rounded,
                        color: navy,
                        size: 20,
                      ):Image.asset(CommonImagePath.borderGreen,color: CommonColors.primary,width: 14,height: 14,),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            capitalizeWords(
                              station.name ?? "Charging Station",
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF17233F),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "${station.availableConnectors}/${station.totalConnectors} Chargers Available",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: (station.availableConnectors ?? 0) > 0
                                  ? const Color(0xFF159447)
                                  : mutedText,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Refresh charger status
                    Consumer<ChargingGunStatusProvider>(
                      builder: (context, provider, child) {
                        final id = stationId.toString();
                        final refreshing =
                            provider.loadingStationIds.contains(id);

                        return IconButton(
                          visualDensity: VisualDensity.compact,
                          tooltip: "Refresh status",
                          onPressed: refreshing
                              ? null
                              : () async {
                                  await provider.getLocations(
                                    context,
                                    widget.hub.id.toString(),
                                    stationID: id,
                                  );
                                },
                          icon: refreshing
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: navy,
                                  ),
                                )
                              : SvgPicture.asset(CommonImagePath.refresh_muted,width: 14,height: 14,),
                        );
                      },
                    ),

                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: mutedText,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),

            // Expanded content
            if (isExpanded) ...[
              const Divider(
                height: 1,
                color: Color(0xFFEDF0F5),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 4),
                child: _stationTabs(
                  stationId: stationId,
                  onChanged: (index) {
                    setState(() {
                      _stationTabIndex[stationId] = index;
                    });
                  },
                ),
              ),

              const SizedBox(height: 12),

              if (selectedTab == 0)
                if (chargers.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "No chargers available",
                      style: TextStyle(
                        color: mutedText,
                        fontSize: 13,
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: chargers.map((charger) {
                        final isAvailable =
                            charger.status == "Available" ||
                            charger.status == "AVAILABLE" ||
                            charger.status == "BLOCKED" ||
                            charger.status == "Blocked" ||
                            charger.status == "Occupied";

                        final isSelected =
                            _selectedCharger?.connectorId ==
                                charger.connectorId &&
                            selectedStationID == stationId;

                        return _chargerCard(
                          charger: charger,
                          isSelected: isSelected,
                          isAvailable: isAvailable,
                          onTap: () {
                            setState(() {
                              _selectedCharger = charger;
                              selectedStationID = stationId;
                            });

                            showToast(
                              charger.chargerTypeName ?? "Charger selected",
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),

              if (selectedTab == 1)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: _stationReviews(
                    stationId,
                    station.name ?? "Charging Station",
                    widget.hub.id!,
                  ),
                ),

              const SizedBox(height: 8),
            ],
          ],
        ),
      );
    }).toList(),
  );
}

// Widget _stationsList(List<Station> stations) {
//   print("How many station");
//   print(stations.length);
//   for(var sta in stations)
//   {
//     print(sta.name);
//   }
//   return Column(
//     children: stations.map((station) {
//       final chargers = station.connectors ?? [];
//       final selectedTab = _stationTabIndex[station.id] ?? 0;
//       final isExpanded = stationExpansionState[station.id] ?? false;

//       return Padding(
//         padding: const EdgeInsets.only(bottom: 12),
//         child: Container(
//           decoration: BoxDecoration(
//             color: CommonColors.white,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(
//               color: CommonColors.blue,
//               width: 2,
//             ),
//           ),
//           child: Column(
//             children: [
//               /// 🔹 HEADER (CLICKABLE)
//               GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     /// close others (optional)
//                     stationExpansionState.forEach((key, value) {
//                       stationExpansionState[key] = false;
//                     });

//                     /// toggle current
//                     stationExpansionState[station.id!] = !isExpanded;
//                   });
//                 },
//                 child: Container(
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     color: CommonColors.blue,
//                     borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(10),
//                       topRight: Radius.circular(10),
//                     ),
//                   ),
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 12, vertical: 12),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
                            
//                             Row(
//                               children: [
//                                  station.id==CommonStrings.strDummyBikeRecId?Row(
//                                    children: [
//                                      Icon(Icons.pedal_bike,color: CommonColors.cardWhite,),
//                                      SizedBox(width: 8,)
//                                    ],
//                                  ):Container(),
//                                 Row(
//                                   children: [
//                                     Text(
//                                       capitalizeWords(
//                                           station.name ?? "Station"),
//                                       style: const TextStyle(
//                                           color: CommonColors.white,
//                                           fontSize: 15,
//                                           fontWeight: FontWeight.w600),
//                                     ),
//                                     SizedBox(width: 20,),
                                    
                                 
//                                   ],
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               "${station.availableConnectors}/${station.totalConnectors} Chargers Available",
//                               style: const TextStyle(
//                                   fontSize: 12,
//                                   color: CommonColors.white),
//                             ),
//                           ],
//                         ),
//                       ),

//                       /// 🔹 ARROW
//                       Row(
//                         children: [
                
// Consumer<ChargingGunStatusProvider>(
//   builder: (context, provider, child) {
//     final stationID = station.id.toString();

//     final isRefreshing =
//         provider.loadingStationIds.contains(stationID);

//     return GestureDetector(
//       onTap: isRefreshing
//           ? null
//           : () async {
//               await provider.getLocations(
//                 context,
//                 widget.hub.id.toString(),
//                 stationID: stationID,
//               );
//             },
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: SizedBox(
//           width: 20,
//           height: 20,
//           child: isRefreshing
//               ? const CircularProgressIndicator(
//                   strokeWidth: 2,
//                   color: CommonColors.white,
//                 )
//               : const Icon(
//                   Icons.refresh,
//                   color: CommonColors.white,
//                   size: 20,
//                 ),
//         ),
//       ),
//     );
//   },
// ),

// //                            GestureDetector(
// //   onTap: () async {
// //     await Provider.of<ChargingGunStatusProvider>(
// //       context,
// //       listen: false,
// //     ).getLocations(
// //       context,
// //       widget.hub.id!,
// //     );
// //   },
// //   child: const Icon(
// //     Icons.refresh,
// //     color: CommonColors.white,
// //   ),
// // ),
// SizedBox(width: 5,),
//                           Icon(
//                             isExpanded
//                                 ? Icons.keyboard_arrow_up
//                                 : Icons.keyboard_arrow_down,
//                             color: CommonColors.white,
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ),

//               /// 🔹 EXPANDABLE CONTENT
//               if (isExpanded) ...[
//                 const SizedBox(height: 12),

//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                   child: _stationTabs(
//                     stationId: station.id!,
//                     onChanged: (index) {
//                       setState(() {
//                         _stationTabIndex[station.id!] = index;
//                       });
//                     },
//                   ),
//                 ),

//                 const SizedBox(height: 12),

//                 if (selectedTab == 0)
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     child: Column(
//                       children: chargers.map((charger) {
//                         final isAvailable =
//                             (charger.status == "Available" ||charger.status == "AVAILABLE" || charger.status=="BLOCKED" || charger.status == "Blocked"|| charger.status == "Occupied");

//                         final isSelected =
//                             _selectedCharger?.connectorId ==
//                                     charger.connectorId &&
//                                 selectedStationID == station.id;

//                         return
//                          _chargerCard(
//                           charger: charger,
//                           isSelected: isSelected,
//                           isAvailable: isAvailable,
//                           onTap: () {
//                             setState(() {
//                               _selectedCharger = charger;
//                               selectedStationID = station.id;
//                               showToast(
//                                   _selectedCharger!.chargerTypeName!);
//                             });
//                           },
//                         );
//                       }).toList(),
//                     ),
//                   ),

//                 if (selectedTab == 1)
//                   _stationReviews(
//                     station.id!,
//                     station.name!,
//                     widget.hub.id!,
//                   ),

//                 const SizedBox(height: 12),
//               ],
//             ],
//           ),
//         ),
//       );
//     }).toList(),
//   );
// }
  
  Widget _navigateButton() {
    final provider = context.watch<ChargingGunStatusProvider>();

    final bool hasSelection = _selectedCharger != null;
    final bool isLoading = provider.loading;

    return 
      CommonButton(
        titleColor: hasSelection ? CommonColors.white : CommonColors.hintGrey,
        backgroundColor:   hasSelection ? CommonColors.blue : CommonColors.background,
      title:  hasSelection ? "Charge Now" : "Select a Charger",
         onPressed: (!hasSelection || isLoading)
            ? null
            : () async {
                if (_selectedCharger == null) return;

                // 1️⃣ Fetch the status
                final statusAvailable = await context
                    .read<ChargingGunStatusProvider>()
                    .fetchGunStatusValue(
                      context: context,
                      charger: _selectedCharger!,
                    );

                // 2️⃣ Check the status
               if (statusAvailable == null) {
  showToast("Unable to fetch charging gun status.");
  return;
}
print("status at station");
String? status;

if (statusAvailable is ChargingGunStatusResponse) {
  status = statusAvailable.data?.status;
} else if (statusAvailable is LocalGunResponseModel) {
  status = statusAvailable.data?.status?.status;
}
print("status at station 1");
print("STATUS = $status");
                if (status == "Available" || status=="AVAILABLE" ||  status=="BLOCKED" ||  status=="Blocked"|| status == "Occupied") {
                  print("status at station 2");
                  // ✅ Status is available, navigate
                  bool? confirmed = await gunConnectorDialog(
  context,
  message: "Plug the charging connector into your vehicle to begin charging.",
);
// Stop if the user taps Cancel or dismisses the dialog.
if (confirmed != true || !mounted) {
  return;
}

    print("CHARGE NOW confirmed ${confirmed}");
// if (confirmed == true) {
  //18july
  print("status at station 3");
  print("23jult");
  print(_selectedCharger!.connectorId!);
 _statusTimer?.cancel();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChangeNotifierProvider(
                        create: (_) => ChargingEstimateProvider(),
                        child: ChargingEstimateScreen(
                          selectedCharger: _selectedCharger,
                          selectedStationID: selectedStationID,
                          
                   
                        ),
                      ),
                    ),
                  );
}
                // } else {
                //   FocusScope.of(context).unfocus();
                //   showToast(
                //       "Charging gun status is not available. Please try again.");
                // }
               
              },
    
    );
    
    
//     SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         onPressed: (!hasSelection || isLoading)
//             ? null
//             : () async {
//                 if (_selectedCharger == null) return;

//                 // 1️⃣ Fetch the status
//                 final statusAvailable = await context
//                     .read<ChargingGunStatusProvider>()
//                     .fetchGunStatusValue(
//                       context: context,
//                       charger: _selectedCharger!,
//                     );

//                 // 2️⃣ Check the status
//                if (statusAvailable == null) {
//   showToast("Unable to fetch charging gun status.");
//   return;
// }
// print("status at station");
// String? status;

// if (statusAvailable is ChargingGunStatusResponse) {
//   status = statusAvailable.data?.status;
// } else if (statusAvailable is LocalGunResponseModel) {
//   status = statusAvailable.data?.status?.status;
// }
// print("status at station 1");
// print("STATUS = $status");
//                 if (status == "Available" || status=="AVAILABLE" ||  status=="BLOCKED" ||  status=="Blocked"|| status == "Occupied") {
//                   print("status at station 2");
//                   // ✅ Status is available, navigate
//                   bool? confirmed = await gunConnectorDialog(
//   context,
//   message: "Plug the charging connector into your vehicle to begin charging.",
// );
//     print("CHARGE NOW confirmed ${confirmed}");
// // if (confirmed == true) {
//   //18july
//   print("status at station 3");
//   print("23jult");
//   print(_selectedCharger!.connectorId!);
//  _statusTimer?.cancel();
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => ChangeNotifierProvider(
//                         create: (_) => ChargingEstimateProvider(),
//                         child: ChargingEstimateScreen(
//                           selectedCharger: _selectedCharger,
//                           selectedStationID: selectedStationID,
                          
                   
//                         ),
//                       ),
//                     ),
//                   );
// }
//                 // } else {
//                 //   FocusScope.of(context).unfocus();
//                 //   showToast(
//                 //       "Charging gun status is not available. Please try again.");
//                 // }
               
//               },
//         style: ElevatedButton.styleFrom(
//           backgroundColor:
//               hasSelection ? CommonColors.blue : CommonColors.hintGrey,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           padding: const EdgeInsets.symmetric(vertical: 14),
//         ),
//         child: isLoading
//             ? const SizedBox(
//                 height: 22,
//                 width: 22,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2.5,
//                   valueColor: AlwaysStoppedAnimation<Color>(CommonColors.white),
//                 ),
//               )
//             : Text(
//                 hasSelection ? "Charge Now" : "Select a Charger",
//                 style: const TextStyle(color: CommonColors.white),
//               ),
//       ),
//     );
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

}

class _WriteReviewSheet extends StatefulWidget {
  final String hubId;
  final String stationId;
  final String stationName;
  final bool isEdit;

  final int? initialRating;
  final String? initialDescription;
  final String? recId;

  /// Existing images (for edit)
  final String? reviewImage1;
  final String? reviewImage2;
  final String? reviewImage3;
  final String? reviewImage4;

  const _WriteReviewSheet({
    Key? key,
    required this.hubId,
    required this.stationId,
    required this.stationName,
    required this.isEdit,
    this.initialRating,
    this.initialDescription,
    this.recId,
    this.reviewImage1,
    this.reviewImage2,
    this.reviewImage3,
    this.reviewImage4,
  }) : super(key: key);

  @override
  State<_WriteReviewSheet> createState() => _WriteReviewSheetState();
}

class _WriteReviewSheetState extends State<_WriteReviewSheet> {
  int rating = 0;
  TextEditingController reviewCtrl = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  List<File> selectedImages = [];
  List<String> uploadedImageIds = [];

  /// Existing image IDs
  List<String> existingImageIds = [];

  @override
  void initState() {
    super.initState();

    rating = widget.initialRating ?? 0;
    reviewCtrl.text = widget.initialDescription ?? '';

    existingImageIds = [
      widget.reviewImage1,
      widget.reviewImage2,
      widget.reviewImage3,
      widget.reviewImage4,
    ]
        .where((e) => e != null && e.toString().isNotEmpty)
        .cast<String>()
        .toList();
  }

  Future<void> _pickImages() async {
    int total = existingImageIds.length + selectedImages.length;

    if (total >= 4) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Maximum 4 images allowed")));
      return;
    }

    final images = await _picker.pickMultiImage();
    if (images == null) return;

    int remaining = 4 - total;

    setState(() {
      selectedImages.addAll(
        images.take(remaining).map((e) => File(e.path)),
      );
    });
  }

  Future<void> _uploadSelectedImages() async {
    uploadedImageIds.clear();
    final uploadProvider = context.read<UploadProvider>();

    for (File file in selectedImages) {
      final res = await uploadProvider.upload(file: file);
      if (res != null && res.success) {
        uploadedImageIds.add(res.fileId ?? "");
      }
    }
  }

  Widget _networkImageBox(String imageId) {
    return FutureBuilder<Uint8List>(
      future: context.read<HubProvider>().downloadImage(imageId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return _placeholder();
        }

        return Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 8),
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: MemoryImage(snapshot.data!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              right: 4,
              top: 4,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    existingImageIds.remove(imageId);
                  });
                },
                child: const CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.black54,
                  child: Icon(Icons.close, size: 12, color: Colors.white),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _localImageBox(File file) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: FileImage(file),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          right: 4,
          top: 4,
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedImages.remove(file);
              });
            },
            child: const CircleAvatar(
              radius: 10,
              backgroundColor: Colors.black54,
              child: Icon(Icons.close, size: 12, color: Colors.white),
            ),
          ),
        )
      ],
    );
  }

  Widget _placeholder() {
    return Container(
      width: 70,
      height: 70,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalImages = existingImageIds.length + selectedImages.length;

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
          Text(widget.stationName,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),

          const SizedBox(height: 8),

          /// Rating
          Row(
            children: List.generate(5, (i) {
              return IconButton(
                onPressed: () => setState(() => rating = i + 1),
                icon: Icon(
                  i < rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                ),
              );
            }),
          ),

          CustomTextFieldWidget(
            title: "Write your review",
            hintText: "Share your experience",
            textFieldLines: 4,
            textEditingController: reviewCtrl,
          ),

          const SizedBox(height: 10),

          /// Add Button
          Row(
            children: [
              Icon(
                Icons.add,
                color: CommonColors.blue,
              ),
              GestureDetector(
                  onTap: _pickImages,
                  child: Text(
                    "Add Images",
                    style: TextStyle(color: CommonColors.blue),
                  )),
              const SizedBox(width: 10),
              Text("$totalImages / 4"),
            ],
          ),
         
          const SizedBox(height: 10),

          /// Preview (existing + new)
          if (totalImages > 0)
            SizedBox(
              height: 80,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ...existingImageIds.map(_networkImageBox),
                  ...selectedImages.map(_localImageBox),
                ],
              ),
            ),

          const SizedBox(height: 16),

          /// Submit
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                await _uploadSelectedImages();

                final allImages = [
                  ...existingImageIds,
                  ...uploadedImageIds,
                ];
                if (widget.isEdit) {
                  context.read<ChargingHubReviewProvider>().updateReview(
                        context: context,
                        chargingHubId: widget.hubId,
                        chargingStationId: widget.stationId,
                        rating: rating,
                        description: reviewCtrl.text,
                        recId: widget.recId!,
                        reviewImage1:
                            allImages.length > 0 ? allImages[0] : null,
                        reviewImage2:
                            allImages.length > 1 ? allImages[1] : null,
                        reviewImage3:
                            allImages.length > 2 ? allImages[2] : null,
                        reviewImage4:
                            allImages.length > 3 ? allImages[3] : null,
                      );
                } else {
                  if (rating == 0) {
                    FocusScope.of(context).unfocus();
                    showToast("Please select rating");
                    return;
                  }

                  // 🔹 Review validation (for Add only)
                  if (!ValidationHelper.isNotEmpty(reviewCtrl.text)) {
                    FocusScope.of(context).unfocus();
                    showToast("Please enter your review");
                    return;
                  }
                  context.read<ChargingHubReviewProvider>().addReview(
                        context: context,
                        chargingHubId: widget.hubId,
                        chargingStationId: widget.stationId,
                        rating: rating,
                        description: reviewCtrl.text,
                        reviewImage1:
                            allImages.length > 0 ? allImages[0] : null,
                        reviewImage2:
                            allImages.length > 1 ? allImages[1] : null,
                        reviewImage3:
                            allImages.length > 2 ? allImages[2] : null,
                        reviewImage4:
                            allImages.length > 3 ? allImages[3] : null,
                      );
                }

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
