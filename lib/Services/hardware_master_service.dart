// network/hardware_master_service.dart
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:ev_charging_app/Utils/APIManager.dart';
import 'package:ev_charging_app/model/CommonResponse.dart';
import 'package:ev_charging_app/model/battery_capacity_model.dart';
import 'package:ev_charging_app/model/battery_type_model.dart';
import 'package:ev_charging_app/model/car_manufacturer_model.dart';
import 'package:ev_charging_app/model/charger_type_model.dart';
import 'package:ev_charging_app/model/ev_model.dart';
import 'package:flutter/material.dart';

class HardwareMasterService {
  final APIManager _api = APIManager();

  Future<List<CarManufacturer>> manufacturers(BuildContext context) async {
    final res = await _api.apiRequest(context, API.carManufacturerList);
    final data = res['data'] as List<dynamic>; // access 'data' from the map
    return data.map((e) => CarManufacturer.fromJson(e)).toList();
  }

  Future<List<EVModel>> models(BuildContext context) async {
    final res = await _api.apiRequest(context, API.evModelList);
    final data = res['data'] as List<dynamic>;
    return data.map((e) => EVModel.fromJson(e)).toList();
  }

  Future<List<BatteryType>> batteryTypes(BuildContext context) async {
    final res = await _api.apiRequest(context, API.batteryTypeList);
    final data = res['data'] as List<dynamic>;
    return data.map((e) => BatteryType.fromJson(e)).toList();
  }

  Future<List<BatteryCapacity>> batteryCapacities(BuildContext context) async {
    final res = await _api.apiRequest(context, API.batteryCapacityList);
    final data = res['data'] as List<dynamic>;
    return data.map((e) => BatteryCapacity.fromJson(e)).toList();
  }

  Future<List<ChargerType>> chargerTypes(BuildContext context) async {
    final res = await _api.apiRequest(context, API.chargerTypeList);
    final data = res['data'] as List<dynamic>;
    return data.map((e) => ChargerType.fromJson(e)).toList();
  }


    Future<Uint8List> downloadImage(String imageId) async {
    final res = await _api.dio.get(
      "/FileStorage/download/$imageId",
      options: Options(
        responseType: ResponseType.bytes, // important
      ),
    );

    return Uint8List.fromList(res.data);
  }

  /// Get charger types with images
  Future<List<ChargerTypeWithImage>> chargerTypesWithImage(BuildContext context) async {
    final res = await _api.apiRequest(context, API.chargerTypeList);
    final data = res['data'] as List<dynamic>;
    
    List<ChargerTypeWithImage> list = [];
    for (var item in data) {
      final charger = ChargerType.fromJson(item);
      Uint8List? imageBytes;
      try {
        imageBytes = await downloadImage(charger.chargerTypeImage);
      } catch (_) {
        imageBytes = null;
      }
      list.add(ChargerTypeWithImage(charger: charger, imageBytes: imageBytes));
    }
    return list;
  }
}
class ChargerTypeWithImage {
  final ChargerType charger;
  final Uint8List? imageBytes;

  ChargerTypeWithImage({required this.charger, this.imageBytes});
}