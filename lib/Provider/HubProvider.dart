import 'dart:ui';
import 'package:HyCharge/Bottomsheet/showMyVehiclesBottomSheet.dart';
import 'package:HyCharge/Bottomsheet/showVehicleBottomsheet.dart';
import 'package:HyCharge/Utils/commonimages.dart';
import 'package:HyCharge/enum/enum.dart';
import 'package:HyCharge/model/VehicleModel.dart';
import 'package:dio/dio.dart';
import 'package:HyCharge/Screens/StationDetailsScreen.dart';
import 'package:HyCharge/Services/hub_repository.dart';
import 'package:HyCharge/Utils/APIManager.dart';
import 'package:HyCharge/Utils/LocationConvert.dart';
import 'package:HyCharge/main.dart';
// import 'package:HyCharge/model/ChargingHubResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Screens/Controller/map_controller.dart';
import '../Utils/directions_service.dart';
import '../Utils/iconresizer.dart';
import '../model/ChargingcomprehensiveHubResponse.dart';

class HubProvider extends ChangeNotifier {
  final HubRepository _repo = HubRepository();
  final DirectionsService _directionsService = DirectionsService();
  final MapController mapController;
  HubProvider(this.mapController);
  bool hasZoomedToFirst = false;

  LatLng? get firstMarkerPosition {
    if (markers.isEmpty) return null;
    return markers.first.position;
  }

  bool loading = false;
  bool hasMore = true;
  int page = 1;

  late Set<Marker> markers = {};
  List<ChargingHub> _recordsStation =[];
  List<ChargingHub> get recordsStation => _recordsStation;
  Set<Polyline> polyLines = {};

  bool _isRouteLoading = false;

  bool get isRouteLoading => _isRouteLoading;
  String? selectedMarkerId;
  String? currentMarkerId;
  BitmapDescriptor? normalMarkerIcon;
  BitmapDescriptor? activeMarkerIcon;
  BitmapDescriptor? currentMarkerIcon;


  int currentVisibleIndex = 0;

  final ScrollController scrollController = ScrollController();

 final Map<String, Uint8List> _imageCache = {};
final APIManager _api = APIManager();
  Future<Uint8List> downloadImage(String imageId) async {
    if (_imageCache.containsKey(imageId)) {
      return _imageCache[imageId]!;
    }

    final res = await _api.dio.get(
      "/FileStorage/download/$imageId",
       options: Options(
        responseType: ResponseType.bytes, // important
      ),
    );

    final bytes = Uint8List.fromList(res.data);
    _imageCache[imageId] = bytes;
    return bytes;
  }
  void scrollToIndex(int index) {
    const double itemWidth = 350.0; // your card width + separator
    scrollController.animateTo(
      index * itemWidth,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
  void initFirstItem(double itemWidth) {
    if (recordsStation.isEmpty) return;
    currentVisibleIndex = 0;
    ChargingHub hub = recordsStation[0];
    clearRoute();
    LatLng? location = LocationConvert.getLatLngFromHub(hub);
    if (location != null) {
      print('0 Item Position: ${hub.chargingHubName}');
      //wait for map to be ready
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mapController.isReady) return;
        mapController.zoomTo(location);
        getDirection(hub.recId!);
      });
      // mapController.zoomTo(location);
      // getDirection(hub.recId);
    }
    notifyListeners();
  }


