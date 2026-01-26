// providers/hardware_master_provider.dart
import 'package:ev_charging_app/Services/hardware_master_service.dart';
import 'package:ev_charging_app/model/battery_capacity_model.dart';
import 'package:ev_charging_app/model/battery_type_model.dart';
import 'package:ev_charging_app/model/car_manufacturer_model.dart';
import 'package:ev_charging_app/model/charger_type_model.dart';
import 'package:ev_charging_app/model/ev_model.dart';
import 'package:flutter/material.dart';

class HardwareMasterProvider extends ChangeNotifier {
  final HardwareMasterService _service = HardwareMasterService();

  bool loading = false;

  List<CarManufacturer> manufacturers = [];
  List<EVModel> models = [];
  List<BatteryType> batteryTypes = [];
  List<BatteryCapacity> batteryCapacities = [];
  List<ChargerTypeWithImage> chargerTypes = [];


  Future<void> loadAll(BuildContext context) async {
    loading = true;
    notifyListeners();

    try {
      manufacturers = await _service.manufacturers(context);
      models = await _service.models(context);
      batteryTypes = await _service.batteryTypes(context);
      batteryCapacities = await _service.batteryCapacities(context);
      chargerTypes = await _service.chargerTypesWithImage(context);
    } catch (e) {
      print("Error loading hardware master: $e");
    }

    loading = false;
    notifyListeners();
  }
  List<EVModel> modelsByManufacturer(String manufacturerId) {
    return models.where((e) => e.manufacturerId == manufacturerId).toList();
  }
}
