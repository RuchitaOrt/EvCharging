import 'package:HyCharge/Utils/APIManager.dart';
import 'package:HyCharge/model/UnifiedComprehensiveResponse.dart';
import 'package:flutter/material.dart';

class ChargingHubService {
  final APIManager _apiManager = APIManager();

  Future<dynamic> getChargingHubs(
    BuildContext context, {
    int pageNumber = 1,
    int pageSize = 100,
  }) async {
    print("CALL ${pageNumber} ${pageSize}");
    return await _apiManager.apiRequest(
      context,
      API.unifiedComprehensiveList,
    
      jsonval: {
        "page": pageNumber,
        "pageSize": pageSize,
      },
    );
  }


}
