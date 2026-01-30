import 'dart:ui';
import 'package:ev_charging_app/Screens/StationDetailsScreen.dart';
import 'package:ev_charging_app/Services/hub_repository.dart';
import 'package:ev_charging_app/Utils/LocationConvert.dart';
import 'package:ev_charging_app/main.dart';
// import 'package:ev_charging_app/model/ChargingHubResponse.dart';
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
      final index = (offset / itemWidth).round();
      if (index != currentVisibleIndex && index >= 0 && index < recordsStation.length) {
        currentVisibleIndex = index;
        ChargingHub hub = recordsStation[index];
        print('$index Item Position: ${hub.chargingHubName}');
        clearRoute();
        // selectMarker(hub.recId);
        LatLng? location = LocationConvert.getLatLngFromHub(hub);
        if (location != null) {
          print(location.latitude);  // 19.0991
          print(location.longitude); // 72.9165
          mapController.zoomTo(location);
          getDirection(hub.recId!);
        }
        notifyListeners();
      }
    });
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
    currentMarkerIcon = await getResizedMarker(
      'assets/images/currentMarker.png',
      width: 125,
    );
  }

  Future<void> loadHubs(
    BuildContext context, {
    bool reset = false,
  }) async {
    clearRoute();
    if (loading || !hasMore) return;
    if (reset) {
      page = 1;
      _recordsStation.clear();
      markers.clear();
      hasMore = true;
      // polyLines.clear(); remove routes
    }
    loading = true;
    notifyListeners();
   /* try {
      _recordsStation.clear();
      await loadIcons();
      final ChargingHubResponse res = await _repo.fetchHubs(context);
      print('Hub Stations Lists: ${res.hubs.length}');
      final List<ChargingHub> data = res.hubs ?? [];
      if (data.isEmpty) {
        hasMore = false;
      } else {
        _recordsStation.addAll(data);
        _createMarkers(context, _recordsStation);
        page++;
      }
    } catch (e) {
      debugPrint(e.toString());
    }*/
    try {
      _recordsStation.clear();
      await loadIcons();
      final ChargingcomprehensiveHubResponse res = await _repo.getChargingHubsMap(context);
      print('Hub Stations Lists: ${res.hubs!.length}');
      final List<ChargingHub> data = res.hubs ?? [];
      if (data.isEmpty) {
        hasMore = false;
      } else {
        _recordsStation.addAll(data);
        _createMarkers( _recordsStation,);
        page++;
        initFirstItem(350);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    loading = false;
    // notifyListeners();
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
    //

/*    markers.add(
      _buildMarker(
        id: "243243",
        position: const LatLng(19.196262132107243, 72.96296701103056),
        title: "EV Dock Charging Station",
        // icon: targetMarkerIcon!,
      ),
    );

    markers.add(
      _buildMarker(
        id: "243244",
        position: const LatLng(19.19842263661491, 72.95372020182485),
        title: "GLIDA Charging Station",
      ),
    );

    markers.add(
      _buildMarker(
        id: "243245",
        position: const LatLng(19.193039, 72.953840),
        title: "Kazam Charging Station",
      ),
    );

    markers.add(
      _buildMarker(
        id: "243246",
        position: const LatLng(19.262147, 72.983966),
        title: "Vishu Electric Vehicle Charging Station",
        *//*onTap: () async {
          final position = await MapController().getCurrentPosition();
          clearRoute();
          drawRoute(
            LatLng(position.latitude, position.longitude),
            const LatLng(19.193039, 72.953840),
          );
        },*//*
      ),
    );*/
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
      // infoWindow: InfoWindow(title: title, snippet: "Tap for details"),
      onTap: () async {
        clearRoute();
         for (int i = 0; i < _recordsStation.length; i++) {
          print('Card Position $i');
          if (_recordsStation[i].recId == id) {
            print(_recordsStation[i].recId);
            print(id);
 LatLng? location = LocationConvert.getLatLngFromHub(chargingHub!);
              Navigator.push(
                          routeGlobalKey.currentContext!,
                          MaterialPageRoute(builder: (_) => StationDetailsScreen(hub: chargingHub,
                            marker: Marker(
                              markerId: MarkerId(chargingHub.recId!),
                              position: location!,
                              icon: activeMarkerIcon!,
                            )
                            ,location: location,)),
                        );
            print('Card Position navigation $i');
            // scrollToIndex(i);
            // selectMarker(id);
            break;
          }
        }
        //
        if (onTap != null) onTap();
      },
    );
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

/*  Future<void> _createMarkers(List<ChargingHub> hubList,BuildContext context) async {
    BitmapDescriptor  normalMarkerIcon = await getResizedMarker(
      'assets/images/normalMarker.png',
      width: 32,
    );
    BitmapDescriptor  targetMarkerIcon = await getResizedMarker(
      'assets/images/targetMarker.png',
      width: 125,
    );

    markers.add(
      Marker(
        markerId: MarkerId('243243' ?? ''),
        position: LatLng(19.196262132107243, 72.96296701103056),
        icon: targetMarkerIcon,
        anchor: const Offset(0.5, 0.5),
        infoWindow: InfoWindow(
            title:  'EV Dock Charging Station',
            snippet: 'Tap for details',
            onTap: () {
              debugPrint('Marker tapped:');
            }),
      ),
    );
    markers.add(
      Marker(
        markerId: MarkerId('243244' ?? ''),
        position: LatLng(19.19842263661491, 72.95372020182485),
        icon: normalMarkerIcon,
        infoWindow: InfoWindow(
            title:  'GLIDA Charging Station',
            snippet: 'Tap for details',
            onTap: () {
              debugPrint('Marker tapped:');
            }),
      ),
    );
    markers.add(
      Marker(
        markerId: MarkerId('243245' ?? ''),
        position: LatLng(19.193039, 72.953840),
        icon: normalMarkerIcon,
        infoWindow: InfoWindow(
            title:  'Kazam Charging Station',
            snippet: 'Tap for details',
            onTap: () {
              debugPrint('Marker tapped:');
            }),
      ),
    );
    markers.add(
      Marker(
          markerId: MarkerId('243246' ?? ''),
          position: LatLng(19.262147, 72.983966),
          icon: normalMarkerIcon,
          infoWindow: InfoWindow(
            title:  'Vishu Electric Vehicle Charging Station',
            snippet: 'Tap for details',
        ),
        onTap: () async {
          debugPrint('Marker tapped:');
          final Position position = await MapController().getCurrentPosition();
          // drawRoute(LatLng(19.262147, 72.983966), LatLng(19.193039, 72.953840));
          drawRoute(LatLng(position.latitude, position.longitude), LatLng(19.193039, 72.953840));
        }
      ),
    );
  }*/

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
          // onTap: () async {
          //   final position = await MapController().getCurrentPosition();
          //   clearRoute();
          //   drawRoute(
          //     LatLng(position.latitude, position.longitude),
          //     const LatLng(19.193039, 72.953840),
          //   );
          // },
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
          // patterns: [
          //   PatternItem.dash(10),
          //   PatternItem.gap(10),
          // ],
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

void searchAndFocusHub(String query) async {
  final index = findHubIndex(query);

  if (index == -1) {
    debugPrint("No hub found");
    return;
  }

  final hub = recordsStation[index];
  final location = LocationConvert.getLatLngFromHub(hub);
  if (location == null) return;

  // Move map
 mapController.moveToLocation(location);

  // Scroll card
  scrollController.animateTo(
    index * 350.0,
    duration: const Duration(milliseconds: 500),
    curve: Curves.easeInOut,
  );

  notifyListeners();
}

// void searchAndFocusHub(String query) async {
//   if (recordsStation.isEmpty) return;

//   // 🔍 Match by hub name / city / address
//   final index = recordsStation.indexWhere((hub) =>
//       (hub.chargingHubName ?? '').toLowerCase().contains(query.toLowerCase()) ||
//       (hub.city ?? '').toLowerCase().contains(query.toLowerCase()) ||
//       (hub.addressLine1 ?? '').toLowerCase().contains(query.toLowerCase()));

//   if (index == -1) return;

//   final hub = recordsStation[index];

//   final LatLng? location = LocationConvert.getLatLngFromHub(hub);
//   if (location == null) return;

//   // 🎯 Move map camera
//   await mapController.googleMapController?.animateCamera(
//     CameraUpdate.newCameraPosition(
//       CameraPosition(
//         target: location,
//         zoom: 15,
//         tilt: 45,
//       ),
//     ),
//   );

//   // 🎯 Scroll card
//   final double cardWidth = 350; // same as listenToScroll()
//   scrollController.animateTo(
//     index * cardWidth,
//     duration: const Duration(milliseconds: 500),
//     curve: Curves.easeInOut,
//   );

//   // 🎯 Highlight card + marker
//   currentVisibleIndex = index;
//   notifyListeners();
// }

}
