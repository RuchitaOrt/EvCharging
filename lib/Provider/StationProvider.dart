import 'package:ev_charging_app/Services/station_repository.dart';
import 'package:flutter/material.dart';

class StationProvider extends ChangeNotifier {
  final StationRepository _repo = StationRepository();

  bool loading = false;
  List stations = [];

  Future<void> loadStations(BuildContext context, String hubId) async {
    loading = true;
    notifyListeners();

    try {
      final response = await _repo.fetchStations(context, hubId);
      stations = response.data ?? [];
    } catch (_) {}

    loading = false;
    notifyListeners();
  }
}
