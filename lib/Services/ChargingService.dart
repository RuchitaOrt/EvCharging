import 'package:ev_charging_app/Utils/APIManager.dart';
import 'package:ev_charging_app/model/EndChargingSessionResponse.dart';
import 'package:ev_charging_app/model/StartChargingSessionResponse.dart';
import 'package:ev_charging_app/model/UnlockConnectorResponse.dart';
import 'package:flutter/material.dart';



class ChargingService {
  Future<StartChargingSessionResponse> startChargingSession(
      BuildContext context, Map<String, dynamic> payload) async {
    final response = await APIManager().apiRequest(
      context,
      API.startChargingSession, // we'll add this to APIManager
      jsonval: payload,
    );

    return response as StartChargingSessionResponse;
  }

   Future<EndChargingSessionResponse> endChargingSession(
      BuildContext context, Map<String, dynamic> payload) async {
    final response = await APIManager().apiRequest(
      context,
      API.endChargingSession, // new API
      jsonval: payload,
    );

    return response as EndChargingSessionResponse;
  }

   Future<UnlockConnectorResponse> unlockConnector(
      BuildContext context, Map<String, dynamic> payload) async {
    final response = await APIManager().apiRequest(
      context,
      API.unlockConnector, // new API
      jsonval: payload,
    );

    return response as UnlockConnectorResponse;
  }
}
