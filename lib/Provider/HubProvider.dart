import 'package:ev_charging_app/Services/hub_repository.dart';
import 'package:ev_charging_app/model/ChargingHubResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Services/hub_repository.dart';

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

  final List hubs = [];
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
    final ChargingHubResponse res = await _repo.fetchHubs(context);
print(res.hubs); // ✅ directly access hubs


      final List<ChargingHub> data = res.hubs ?? [];


      if (data.isEmpty) {
        hasMore = false;
      } else {
        hubs.addAll(data);
        _createMarkers(data);
        page++;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    loading = false;
    notifyListeners();
  }
void _createMarkers(List<ChargingHub> hubList) {
  for (final hub in hubList) {
    final double lat = hub.latitude  ?? 0.0;
    final double lng =hub.longitude ?? 0.0;

    markers.add(
      Marker(
        markerId: MarkerId(hub.recId ?? ''),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(
          title: hub.chargingHubName ?? '',
        ),
      ),
    );
  }
}

}
