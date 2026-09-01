import 'package:HyCharge/Utils/APIManager.dart';
import 'package:HyCharge/model/UnifiedComprehensiveResponse.dart';

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


  Future<UnifiedComprehensiveResponse> getUnifiedChargingHubs(
  BuildContext context, {
  int pageNumber = 1,
  int pageSize = 100,
}) async {
  final response = await _apiManager.apiRequest(
    context,
    API.unifiedComprehensiveList,
    jsonval: {
      "page": pageNumber,
      "pageSize": pageSize,
    },
  );
print("queryParamsRUchita ${pageNumber} ${pageSize}");
  return response;
}
}
