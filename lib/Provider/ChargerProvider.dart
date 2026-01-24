import 'package:ev_charging_app/Services/charger_repository.dart';
import 'package:flutter/material.dart';


class ChargerProvider extends ChangeNotifier {
  final ChargerRepository _repo = ChargerRepository();

  bool loading = false;
  List chargers = [];

  Future<void> loadChargers(BuildContext context, String stationId) async {
    loading = true;
    notifyListeners();

    try {
      final response = await _repo.fetchChargers(context, stationId);
      chargers = response.data ?? [];
    } catch (_) {}

    loading = false;
    notifyListeners();
  }
}
