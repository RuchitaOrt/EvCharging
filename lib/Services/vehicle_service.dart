import 'package:ev_charging_app/model/VehicleListResponse.dart';
import 'package:flutter/material.dart';
import 'package:ev_charging_app/Utils/APIManager.dart';

class VehicleApiService {
  final APIManager _apiManager = APIManager();

  Future<List<Vehicle>> getUserVehicleList(
    BuildContext context,
  ) async {
    final response = await _apiManager.apiRequest(
      context,
      API.userVehicleList,
    );

    debugPrint("VEHICLE LIST SERVICE");
    debugPrint(response.toString());

    final vehicleResponse = response as VehicleListResponse;

    return vehicleResponse.vehicles ?? [];
  }
}
