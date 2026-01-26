import 'package:ev_charging_app/Services/hub_repository.dart';
import 'package:ev_charging_app/model/ChargingHubResponse.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HubProvider extends ChangeNotifier {
  final HubRepository _repo = HubRepository();
  bool hasZoomedToFirst = false;

  LatLng? get firstMarkerPosition {
    if (markers.isEmpty) return null;
    return markers.first.position;
  }

  bool loading = false;
  bool hasMore = true;
  int page = 1;

  final List<dynamic> hubs = []; // Use dynamic or ChargingHub type
  final Set<Marker> markers = {};

  Future<void> loadHubs(
      BuildContext context, {
        bool reset = false,
      }) async {
    if (loading || !hasMore) return;

    if (reset) {
      page = 1;
      hubs.clear();
      markers.clear();
      hasMore = true;
    }

    loading = true;
    notifyListeners();

    try {
      final ChargingHubResponse res = await _repo.fetchHubs(
        context,
        page: page,
        size: 10,
      );

      print('API Response: ${res.hubs?.length} hubs');

      final List<dynamic> data = res.hubs ?? [];

      if (data.isEmpty) {
        hasMore = false;
      } else {
        hubs.addAll(data);
        _createMarkers(data);
        page++;
      }
    } catch (e) {
      debugPrint('Error loading hubs: $e');
    }

    loading = false;
    notifyListeners();
  }

  void _createMarkers(List<dynamic> hubList) {
    for (final hub in hubList) {
      final lat = double.tryParse(hub.latitude ?? '0') ?? 0.0;
      final lng = double.tryParse(hub.longitude ?? '0') ?? 0.0;

      if (lat != 0.0 && lng != 0.0) {
        markers.add(
          Marker(
            markerId: MarkerId(hub.recId ?? '${hub.hashCode}'),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(
              title: hub.chargingHubName ?? 'Charging Station',
              snippet: hub.addressLine1 ?? '',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue,
            ),
          ),
        );
      }
    }
  }
}