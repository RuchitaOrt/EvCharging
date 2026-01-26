
import 'package:ev_charging_app/model/car_manufacturer_model.dart';
import 'package:flutter/material.dart';
import 'package:ev_charging_app/Utils/APIManager.dart';

class CarManufacturerApiService {
  final APIManager _apiManager = APIManager();

  Future<CarManufacturerListResponse> getCarManufacturers(
    BuildContext context,
  ) async {
    final response = await _apiManager.apiRequest(
      context,
      API.carManufacturerList,
    );

    debugPrint("CAR MANUFACTURER SERVICE");
    debugPrint(response.toString());

    // ✅ FIX: convert Map → Model
    return CarManufacturerListResponse.fromJson(
        response as Map<String, dynamic>);
  }
}
