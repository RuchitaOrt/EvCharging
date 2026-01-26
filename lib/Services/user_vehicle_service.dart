import 'package:ev_charging_app/model/DeleteVehicleResponse.dart';
import 'package:ev_charging_app/model/user_vehicle_update_response.dart';
import 'package:flutter/material.dart';
import 'package:ev_charging_app/Utils/APIManager.dart';
import 'package:ev_charging_app/model/user_vehicle_model.dart';
import 'package:flutter/material.dart';
import 'package:ev_charging_app/Utils/APIManager.dart';
import 'package:ev_charging_app/model/user_vehicle_model.dart';

class UserVehicleService {
  final APIManager _api = APIManager();

  Future<UserVehicleResponse> addVehicle({
    required BuildContext context,
    required String evManufacturerID,
    required String carModelID,
    String? carModelVariant,
    required String carRegistrationNumber,
    int defaultConfig = 0,
    required String batteryTypeId,
    required String batteryCapacityId,
  }) async {
    final body = {
      "evManufacturerID": evManufacturerID,
      "carModelID": carModelID,
      "carModelVariant": carModelVariant ?? "",
      "carRegistrationNumber": carRegistrationNumber,
      "defaultConfig": defaultConfig,
      "batteryTypeId": batteryTypeId,
      "batteryCapacityId": batteryCapacityId,
    };

    // apiRequest already returns UserVehicleResponse
    final UserVehicleResponse res =
        await _api.apiRequest(context, API.userVehicleAdd, jsonval: body);

    return res;
  }

  Future<DeleteVehicleResponse> deleteVehicle({
    required BuildContext context,
    required String vehicleRecId,
  }) async {
    return await _api.apiRequest(
      context,
      API.userVehicleDelete,
      path: "/$vehicleRecId", // 👈 important
    );
  }

   Future<UserVehicleUpdateResponse> updateVehicle(
    BuildContext context, {
    required Map<String, dynamic> payload,
  }) async {
    final res = await _api.apiRequest(
      context,
      API.userVehicleUpdate,
      jsonval: payload,
    );

    return res as UserVehicleUpdateResponse;
  }
}
