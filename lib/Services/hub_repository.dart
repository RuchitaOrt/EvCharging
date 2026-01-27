import 'package:ev_charging_app/Utils/APIManager.dart';

import 'package:flutter/material.dart';

class HubRepository {
  final APIManager _apiManager = APIManager();

  Future<dynamic> fetchHubs(BuildContext context,
      {int page = 1, int size = 10}) async {
    return await _apiManager.apiRequest(
      context,
      API.chargingHubList,
      queryParams: {
        "pageNumber": page,
        "pageSize": size,
      },
    );
  }
  Future<dynamic> getChargingHubsMap(
      BuildContext context, {
        int pageNumber = 1,
        int pageSize = 100,
      }) async {
    return await _apiManager.apiRequest(
      context,
      API.comprehensivelist,
      jsonval: {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
      },
    );
  }
}
