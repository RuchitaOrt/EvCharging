import 'package:ev_charging_app/Utils/ShowDialog.dart';
import 'package:ev_charging_app/model/EndChargingSessionResponse.dart';
import 'package:ev_charging_app/model/StartChargingSessionResponse.dart';
import 'package:ev_charging_app/model/UnlockConnectorResponse.dart';
import 'package:flutter/material.dart';

import 'package:ev_charging_app/Services/ChargingService.dart';

class ChargingProvider extends ChangeNotifier {
  bool loading = false;
  StartChargingSessionResponse? sessionResponse;
  final ChargingService _service = ChargingService();
  Future<bool> startSession({
    required BuildContext context,
    required String chargingGunId,
    required String chargingStationId,
    required String userId,
    required String chargeTagId,
    required int connectorId,
    required String startMeterReading,
    required String chargingTariff,
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
    };

    try {
      final res = await _service.startChargingSession(context, payload);
      sessionResponse = res;

      if (res.success) {
        return true;
      } else {
        showToast(res.message);
      }
    } catch (e) {
      showToast("Failed to start session: $e");
    } finally {
      loading = false;
      notifyListeners();
    }
    return false;
  }


  EndChargingSessionResponse? endSessionResponse;

  
  Future<bool> endSession({
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

      if (res.success) {
        showToast(res.message);
        return true;
      } else {
        showToast(res.message);
      }
    } catch (e) {
      showToast("Failed to end session: $e");
    } finally {
      loading = false;
      notifyListeners();
    }

    return false;
  }


  UnlockConnectorResponse? unlockResponse;
  

  Future<bool> unlockConnector({
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
        showToast(res.message);
        return true;
      } else {
        showToast(res.message);
      }
    } catch (e) {
      showToast("Failed to unlock connector: $e");
    } finally {
      loading = false;
      notifyListeners();
    }

    return false;
  }
}
