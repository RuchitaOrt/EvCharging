import 'package:ev_charging_app/Utils/APIManager.dart';

import 'package:flutter/material.dart';

class ChargerRepository {
  final APIManager _apiManager = APIManager();

  Future<dynamic> fetchChargers(BuildContext context, String stationId) async {
    return await _apiManager.apiRequest(
      context,
      API.chargerList,
      path: "/$stationId",
    );
  }
}
