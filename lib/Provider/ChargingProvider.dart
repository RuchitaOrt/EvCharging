import 'package:HyCharge/Utils/ShowDialog.dart';
import 'package:HyCharge/model/ChargerDetailsResponse.dart';
import 'package:HyCharge/model/EndChargingSessionResponse.dart';
import 'package:HyCharge/model/EndUnifiedChargingSessionResponse.dart';
import 'package:HyCharge/model/LocalStartUnifiedChargingSessionResponse.dart';
import 'package:HyCharge/model/SessionDetailResponse.dart' as session;
import 'package:HyCharge/model/SessionIDDetailResponse.dart';
import 'package:HyCharge/model/SessionIdResponse.dart';
import 'package:HyCharge/model/StartChargingSessionResponse.dart';
import 'package:HyCharge/model/StartUnifiedChargingSessionResponse.dart';
import 'package:HyCharge/model/UnifiedSessionDetailResponse.dart';
import 'package:HyCharge/model/UnlockConnectorResponse.dart';
import 'package:HyCharge/model/estimate_charging_response.dart';
import 'package:flutter/material.dart';

import 'package:HyCharge/Services/ChargingService.dart';

class ChargingProvider extends ChangeNotifier {
  bool loading = false;
  StartChargingSessionResponse? sessionResponse;
  StartUnifiedChargingSessionResponse? sessionUnifiedResponse;
  final ChargingService _service = ChargingService();
  Future<StartChargingSessionResponse?> startSession(
      {required BuildContext context,
      required String chargingGunId,
      required String chargingStationId,
      required String userId,
      required String chargeTagId,
      required int connectorId,
      required String startMeterReading,
      required String chargingTariff,
      required String energyLimit,
      required String costLimit,
      required String timeLimit,
      required String batteryIncreaseLimit,
      required String tabIndex}) async {
    loading = true;
    notifyListeners();

    final payload = {




      
      "chargingGunId": chargingGunId,
      "chargingStationId": chargingStationId,
      "userId": userId,
      "chargeTagId": chargeTagId,
      "connectorId": connectorId,
      "startMeterReading": startMeterReading,
      "chargingTariff": chargingTariff,
      //  "energyLimit": energyLimit,
      // "costLimit": costLimit,
      // "timeLimit": timeLimit,
      //"batteryIncreaseLimit": batteryIncreaseLimit
    };
    if (tabIndex == "0") {
      payload["costLimit"] = costLimit;
    } else if (tabIndex == "1") {
      payload["energyLimit"] = energyLimit;
    } else if (tabIndex == "2") {
      payload["timeLimit"] = timeLimit;
    }
    print(payload);
    try {
      final res = await _service.startChargingSession(context, payload);
      sessionResponse = res;

      if (!res.success) {
        FocusScope.of(context).unfocus();
        showToast(res.message!);
      }
      loading = false;
      notifyListeners();
      return res; // ✅ RETURN FULL RESPONSE
    } catch (e) {
      print(e.toString());
      loading = false;
      notifyListeners();
      FocusScope.of(context).unfocus();
      showToast("Failed to start session");
      return null; // ❌ failure
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  EndUnifiedChargingSessionResponse? endSessionResponse;

  // Future<EndChargingSessionResponse?> endSession({
  //   required BuildContext context,
  //   required String sessionId,
  //   required String endMeterReading,
  // }) async {
  //   loading = true;
  //   notifyListeners();

  //   final payload = {
  //     "sessionId": sessionId,
  //     "endMeterReading": endMeterReading,
  //   };

  //   try {
  //     final res = await _service.endChargingSession(context, payload);
  //     endSessionResponse = res;

  //     if (res.success == true) {
  //       FocusScope.of(context).unfocus();
  //       showToast(res.message ?? "Session ended successfully");
  //     } else {
  //       FocusScope.of(context).unfocus();
  //       showToast(res.message ?? "Failed to end session");
  //     }

  //     return res; // ✅ RETURN FULL RESPONSE
  //   } catch (e) {
  //     FocusScope.of(context).unfocus();
  //     showToast("Failed to end session");
  //     return null; // ✅ SAFE FALLBACK
  //   } finally {
  //     loading = false;
  //     notifyListeners();
  //   }
  // }

  UnlockResponse? unlockResponse;

  Future<UnlockResponse?> unlockConnector({
    required BuildContext context,
    required String chargingStationId,
    required String connectorId,
  }) async {
    loading = true;
    notifyListeners();

    final payload = {
      "chargingStationId": chargingStationId,
      "connectorId": connectorId,
    };

    try {
      final res = await _service.unlockConnector(context, payload);
      unlockResponse = res;
      print("UNLOCK");
      print(unlockResponse);
      if (res.success == true) {
        FocusScope.of(context).unfocus();
        showToast(res.message ?? "Connector unlocked");
      } else {
        FocusScope.of(context).unfocus();
        showToast(res.message ?? "Failed to unlock connector");
      }

      return res; // ✅ RETURN FULL RESPONSE
    } catch (e) {
      FocusScope.of(context).unfocus();
      print(e.toString());
      showToast("Failed to unlock connector");
      return null; // ✅ SAFE NULL
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  session.SessionDetailResponse? sessionDetails;


  UnifiedSessionDetailResponse? unifiedsessionDetails;
  Future<session.SessionDetailResponse?> fetchChargingSessionDetails({
    required BuildContext context,
    required String sessionId,
  }) async {
    loading = true;
    notifyListeners();

    try {
      final res = await _service.getChargingSessionDetails(
        context,
        sessionId,
      );
      loading = false;
      sessionDetails = res;
      return res; // ✅ return response
    } catch (e) {
      loading = false;
      FocusScope.of(context).unfocus();
      showToast(e.toString());
      return null;
    } finally {
      loading = false;
      notifyListeners();
    }
  }


  SessionIDDetailResponse? sessionIDDetails;
  Future<SessionIDDetailResponse?> fetchSessionDetails({
    required BuildContext context,
    required String sessionId,
  }) async {
    loading = true;
    notifyListeners();

    try {
      final res = await _service.getSessionDetails(
        context,
        sessionId,
      );
      loading = false;
      sessionIDDetails = res;
      return res; // ✅ return response
    } catch (e) {
      loading = false;
      FocusScope.of(context).unfocus();
      showToast(e.toString());
      return null;
    } finally {
      loading = false;
      notifyListeners();
    }
  }




Future<UnifiedSessionDetailResponse?> fetchPartnerSessionDetails({
  required BuildContext context,
  required String sessionId,
}) async {
  loading = true;
  notifyListeners();

  try {
    final res = await _service.getUnifiesChargingSessionDetails(
      context,
      sessionId,
    );

    unifiedsessionDetails = res;
    return res;
  } catch (e) {
    FocusScope.of(context).unfocus();
    showToast(e.toString());
    return null;
  } finally {
    loading = false;
    notifyListeners();
  }
}
Future<dynamic> startUnifiedSession({
  required BuildContext context,
  required String chargingGunId,
  required String chargingStationId,
  required String userId,
  required String chargeTagId,
  required String connectorId,
  required String startMeterReading,
  required String chargingTariff,
  required String energyLimit,
  required String costLimit,
  required String timeLimit,
  required String batteryIncreaseLimit,
  required String tabIndex,
}) async {
  loading = true;
  notifyListeners();

  final payload = {
    "connectorId": chargingGunId,
    "chargeTagId": chargeTagId,
    "tokenUid": chargeTagId//userId,
  };

  if (tabIndex == "0") {
    payload["costLimit"] = costLimit;
  } else if (tabIndex == "1") {
    payload["energyLimit"] = energyLimit;
  } else if (tabIndex == "2") {
    payload["timeLimit"] = timeLimit;
  }

  try {
    final res =
        await _service.startUnifiedChargingSession(context, payload);
 print("Tome ${loading}");
    if (res is StartUnifiedChargingSessionResponse) {
       print("Tome StartUnifiedChargingSessionResponse");
      if (res.success != true) {
         loading = false;
         print("Tome  if ${loading}");
        showToast(res.message ?? "Failed");
      }else{
            loading = true;
         print("Tome else ${loading}");
       
      }
    } else if (res is LocalStartUnifiedChargingSessionResponse) {
       print("Tome LocalStartUnifiedChargingSessionResponse");
      if (res.success != true) {
         print("Tome local ${loading}");
         loading = false;
         
        showToast(res.message ?? "Failed");
      }
      else{
         print("Tome local else ${loading}");
        loading = false;
      }
     
    }
 notifyListeners();
    return res;
  } catch (e) {
    debugPrint(e.toString());
     print("Tome e ${loading}");
    showToast("Failed to start session");
    return null;
  } finally {
     print("Tome finally ${loading}");
  
  }
}

  //end
  Future<EndUnifiedChargingSessionResponse?> endUnifiedSession({
    required BuildContext context,
    required String sessionId,
    required String endMeterReading,
  }) async {
    loading = true;
    notifyListeners();

    final payload = {
      "sessionId": sessionId,
      "endMeterReading": endMeterReading,
    };
print("payload stop ${payload}");
    try {
      final res = await _service.endUNifiedChargingSession(context, payload);
      endSessionResponse = res;

      if (res.success == true) {
        FocusScope.of(context).unfocus();
        showToast(res.message ?? "Session ended successfully");
      } else {
        FocusScope.of(context).unfocus();
        showToast(res.message ?? "Failed to end session");
      }

      return res; // ✅ RETURN FULL RESPONSE
    } catch (e) {
      FocusScope.of(context).unfocus();
      showToast("Failed to end session");
      return null; // ✅ SAFE FALLBACK
    } finally {
      loading = false;
      notifyListeners();
    }
  }




  Future<UnlockResponse?> unlockUnifiedConnector({
    required BuildContext context,
    required String chargingStationId,
    required String connectorId,
  }) async {
    loading = true;
    notifyListeners();

    final payload = {
      // "chargingStationId": chargingStationId,
      "connectorId": connectorId,
    };

    try {
      final res = await _service.unlockUNifiedConnector(context, payload);
      unlockResponse = res;
      print("UNLOCK");
      print(unlockResponse);
      if (res.success == true) {
        FocusScope.of(context).unfocus();
        showToast(res.message ?? "Connector unlocked");
      } else {
        FocusScope.of(context).unfocus();
        showToast(res.message ?? "Failed to unlock connector");
      }

      return res; // ✅ RETURN FULL RESPONSE
    } catch (e) {
      FocusScope.of(context).unfocus();
      print(e.toString());
      showToast("Failed to unlock connector");
      return null; // ✅ SAFE NULL
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<session.SessionDetailResponse?> fetchUNifiedChargingSessionDetails({
    required BuildContext context,
    required String sessionId,
  }) async {
    loading = true;
    notifyListeners();

    try {
      final res = await _service.getChargingSessionDetails(
        context,
        sessionId,
      );
      loading = false;
      sessionDetails = res;
      return res; // ✅ return response
    } catch (e) {
      loading = false;
      FocusScope.of(context).unfocus();
      showToast(e.toString());
      return null;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  ///
  ///
  
 Future<SessionIdResponse?> fetchSessionID(
  BuildContext context,
  String recId,
) async {

 

  try {

     final res = await _service.getPartnerSessionID(
        context,
        recId,
      );

    return res; // ✅ RETURN DATA

  } catch (e) {
    debugPrint("CHARGER DETAILS ERROR $e");
    return null;
  } finally {
   
    notifyListeners();
  }
}

Future<SessionIdResponse?> pollForSessionId({
  required BuildContext context,
  required String authorizationReference,
  int maxRetries = 12, // 12 x 5 = 60 seconds
}) async {
    print("Tome pollForSessionId ${loading}");
  for (int i = 0; i < maxRetries; i++) {
    final response = await fetchSessionID(
      context,
      authorizationReference,
    );

    final sessionId = response?.data?.sessionId;

    if (sessionId != null && sessionId.trim().isNotEmpty) {
      loading=false;
       print("Tome pollForSessionId ${loading}");
      return response;
    }
notifyListeners();
    // Wait 5 seconds before next call
    await Future.delayed(const Duration(seconds: 5));
  }

  return null;
}
}
