import 'package:ev_charging_app/model/user_vehicle_update_response.dart';
import 'package:flutter/material.dart';
import 'package:ev_charging_app/Services/user_vehicle_service.dart';
import 'package:ev_charging_app/model/user_vehicle_model.dart';

class UserVehicleProvider extends ChangeNotifier {
  final UserVehicleService _service = UserVehicleService();

  bool loading = false;
  UserVehicle? vehicle;

  Future<void> addVehicle({
    required BuildContext context,
    required String evManufacturerID,
    required String carModelID,
    String? carModelVariant,
    required String carRegistrationNumber,
    int defaultConfig = 0,
    required String batteryTypeId,
    required String batteryCapacityId,
  }) async {
    loading = true;
    notifyListeners();

    try {
      final res = await _service.addVehicle(
        context: context,
        evManufacturerID: evManufacturerID,
        carModelID: carModelID,
        carModelVariant: carModelVariant,
        carRegistrationNumber: carRegistrationNumber,
        defaultConfig: defaultConfig,
        batteryTypeId: batteryTypeId,
        batteryCapacityId: batteryCapacityId,
      );

      if (res.success) {
        vehicle = res.vehicle;
      } else {
        // show message if needed
        vehicle = null;
      }
    } catch (e) {
      vehicle = null;
      debugPrint("Add vehicle error: $e");
    }

    loading = false;
    notifyListeners();
  }
 List<UserVehicle> vehicles = [];
  

   Future<bool> deleteVehicle(
    BuildContext context,
    String vehicleRecId,
  ) async {
    loading = true;
    notifyListeners();

    final res = await _service.deleteVehicle(
      context: context,
      vehicleRecId: vehicleRecId,
    );

    loading = false;

    if (res.success) {
      vehicles.removeWhere((e) => e.recId == vehicleRecId);
      notifyListeners();
      return true;
    }

    notifyListeners();
    return false;
  }

UpdatedVehicle? updatedVehicle;


Future<bool> updateVehicle(
  BuildContext context, {
  required String recId,
  required String evManufacturerID,
  required String carModelID,
  required String carModelVariant,
  required String carRegistrationNumber,
  required int defaultConfig,
  required String batteryTypeId,
  required String batteryCapacityId,
}) async {
  loading = true;
  notifyListeners();

  final payload = {
    "recId": recId,
    "evManufacturerID": evManufacturerID,
    "carModelID": carModelID,
    "carModelVariant": carModelVariant,
    "carRegistrationNumber": carRegistrationNumber,
    "defaultConfig": defaultConfig,
    "batteryTypeId": batteryTypeId,
    "batteryCapacityId": batteryCapacityId,
  };

  try {
    final res = await _service.updateVehicle(
      context,
      payload: payload,
    );

    if (res.success) {
      updatedVehicle = res.vehicle;
      return true;
    }
  } catch (e) {
    debugPrint("❌ Update vehicle failed: $e");
  } finally {
    loading = false;
    notifyListeners();
  }

  return false;
}

}
