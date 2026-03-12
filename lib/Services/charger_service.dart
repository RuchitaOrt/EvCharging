import 'package:HyCharge/model/ChargerDetailsResponse.dart';
import 'package:flutter/material.dart';
import 'package:HyCharge/Utils/APIManager.dart';

class ChargerDetailsApiService {
  final APIManager _apiManager = APIManager();

  Future<ChargerDetailsResponse> getChargerDetails(
    BuildContext context,
    String recId,
  ) async {

    final response = await _apiManager.apiRequest(
      context,
      API.chargerDetails,
      path:    "/$recId",  
    );

    debugPrint("CHARGER DETAILS SERVICE");
    debugPrint(response.toString());

    return ChargerDetailsResponse.fromJson(
      response as Map<String, dynamic>,
    );
  }
}