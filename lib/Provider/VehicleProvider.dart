import 'package:ev_charging_app/Services/user_vehicle_service.dart';
import 'package:ev_charging_app/Services/vehicle_service.dart';
import 'package:ev_charging_app/model/VehicleListResponse.dart';
import 'package:ev_charging_app/model/user_vehicle_update_response.dart';
import 'package:flutter/material.dart';

class VehicleProvider extends ChangeNotifier {
  final VehicleApiService _repo = VehicleApiService();

  bool loading = false;
  List<Vehicle> vehicles = [];

  Future<void> loadVehicles(BuildContext context) async {
    loading = true;
    notifyListeners();

    try {
      final response = await _repo.getUserVehicleList(context);
      vehicles = response;
    } catch (e) {
      debugPrint("Vehicle load error: $e");
    }

    loading = false;
    notifyListeners();
  }

}