void listenToScroll(double itemWidth) {
  scrollController.addListener(() {
    final offset = scrollController.offset;
    final maxScroll = scrollController.position.maxScrollExtent;

    // 🔹 Load more when user reaches end
    if (offset >= maxScroll - itemWidth * 0.5) {
      loadHubs(routeGlobalKey.currentContext!);
    }

    // 🔹 Existing visible index logic (unchanged)
    final index = (offset / itemWidth).round();
    if (index != currentVisibleIndex &&
        index >= 0 &&
        index < recordsStation.length) {
      currentVisibleIndex = index;

      final hub = recordsStation[index];
      clearRoute();
      final location = LocationConvert.getLatLngFromHub(hub);
      if (location != null) {
        mapController.zoomTo(location);
        getDirection(hub.recId!);
      }

      notifyListeners();
    }
  });
}
Future<void> showCurrentLocationMarker() async {
  final position = await mapController.getCurrentPosition();

  // Remove old current location marker
  markers.removeWhere(
    (marker) => marker.markerId.value == "12345678",
  );

  // Add car marker
  markers.add(
    _buildMarker(
      id: "12345678",
      position: LatLng(
        position.latitude,
        position.longitude,
      ),
      title: "My Location",
      icon: currentMarkerIcon,
      onTap: () {
      showMyVehiclesBottomSheet(
        routeGlobalKey.currentContext!, 
      );
    },
    ),
  );

  notifyListeners();

  mapController.animateCamera(
    CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(
          position.latitude,
          position.longitude,
        ),
        zoom: 17,
      ),
    ),
  );
}

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  // Load icons once
  Future<void> loadIcons() async {
    normalMarkerIcon = await getResizedMarker(
      'assets/images/normalMarker.png',
      width: 32,
    );
    activeMarkerIcon = await getResizedMarker(
      'assets/images/targetMarker.png',
      width: 125,
    );
    // currentMarkerIcon = await getResizedMarker(
    //    'assets/images/currentMarker.png',
    //    width: 125,
    // //  CommonImagePath.vehicle9,
    // //   width: 80,
    // );
     currentMarkerIcon = await createCurrentLocationMarker();
    print("VEHICLE");
    print(currentMarkerIcon);
    print(CommonImagePath.vehicle9);
  }

  
  final int _pageSize = 6;


  bool loadingMore = false;
int _pageNumber = 1;


bool isMoreLoading = false;
bool hasMoreData = true;
Future<void> loadHubs(
  BuildContext context, {
  bool reset = false,
}) async {
  if (loading || isMoreLoading || !hasMoreData) return;

  if (reset) {
    _pageNumber = 1;
    _recordsStation.clear();
    markers.clear();
    hasMoreData = true;
  }

  loading = _pageNumber == 1;
  isMoreLoading = _pageNumber > 1;
  notifyListeners();

  try {
    await loadIcons();

    final ChargingcomprehensiveHubResponse res =
        await _repo.getChargingHubsMap(
      context,
      pageNumber: _pageNumber,
      pageSize: _pageSize,
    );

    final List<ChargingHub> data = res.hubs ?? [];

    if (data.isEmpty) {
      hasMoreData = false;
    } else {
      _recordsStation.addAll(data);
      _createMarkers(_recordsStation);
      _pageNumber++;
    }

    if (_pageNumber == 2 && _recordsStation.isNotEmpty) {
      initFirstItem(350);
    }
  } catch (e) {
    debugPrint("loadHUB Error: $e");
  }

  loading = false;
  isMoreLoading = false;
  notifyListeners();
}


  Future<void> _createMarkers(List<ChargingHub> hubList) async {
    markers.clear();
    //
    for (final hub in hubList) {
      LatLng? location = LocationConvert.getLatLngFromHub(hub);
      if (location != null) {
        markers.add(
          _buildMarker(
            id: hub.recId??'',
            position: LatLng(location.latitude, location.longitude),
            title: hub.chargingHubName??'',
          chargingHub: hub
            // icon: targetMarkerIcon!,
          ),
        );
      }
    }
  
  }

  Marker _buildMarker({
    required String id,
    required LatLng position,
    required String title,
    BitmapDescriptor? icon,
    VoidCallback? onTap,
    ChargingHub? chargingHub
  }) {
     return Marker(
      markerId: MarkerId(id),
      position: position,
      icon: selectedMarkerId == id
          ? activeMarkerIcon!
          : '12345678' == id
              ? currentMarkerIcon!
              : (icon ?? normalMarkerIcon!),
      anchor: const Offset(0.5, 0.5),

onTap: () async {
  clearRoute();

  // 1️⃣ Zoom in to marker
  mapController.animateCamera(
    CameraUpdate.newCameraPosition(
      CameraPosition(
        target: position,
        zoom: 17.5, // 👈 HP-style close zoom
        tilt: 45,
        bearing: 0,
      ),
    ),
  );

  // 2️⃣ Highlight marker
  selectMarker(id);

  // 3️⃣ Scroll station card (optional)
  scrollToStation(id);

  if (onTap != null) onTap();
},

    );
  }
