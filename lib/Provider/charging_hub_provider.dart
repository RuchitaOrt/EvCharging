
import 'package:ev_charging_app/Services/charging_hub_service.dart';
import 'package:ev_charging_app/model/ChargingcomprehensiveHubResponse.dart';
import 'package:flutter/material.dart';



class ChargingHubProvider extends ChangeNotifier {
  final ChargingHubService _service = ChargingHubService();

  bool loading = false;
  String? message;
  List<ChargingHub> hubs = [];

  int pageNumber = 1;
  int pageSize = 100;

  Future<void> loadChargingHubs(BuildContext context) async {
    loading = true;
    notifyListeners();

    try {
      final res = await _service.getChargingHubs(
      context,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );

      if (res.success) {
        hubs = res.hubs;
      }

      message = res.message;
    } catch (e) {
      message = "Failed to load charging hubs";
      debugPrint("❌ Charging hub error: $e");
    }
    loading = false;
    notifyListeners();
  }
}
