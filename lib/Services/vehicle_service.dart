import 'package:HyCharge/model/VehicleListResponse.dart';
import 'package:flutter/material.dart';
import 'package:HyCharge/Utils/APIManager.dart';

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
