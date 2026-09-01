import 'dart:ui';
import 'package:HyCharge/Bottomsheet/showMyVehiclesBottomSheet.dart';
import 'package:HyCharge/Bottomsheet/showVehicleBottomsheet.dart';
import 'package:HyCharge/Utils/commonimages.dart';
import 'package:HyCharge/enum/enum.dart';
import 'package:HyCharge/model/UnifiedComprehensiveResponse.dart';
import 'package:HyCharge/model/VehicleModel.dart';
import 'package:dio/dio.dart';

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

  Future<void> showCurrentLocationMarker() async {
    final position = await mapController.getCurrentPosition();

    // Remove old current location marker
    markers.removeWhere(
      (marker) => marker.markerId.value == "12345678",
    );

    // Add car marker
    markers.add(
      _buildUnifiedMarker(
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

  final int _pageSize = 15;

  bool loadingMore = false;
  int _pageNumber = 1;

  bool isMoreLoading = false;
  bool hasMoreData = true;

  Marker _buildUnifiedMarker(
      {required String id,
      required LatLng position,
      required String title,
      BitmapDescriptor? icon,
      VoidCallback? onTap,
      Location? chargingHub}) {
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
    final index = locations.indexWhere((hub) => hub.id == markerId);

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

  Future<void> drawunifiedRoute(
      LatLng start, LatLng end, Location chargingHub) async {
    final Position position = await MapController().getCurrentPosition();
    markers.add(
      _buildUnifiedMarker(
          id: "12345678",
          position: LatLng(position.latitude, position.longitude),
          title: "Me",
          icon: currentMarkerIcon,
          onTap: () {},
          chargingHub: chargingHub),
    );

    notifyListeners();
  }

  void clearRoute() {
    // polyLines.clear();
    // notifyListeners();
  }

  Future<void> getDirectionOfRoute(
      BuildContext context, Location chargingHub) async {
    selectedMarkerId = chargingHub.id;
    // selectedMarkerId =  '243243';
    _createUnifiedMarkers(locations);
    //
    clearRoute();
    _isRouteLoading = true;
    selectMarker(chargingHub.id ?? '');
    // selectMarker('243243');
    //
    // LatLng location = convertToLatLng('${chargingHub.latitude}', '${chargingHub.longitude}');
    LatLng? location = LocationConvert.getLatLngFromUnifiedHub(chargingHub);
    if (location != null) {
      print(location.latitude); // 19.0991
      print(location.longitude); // 72.9165
      final currentPosition = await MapController().getCurrentPosition();
      // clearRoute();
      drawunifiedRoute(
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
    for (int i = 0; i < locations.length; i++) {
      final hub = locations[i];

      if (_matches(hub.name ?? '', query)) return i;
      if (_matches(hub.city ?? '', query)) return i;
      if (_matches(hub.addressLine1 ?? '', query)) return i;
    }
    return -1;
  }

 List<Location> _locations = [];
  // List<Location> get locations => _locations;
  List<Location> get locations {

   switch(selectedTab){

      case HubTab.HyCharge:
          return _hyChargeLocations;

      case HubTab.Partner:
          return _partnerLocations;

      default:
          return _allLocations;
   }
}
List<Location> _allLocations = [];

List<Location> _hyChargeLocations = [];

List<Location> _partnerLocations = [];
HubTab selectedTab = HubTab.All;

void changeTab(HubTab tab) {
  if (selectedTab == tab) return;

  selectedTab = tab;

  _createUnifiedMarkers(locations);

  notifyListeners();
}

  Future<void> loadUnifiedHubs(
    BuildContext context, {
    bool reset = false,
  }) async {
    if (loading || isMoreLoading || !hasMoreData) return;

    if (reset) {
       print("RUCHITA HERE FOR DATA RESET");
      _pageNumber = 1;
      _locations.clear();
      markers.clear();
      hasMoreData = true;
    }

    loading = _pageNumber == 1;
    isMoreLoading = _pageNumber > 1;

    notifyListeners();

    try {
      await loadIcons();
       print("RUCHITA HERE FOR DATA ${_pageNumber}");
      final response = await _repo.getUnifiedChargingHubs(
        context,
        pageNumber: _pageNumber,
        pageSize: _pageSize,
      );

      final data = response.locations ?? [];

       print("RUCHITA HERE FOR DATA location ${_locations.length}");

      if (data.isEmpty) {
        hasMoreData = false;
      } else {
       

        // for (final e in data) {
        //   print("RUCHITA ${e.id} ${e.name}");
        // }
//          print("RUCHITA HERE FOR DATA adding before location ${_locations.length}");
//         _locations.addAll(data);
//  print("RUCHITA HERE FOR DATA Total location ${_locations.length}");
        

        await _createUnifiedMarkers(_locations);
for (final hub in data) {
   print("RUCHITA ${hub.id} ${hub.name}");
   _allLocations.add(hub);

   if (hub.id?.startsWith("L:") == true) {
      _hyChargeLocations.add(hub);
   }

   if (hub.id?.startsWith("P:") == true) {
      _partnerLocations.add(hub);
   }
}
        _pageNumber++;
      }

      if (_pageNumber == 2 && _locations.isNotEmpty) {
        initFirstUnifiedItem();
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    loading = false;
    isMoreLoading = false;

    notifyListeners();
  }

  void initFirstUnifiedItem() {
    if (_locations.isEmpty) return;

    currentVisibleIndex = 0;

    final location = _locations.first;

    clearRoute();

    final latLng = LatLng(
      double.parse(location.latitude ?? "0"),
      double.parse(location.longitude ?? "0"),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mapController.isReady) return;

      mapController.zoomTo(latLng);

      getUnifiedDirection(location.id ?? "");
    });

    notifyListeners();
  }

  Future<void> _createUnifiedMarkers(
    List<Location> hubs,
  ) async {
    markers.clear();

    for (final hub in hubs) {
      final lat = double.tryParse(hub.latitude ?? "");

      final lng = double.tryParse(hub.longitude ?? "");

      if (lat == null || lng == null) continue;

      markers.add(
        _buildUnifiedMarker(
            id: hub.id ?? "",
            position: LatLng(lat, lng),
            title: hub.name ?? "",
            chargingHub: hub),
      );
    }

    notifyListeners();
  }

  void scrollToUnifiedStation(String id) {
    final index = _locations.indexWhere((e) => e.id == id);

    if (index == -1) return;

    currentVisibleIndex = index;

    scrollController.animateTo(
      index * 350,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );

    notifyListeners();
  }

  Future<SearchHubResult> searchUnifiedHub(
    String query,
  ) async {
    if (query.trim().isEmpty) {
      return SearchHubResult.notFound;
    }

    final index = _locations.indexWhere(
      (e) => (e.name ?? "").toLowerCase().contains(query.toLowerCase()),
    );

    if (index == -1) {
      return SearchHubResult.notFound;
    }

    final hub = _locations[index];

    final lat = double.tryParse(hub.latitude ?? "");

    final lng = double.tryParse(hub.longitude ?? "");

    if (lat == null || lng == null) {
      return SearchHubResult.notFound;
    }

    final target = LatLng(lat, lng);

    await mapController.googleMapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: target,
          zoom: 16,
        ),
      ),
    );

    scrollController.animateTo(
      index * 350,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );

    currentVisibleIndex = index;

    notifyListeners();

    return SearchHubResult.found;
  }

  void getUnifiedDirection(String markerId) {
    selectedMarkerId = markerId;

    _createUnifiedMarkers(_locations);

    notifyListeners();
  }

  bool _listenerAdded = false;
  bool _loadingNextPage = false;

  void listenToUnifiedScroll(double itemWidth) {
    // Prevent adding the listener multiple times
    if (_listenerAdded) return;
    _listenerAdded = true;

    scrollController.addListener(() {
      if (!scrollController.hasClients) return;

      final offset = scrollController.offset;
      final maxScroll = scrollController.position.maxScrollExtent;

      print("Offset : $offset");
      print("MaxScroll : $maxScroll");

      /// ===============================
      /// LOAD NEXT PAGE
      /// ===============================
      if (offset >= maxScroll - 100 &&
          !_loadingNextPage &&
          hasMoreData &&
          !loading &&
          !isMoreLoading) {
        _loadingNextPage = true;

        print("Loading Page $_pageNumber");

        loadUnifiedHubs(routeGlobalKey.currentContext!).whenComplete(() {
          _loadingNextPage = false;
        });
      }

      /// ===============================
      /// CHANGE SELECTED CARD
      /// ===============================
      final index = (offset / itemWidth).round();

      if (index != currentVisibleIndex &&
          index >= 0 &&
          index < locations.length) {
        currentVisibleIndex = index;

        final hub = locations[index];

        clearRoute();

        final latLng = LocationConvert.getLatLngFromUnifiedHub(hub);

        if (latLng != null) {
          mapController.zoomTo(latLng);
          getDirectionOfRoute(routeGlobalKey.currentContext!, hub);
        }

        notifyListeners();
      }
    });
  }
}
