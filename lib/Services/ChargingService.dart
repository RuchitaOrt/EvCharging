import 'package:HyCharge/Utils/APIManager.dart';
import 'package:HyCharge/model/ActiveSessionResponse.dart';
import 'package:HyCharge/model/ChargingGunStatusRefreshResponse.dart';
import 'package:HyCharge/model/ChargingGunStatusResponse.dart';
import 'package:HyCharge/model/ChargingHistorySessionResponse.dart';
import 'package:HyCharge/model/EndChargingSessionResponse.dart';
import 'package:HyCharge/model/SessionDetailResponse.dart';
import 'package:HyCharge/model/StartChargingSessionResponse.dart';
import 'package:HyCharge/model/UnlockConnectorResponse.dart';
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

  Future<UnlockResponse> unlockConnector(
      BuildContext context, Map<String, dynamic> payload) async {
    final response = await APIManager().apiRequest(
      context,
      API.unlockConnector, // new API
      jsonval: payload,
    );

    return response as UnlockResponse;
  }

  Future<SessionDetailResponse> getChargingSessionDetails(
    BuildContext context,
    String sessionId,
  ) async {
    final res = await APIManager().apiRequest(
      context,
      API.chargingsessiondetails,
      path: "/$sessionId", // 🔥 IMPORTANT
    );

    return res as SessionDetailResponse;
  }

  // Future<ChargingGunStatusRefreshResponse> getChargingGunStatus(
  //   BuildContext context,
  //   String chargingGunId,
  // ) async {
  //   final res = await APIManager().apiRequest(
  //     context,
  //     API.chargingsessiondetails,
  //     path: "/$chargingGunId", // 🔥 IMPORTANT
  //   );

  //   return res as ChargingGunStatusRefreshResponse;
  // }
// Future<ChargingGunStatusResponse> getChargingGunStatus({
//   required BuildContext context,
//   required int chargingGunId,
// }) async {
//     final response = await APIManager().apiRequest(
//       context,
//       API.charginggunstatus,
//       path: "/$chargingGunId", // 🔥 IMPORTANT
//     );
//   return ChargingGunStatusResponse.fromJson(response.data);
// }
Future<ChargingGunStatusResponse> getChargingGunStatus({
  required BuildContext context,
  required String chargingGunId,
}) async {
  final response = await APIManager().apiRequest(
    context,
    API.charginggunstatus,
    path: "/$chargingGunId",
  );

  // response.data should be Map<String,dynamic>
  if (response.data is Map<String, dynamic>) {
    return ChargingGunStatusResponse.fromJson(response.data as Map<String, dynamic>);
  } else {
    // If APIManager already returned a model, wrap it
    return ChargingGunStatusResponse(
      success: true,
      message: "Data already parsed",
      data: response.data as ChargingGunStatusData?,
    );
  }
}

  // Future<ChargingSessionResponse> getAllChargingSessions(
  //   BuildContext context, {
  //   int page = 1,
  //   int pageSize = 50,
  // }) async {
  //   final res = await APIManager().apiRequest(
  //     context,
  //     API.chargingsessions, // add this in APIManager
  //     queryParams: {
  //       'page': page.toString(),
  //       'pageSize': pageSize.toString(),
  //     },
  //   );

  //   return res as ChargingSessionResponse;
  // }


  /// ✅ New: Fetch Active Sessions
  Future<ActiveSessionResponse> getActiveSessions(
    BuildContext context, {
    int page = 1,
    int pageSize = 50,
    String status="",
  }) async {
    final res = await APIManager().apiRequest(
      context,
      API.chargingsessions, // same endpoint as all sessions
      queryParams: {
        'status': status, // filter for active sessions
        'page': page.toString(),
        'pageSize': pageSize.toString(),
      },
    );

    return res as ActiveSessionResponse;
  }
}
