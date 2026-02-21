import 'package:HyCharge/Utils/ShowDialog.dart';
import 'package:HyCharge/model/EndChargingSessionResponse.dart';
import 'package:HyCharge/model/SessionDetailResponse.dart';
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
      // "energyLimit": energyLimit,
      "costLimit": costLimit,
      // "timeLimit": timeLimit,
      // "batteryIncreaseLimit": batteryIncreaseLimit
    };

    try {
      final res = await _service.startChargingSession(context, payload);
      sessionResponse = res;

      if (!res.success) {
        showToast(res.message!);
      }
 loading = false;
      notifyListeners();
      return res; // ✅ RETURN FULL RESPONSE
    } catch (e) {
      print(e.toString());
       loading = false;
      notifyListeners();
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
        showToast(res.message ?? "Session ended successfully");
      } else {
        showToast(res.message ?? "Failed to end session");
      }

      return res; // ✅ RETURN FULL RESPONSE
    } catch (e) {
      showToast("Failed to end session");
      return null; // ✅ SAFE FALLBACK
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // UnlockResponse? unlockResponse;

  // Future<bool> unlockConnector({
  //   required BuildContext context,
  //   required String chargingStationId,
  //   required int connectorId,
  // }) async {
  //   loading = true;
  //   notifyListeners();

  //   final payload = {
  //     "chargingStationId": chargingStationId,
  //     "connectorId": connectorId,
  //   };

  //   try {
  //     final res = await _service.unlockConnector(context, payload);
  //     unlockResponse = res;

  //     if (res.success == true) {
  //       showToast(res.message!);
  //       return true;
  //     } else {
  //       showToast(res.message!);
  //     }
  //   } catch (e) {
  //     showToast("Failed to unlock connector: $e");
  //   } finally {
  //     loading = false;
  //     notifyListeners();
  //   }

  //   return false;
  // }

  UnlockResponse? unlockResponse;

  Future<UnlockResponse?> unlockConnector({
    required BuildContext context,
    required String chargingStationId,
    required int connectorId,
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

      if (res.success == true) {
        showToast(res.message ?? "Connector unlocked");
      } else {
        showToast(res.message ?? "Failed to unlock connector");
      }

      return res; // ✅ RETURN FULL RESPONSE
    } catch (e) {
      showToast("Failed to unlock connector");
      return null; // ✅ SAFE NULL
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  SessionDetailResponse? sessionDetails;
  Future<SessionDetailResponse?> fetchChargingSessionDetails({
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

      sessionDetails = res;
      return res; // ✅ return response
    } catch (e) {
      showToast(e.toString());
      return null;
    } finally {
      loading = false;
      notifyListeners();
    }
  }



}
