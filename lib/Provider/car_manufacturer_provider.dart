import 'package:flutter/material.dart';
import 'package:ev_charging_app/Services/car_manufacturer_service.dart';
import 'package:ev_charging_app/model/car_manufacturer_model.dart';

class CarManufacturerProvider extends ChangeNotifier {
  final CarManufacturerApiService _service =
      CarManufacturerApiService();

  bool loading = false;
  List<CarManufacturer> manufacturers = [];
  String message = '';

  Future<void> loadManufacturers(BuildContext context) async {
    loading = true;
    notifyListeners();

    try {
      final response = await _service.getCarManufacturers(context);
      manufacturers = response.data;
      message = response.message;
    } catch (e) {
      debugPrint("Manufacturer load error: $e");
      manufacturers = [];
    }

    loading = false;
    notifyListeners();
  }
}
