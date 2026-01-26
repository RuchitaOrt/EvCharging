import 'package:ev_charging_app/Utils/APIManager.dart';
import 'package:flutter/material.dart';

class ChargingHubService {
  final APIManager _apiManager = APIManager();

  Future<dynamic> getChargingHubs(
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
