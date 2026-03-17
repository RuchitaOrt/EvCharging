import 'package:HyCharge/Utils/ShowDialog.dart';
import 'package:HyCharge/model/EndChargingSessionResponse.dart';
import 'package:HyCharge/model/SessionDetailResponse.dart' as session;
import 'package:HyCharge/model/StartChargingSessionResponse.dart';
import 'package:HyCharge/model/UnlockConnectorResponse.dart';
import 'package:HyCharge/model/estimate_charging_response.dart';
import 'package:flutter/material.dart';

import 'package:HyCharge/Services/ChargingService.dart';

class ChargingProvider extends ChangeNotifier {
  bool loading = false;
  StartChargingSessionResponse? sessionResponse;
  final ChargingService _service = ChargingService();
  Future<StartChargingSessionResponse?> startSession({
    required BuildContext context,
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
       required String tabIndex
  }) async {
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
} 
else if (tabIndex == "1") {
  payload["energyLimit"] = energyLimit;
} 
else if (tabIndex == "2") {
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

  EndChargingSessionResponse? endSessionResponse;

  Future<EndChargingSessionResponse?> endSession({
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

    try {
      final res = await _service.endChargingSession(context, payload);
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



}