void scrollToStation(String markerId) {
  final index =
      recordsStation.indexWhere((hub) => hub.recId == markerId);

  if (index == -1) return;

  currentVisibleIndex = index;

  const double itemWidth = 350.0; // same width used everywhere

  scrollController.animateTo(
    index * itemWidth,
    duration: const Duration(milliseconds: 400),
    curve: Curves.easeInOut,
  );

  notifyListeners();
}

  void selectMarker(String markerId) {
    selectedMarkerId = markerId;
    _createMarkersInternal();
    notifyListeners();
  }

  void _createMarkersInternal() {
    // rebuild markers with active icon
    markers = markers.map((m) {
      // final isSelected = m.markerId.value == selectedMarkerId;
      final String id = m.markerId.value;
      BitmapDescriptor iconToUse;
      if (id == "12345678") {
        //current location marker
        iconToUse = currentMarkerIcon!;
      } else if (id == selectedMarkerId) {
        //active selected marker
        iconToUse = activeMarkerIcon!;
      } else {
        //normal marker
        iconToUse = normalMarkerIcon!;
      }
      return m.copyWith(
        // iconParam: isSelected ? activeMarkerIcon : normalMarkerIcon,
        iconParam: iconToUse,
      );
    }).toSet();
  }

  Future<void> drawRoute(
    LatLng start,
    LatLng end,
    ChargingHub chargingHub
  ) async {
    final Position position = await MapController().getCurrentPosition();
    markers.add(
      _buildMarker(
          id: "12345678",
          position: LatLng(position.latitude, position.longitude),
          title: "Me",
          icon: currentMarkerIcon,
          onTap: () {},
          chargingHub: chargingHub
          
          ),
    );

    final routePoints = await _directionsService.getRoute(
      origin: LatLng(position.latitude, position.longitude),
      destination: end,
    );
    polyLines = {
      Polyline(
          polylineId: const PolylineId('route'),
          points: routePoints,
          color: Colors.green,
          width: 3,
          startCap: Cap.roundCap,
          endCap: Cap.squareCap,
          jointType: JointType.round,
          
          geodesic: false,
          consumeTapEvents: false,
          onTap: () {
            //   route tap
          }),
    };
    notifyListeners();
  }

  void clearRoute() {
    polyLines.clear();
    notifyListeners();
  }
  void getDirection(String markerId){
    selectedMarkerId = markerId;
    _createMarkers(_recordsStation);
    notifyListeners();
  }
  Future<void> getDirectionOfRoute(BuildContext context,ChargingHub chargingHub) async {
    selectedMarkerId = chargingHub.recId;
    // selectedMarkerId =  '243243';
    _createMarkers(_recordsStation);
    //
    clearRoute();
    _isRouteLoading = true;
    selectMarker(chargingHub.recId??'');
    // selectMarker('243243');
    //
    // LatLng location = convertToLatLng('${chargingHub.latitude}', '${chargingHub.longitude}');
    LatLng? location = LocationConvert.getLatLngFromHub(chargingHub);
    if (location != null) {
      print(location.latitude);  // 19.0991
      print(location.longitude); // 72.9165
      final currentPosition = await MapController().getCurrentPosition();
      // clearRoute();
      drawRoute(
        //current position no required we define in route method
        LatLng(currentPosition.latitude, currentPosition.longitude),
        // target position
        // LatLng(chargingHub.latitude ?? 0.0, chargingHub.longitude?? 0.0),
        location,
        chargingHub
        //   LatLng(19.196262132107243, 72.96296701103056)
      );
    }
    _isRouteLoading = false;
    notifyListeners();
  }
  bool _matches(String source, String query) {
  final s = source.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  final q = query.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  return s.contains(q);
}

  int findHubIndex(String query) {
  for (int i = 0; i < recordsStation.length; i++) {
    final hub = recordsStation[i];

    if (_matches(hub.chargingHubName ?? '', query)) return i;
    if (_matches(hub.city ?? '', query)) return i;
    if (_matches(hub.addressLine1 ?? '', query)) return i;
  }
  return -1;
}
Future<SearchHubResult> searchAndFocusHub(String query) async {
  if (query.trim().isEmpty) {
    return SearchHubResult.notFound;
  }

  try {
    /// FIND INDEX
    final index = recordsStation.indexWhere(
      (e) => (e.chargingHubName ?? "")
          .toLowerCase()
          .contains(query.toLowerCase()),
    );

    if (index == -1) {
      return SearchHubResult.notFound;
    }

    final hub = recordsStation[index];

    LatLng? target = LocationConvert.getLatLngFromHub(hub);

    if (target == null) {
      return SearchHubResult.notFound;
    }

    /// CHECK SAME LOCATION
    final visibleRegion =
        await mapController.googleMapController?.getVisibleRegion();

    if (visibleRegion != null) {
      final centerLat =
          (visibleRegion.northeast.latitude +
                  visibleRegion.southwest.latitude) /
              2;

      final centerLng =
          (visibleRegion.northeast.longitude +
                  visibleRegion.southwest.longitude) /
              2;

      final isSameLocation =
          (centerLat - target.latitude).abs() < 0.0005 &&
          (centerLng - target.longitude).abs() < 0.0005;

      if (isSameLocation) {
        /// ALSO MOVE CARD
        scrollController.animateTo(
          index * 330,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );

        currentVisibleIndex = index;
        notifyListeners();

        return SearchHubResult.sameLocation;
      }
    }

    /// MOVE MAP
    await mapController.googleMapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: target,
          zoom: 16,
        ),
      ),
    );

    /// MOVE CARD
    scrollController.animateTo(
      index * 330,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );

    /// UPDATE SELECTED CARD
    currentVisibleIndex = index;

    notifyListeners();

    return SearchHubResult.found;
  } catch (e) {
    return SearchHubResult.notFound;
  }
}
// Future<SearchHubResult> searchAndFocusHub(String query) async {
//   if (query.trim().isEmpty) {
//     return SearchHubResult.notFound;
//   }

