import 'package:ev_charging_app/Utils/APIManager.dart';

import 'package:flutter/material.dart';

class StationRepository {
  final APIManager _apiManager = APIManager();

  Future<dynamic> fetchStations(BuildContext context, String hubId) async {
    return await _apiManager.apiRequest(
      context,
      API.chargingStationList,
      path: "/$hubId",
    );
  }
}
