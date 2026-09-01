import 'package:HyCharge/Utils/APIManager.dart';
import 'package:HyCharge/model/ActiveSessionResponse.dart';
import 'package:HyCharge/model/ChargerDetailsResponse.dart';
import 'package:HyCharge/model/ChargingGunStatusRefreshResponse.dart';
import 'package:HyCharge/model/ChargingGunStatusResponse.dart';
import 'package:HyCharge/model/ChargingHistorySessionResponse.dart';
import 'package:HyCharge/model/EndChargingSessionResponse.dart';
import 'package:HyCharge/model/EndUnifiedChargingSessionResponse.dart';
import 'package:HyCharge/model/EstimationModel.dart';
import 'package:HyCharge/model/LocalGunResponseModel.dart';
import 'package:HyCharge/model/SessionDetailResponse.dart';
import 'package:HyCharge/model/SessionIDDetailResponse.dart';
import 'package:HyCharge/model/SessionIdResponse.dart';
import 'package:HyCharge/model/StartChargingSessionResponse.dart';
import 'package:HyCharge/model/StartUnifiedChargingSessionResponse.dart';
import 'package:HyCharge/model/UnifiedActiveSessionResponse.dart';
import 'package:HyCharge/model/UnifiedSessionDetailResponse.dart';

import 'package:HyCharge/model/UnlockConnectorResponse.dart';
import 'package:HyCharge/model/estimate_charging_response.dart';
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
  // Future<StartUnifiedChargingSessionResponse> startUnifiedChargingSession(
  //     BuildContext context, Map<String, dynamic> payload) async {
  //   final response = await APIManager().apiRequest(
  //     context,
  //     API.startChargingSession, // we'll add this to APIManager
  //     jsonval: payload,
  //   );

  //   return response as StartUnifiedChargingSessionResponse;
  // }
Future<dynamic> startUnifiedChargingSession(
    BuildContext context,
    Map<String, dynamic> payload,
) async {
  final response = await APIManager().apiRequest(
    context,
    API.startChargingSession,
    jsonval: payload,
  );

  return response;
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
  Future<EndUnifiedChargingSessionResponse> endUNifiedChargingSession(
      BuildContext context, Map<String, dynamic> payload) async {
    final response = await APIManager().apiRequest(
      context,
      API.endChargingSession, // new API
      jsonval: payload,
    );

    return response as EndUnifiedChargingSessionResponse;
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
  Future<UnlockResponse> unlockUNifiedConnector(
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


  Future<SessionIDDetailResponse> getSessionDetails(
    BuildContext context,
    String sessionId,
  ) async {
    final res = await APIManager().apiRequest(
      context,
      API.chargingsessioIDdetails,
      path: "/$sessionId", // 🔥 IMPORTANT
    );

    return res as SessionIDDetailResponse;
  }




 Future<UnifiedSessionDetailResponse> getUnifiesChargingSessionDetails(
    BuildContext context,
    String sessionId,
  ) async {
    final res = await APIManager().apiRequest(
      context,
      API.ocpipartnerhubsessionDetail,
      path: "/$sessionId", // 🔥 IMPORTANT
    );

    return res as UnifiedSessionDetailResponse;
  }
// Future<ChargingGunStatusResponse> getChargingGunStatus({
//   required BuildContext context,
//   required String chargingGunId,
// }) async {
//   final response = await APIManager().apiRequest(
//     context,
//     API.charginggunstatus,
//     path: "/$chargingGunId",
//   );

//   // response.data should be Map<String,dynamic>
//   if (response.data is Map<String, dynamic>) {
//     return ChargingGunStatusResponse.fromJson(response.data as Map<String, dynamic>);
//   } else {
//     // If APIManager already returned a model, wrap it
//     return ChargingGunStatusResponse(
//       success: true,
//       message: "Data already parsed",
//       data: response.data as ChargingGunStatusData?,
//     );
//   }
// }

Future<dynamic> getChargingGunStatus({
  required BuildContext context,
  required String chargingGunId,
}) async {

  final response = await APIManager().apiRequest(
    context,
    API.charginggunstatus,
    path: "/$chargingGunId",
  );

  final json = response as Map<String, dynamic>;

  if (chargingGunId.startsWith("P")) {
    return ChargingGunStatusResponse.fromJson(json);
  }

  return LocalGunResponseModel.fromJson(json);
}

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
  Future<UnifiedActiveSessionResponse> getActiveUNifiedSessions(
    BuildContext context, {
    int page = 1,
    int pageSize = 50,
    String status="",
  }) async {
    final res = await APIManager().apiRequest(
      context,
      API.partnerchargingsessions, // same endpoint as all sessions
      queryParams: {
        'status': status, // filter for active sessions
        'page': page.toString(),
        'pageSize': pageSize.toString(),
      },
    );

    return res as UnifiedActiveSessionResponse;
  }

   Future<EstimateChargingResponse> estimateCharging({
    required BuildContext context,
  required String chargingGunId,
  required String chargingStationId,
  required String connectorId,

  double? batteryCapacity,
  double? desiredEnergy,
  int? desiredDuration,
  double? currentBatteryPercentage,
  double? desiredCost,
  }) async {
    
    final Map<String, dynamic> body = {
  "chargingGunId": chargingGunId,
  "chargingStationId": chargingStationId,
  "connectorId": connectorId,
};

if (batteryCapacity != null) {
  body["batteryCapacity"] = batteryCapacity;
}

if (desiredEnergy != null) {
  body["desiredEnergy"] = desiredEnergy;
}

if (desiredDuration != null) {
  body["desiredDuration"] = desiredDuration;
}

if (currentBatteryPercentage != null) {
  body["currentBatteryPercentage"] = currentBatteryPercentage;
}

if (desiredCost != null) {
  body["desiredCost"] = desiredCost;
}
print("Estimation");
print(body);
    
print(body);
    final response = await  APIManager().apiRequest(
      context,
      API.estimateCharging,
      jsonval: body,
    );

    return response as EstimateChargingResponse;
  }



 Future<EstimationModel> UnifiedestimateCharging({
    required BuildContext context,
  required String chargingGunId,
  required String chargingStationId,
  required String connectorId,

  double? batteryCapacity,
  double? desiredEnergy,
  int? desiredDuration,
  double? currentBatteryPercentage,
  double? desiredCost,
  }) async {
    
    final Map<String, dynamic> body = {
 
  "connectorId": chargingGunId,
};

if (batteryCapacity != null) {
  body["batteryCapacity"] = batteryCapacity;
}

if (desiredEnergy != null) {
  body["desiredEnergy"] = desiredEnergy;
}

if (desiredDuration != null) {
  body["desiredDuration"] = desiredDuration;
}

if (currentBatteryPercentage != null) {
  body["currentBatteryPercentage"] = currentBatteryPercentage;
}

if (desiredCost != null) {
  body["desiredCost"] = desiredCost;
}
print("Estimation");
print(body);
    
print(body);
    final response = await  APIManager().apiRequest(
      context,
      API.unifiedestimatecharging,
      jsonval: body,
    );

    return response as EstimationModel;
  }





   Future<SessionIdResponse> getPartnerSessionID(
  BuildContext context,
  String recId,
) async {
  final response = await APIManager().apiRequest(
    context,
    API.partnersessionsbyreference,
    path: "/$recId",
  );

  debugPrint("CHARGER DETAILS SERVICE");
  debugPrint(response.toString());

  return response;
}
}
