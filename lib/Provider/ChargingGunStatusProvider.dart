import 'package:HyCharge/Services/ChargingService.dart';
import 'package:HyCharge/Utils/ShowDialog.dart';
import 'package:HyCharge/model/ChargingGunStatusRefreshResponse.dart';
import 'package:HyCharge/model/ChargingGunStatusResponse.dart';
import 'package:HyCharge/model/ChargingcomprehensiveHubResponse.dart';
import 'package:flutter/material.dart';


class ChargingGunStatusProvider extends ChangeNotifier {
  final ChargingService _service = ChargingService();

  // Instead of only status, store full Charger
  // Map<int, Charger> _chargerMap = {}; // connectorId -> Charger
  bool _loading = false;

  bool get loading => _loading;

  // Public getter for UI
  // Map<int, Charger> get chargers => _chargerMap;

  // Get just status easily
  String getStatus(int chargingGunId) =>
      _chargerMap[chargingGunId]?.lastStatus ?? "Unknown";

// final Map<int, Charger> _chargerMap = {};

//   Map<int, Charger> get chargers => _chargerMap;
// final Map<int, Charger> _chargerMap = {};
// Map<int, Charger> get chargers => _chargerMap;
final Map<String, Charger> _chargerMap = {};
Map<String, Charger> get chargers => _chargerMap;
Future<void> fetchGunStatus({
  required BuildContext context,
  required Charger charger,
}) async {
  try {
    final res = await _service.getChargingGunStatus(
      context: context,
      chargingGunId: charger.recId!,
    );

    if (res.success == true && res.data != null) {
      final gunData = res.data!;
      // final key = int.parse(charger.connectorId!);
final key = charger.recId!;
      _chargerMap[key] = Charger(
        connectorId: charger.connectorId,
        chargePointId: charger.chargePointId,
        connectorName: charger.connectorName,
        chargerTypeName: charger.chargerTypeName,
        chargerTariff: charger.chargerTariff,
        powerOutput: charger.powerOutput,
        recId: charger.recId,
        lastStatus: gunData.status, // ✅ updated value
      );
    }
  } catch (e) {
    debugPrint("Gun status error: $e");
  }
}
Future<ChargingGunStatusResponse?> fetchGunStatusValue({
  required BuildContext context,
  required Charger charger,
}) async {
  try {
    _loading=true;
    notifyListeners();
    final res = await _service.getChargingGunStatus(
      context: context,
      chargingGunId: charger.recId!,
    );

    if (res.success == true && res.data != null) {
      final gunData = res.data!;
     final key = charger.recId!;

      _chargerMap[key] = Charger(
        connectorId: charger.connectorId,
        chargePointId: charger.chargePointId,
        connectorName: charger.connectorName,
        chargerTypeName: charger.chargerTypeName,
        chargerTariff: charger.chargerTariff,
        powerOutput: charger.powerOutput,
        recId: charger.recId,
        lastStatus: gunData.status,
      );
       _loading=false;
       notifyListeners();
    }
_loading=false;
       notifyListeners();
    return res; // ✅ return response

  } catch (e) {
      _loading=false;
       notifyListeners();
    debugPrint("Gun status error: $e");
    return null; // ❌ handle errors by returning null
  }
}


Future<void> refreshAll({
  required BuildContext context,
  required List<Charger> chargers,
}) async {
  for (final charger in chargers) {
    print("NAME");
    print(charger.chargePointName);
    print(charger.chargingHubName);
   
    await fetchGunStatus(context: context, charger: charger);
  }
  notifyListeners(); // 🔥 triggers UI rebuild
}


}
