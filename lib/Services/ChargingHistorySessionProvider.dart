import 'package:ev_charging_app/Services/ChargingService.dart';
import 'package:flutter/material.dart';
import 'package:ev_charging_app/model/ChargingHistorySessionResponse.dart';

import 'package:ev_charging_app/Utils/ShowDialog.dart';

class ChargingHistorySessionProvider extends ChangeNotifier {
  final ChargingService _service = ChargingService();

  bool loading = false;
  ChargingSessionResponse? response;

  Future<void> fetchChargingSessions({
    required BuildContext context,
    int page = 1,
    int pageSize = 50,
  }) async {
    loading = true;
    notifyListeners();

    try {
      final res = await _service.getAllChargingSessions(
        context,
        page: page,
        pageSize: pageSize,
      );
      response = res;
    } catch (e) {
      showToast('Failed to fetch charging sessions');
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
