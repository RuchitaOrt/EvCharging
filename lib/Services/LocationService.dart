import 'package:flutter/material.dart';
import 'package:HyCharge/Utils/APIManager.dart';
import 'package:HyCharge/model/LocationStatusModel.dart';

class LocationService {
  final APIManager _apiManager = APIManager();

  Future<LocationStatusModel> getLocationLiveStatus(
    BuildContext context,
    String locationId,
  ) async {
    try {
      final response = await _apiManager.apiRequest(
        context,
        API.locationStatus,
        path: "/${Uri.encodeComponent(locationId)}",
      );

      return response as LocationStatusModel;
    } catch (e) {
      rethrow;
    }
  }
}