//   try {
//     final hub = recordsStation.firstWhere(
//       (e) =>
//           (e.chargingHubName ?? "")
//               .toLowerCase()
//               .contains(query.toLowerCase()),
//     );

//     LatLng? target = LocationConvert.getLatLngFromHub(hub);

//     if (target == null) {
//       return SearchHubResult.notFound;
//     }

//     final visibleRegion =
//         await mapController.googleMapController?.getVisibleRegion();

//     if (visibleRegion != null) {
//       final centerLat =
//           (visibleRegion.northeast.latitude +
//                   visibleRegion.southwest.latitude) /
//               2;

//       final centerLng =
//           (visibleRegion.northeast.longitude +
//                   visibleRegion.southwest.longitude) /
//               2;

//       final isSameLocation =
//           (centerLat - target.latitude).abs() < 0.0005 &&
//           (centerLng - target.longitude).abs() < 0.0005;

//       if (isSameLocation) {
//         return SearchHubResult.sameLocation;
//       }
//     }

//     await mapController.googleMapController?.animateCamera(
//       CameraUpdate.newCameraPosition(
//         CameraPosition(
//           target: target,
//           zoom: 16,
//         ),
//       ),
//     );

//     return SearchHubResult.found;
//   } catch (e) {
//     return SearchHubResult.notFound;
//   }
// }
// void searchAndFocusHub(String query) async {
//   final index = findHubIndex(query);

//   if (index == -1) {
//     debugPrint("No hub found");
//     return;
//   }

//   final hub = recordsStation[index];
//   final location = LocationConvert.getLatLngFromHub(hub);
//   if (location == null) return;

//   // Move map
//  mapController.moveToLocation(location);

//   // Scroll card
//   scrollController.animateTo(
//     index * 350.0,
//     duration: const Duration(milliseconds: 500),
//     curve: Curves.easeInOut,
//   );

//   notifyListeners();
// }


}
