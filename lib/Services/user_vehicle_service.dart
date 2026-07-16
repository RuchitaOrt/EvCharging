import 'package:HyCharge/model/DeleteVehicleResponse.dart';
import 'package:HyCharge/model/user_vehicle_update_response.dart';
import 'package:flutter/material.dart';
import 'package:HyCharge/Utils/APIManager.dart';
import 'package:HyCharge/model/user_vehicle_model.dart';
import 'package:flutter/material.dart';
import 'package:HyCharge/Utils/APIManager.dart';
import 'package:HyCharge/model/user_vehicle_model.dart';

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

// Future<DeleteVehicleResponse?> deleteVehicle(
//   BuildContext context,
//   String vehicleId,
// ) async {
//   try {
//     return await APIManager().apiRequest(
//       context,
//       API.userVehicleDelete,
//       path: "/$vehicleId",
//     );
//   } catch (e) {
//     print(e);
//     return null;
//   }
// }
}
