import 'package:ev_charging_app/Services/ChargingService.dart';
import 'package:ev_charging_app/Utils/ShowDialog.dart';
import 'package:ev_charging_app/model/ChargingGunStatusRefreshResponse.dart';
import 'package:ev_charging_app/model/ChargingcomprehensiveHubResponse.dart';
import 'package:flutter/material.dart';


// class ChargingGunStatusProvider extends ChangeNotifier {
//   // final ChargingService _service = ChargingService();

//   // bool loading = false;
//   // ChargingGunStatusRefreshResponse? response;

//   // Future<void> refreshChargingGunStatus({
//   //   required BuildContext context,
//   //   required String chargingGunId,
//   // }) async {
//   //   loading = true;
//   //   notifyListeners();

//   //   try {
//   //     final res = await _service.getChargingGunStatus(
//   //       context,
//   //       chargingGunId,
//   //     );
//   //     response = res;
//   //   } catch (e) {
//   //     showToast("Failed to refresh charging gun status");
//   //   } finally {
//   //     loading = false;
//   //     notifyListeners();
//   //   }
//   // }
//   final ChargingService _service = ChargingService();

//   Map<int, String> _gunStatusMap = {}; // connectorId → status
//   bool _loading = false;

//   String getStatus(int chargingGunId) =>
//       _gunStatusMap[chargingGunId] ?? "Unknown";

//   bool get loading => _loading;
//  Map<int, String> get gunStatusMap => _gunStatusMap;
//   Future<void> fetchGunStatus({
//     required BuildContext context,
//    required int chargingGunId,
//   }) async {
//     try {
//        final res = await _service.getChargingGunStatus(
//        context:  context,
//        chargingGunId:  chargingGunId,
//       );

//       if (res.success == true) {
//         _gunStatusMap[chargingGunId] = res.data!.status!;
//         notifyListeners();
//       }
//     } catch (e) {
//       debugPrint("Gun status error: $e");
//     }
//   }

//   /// 🔁 Fetch all chargers at once
//   Future<void> refreshAll({
//     required BuildContext context,
//     required List<Charger> chargers,
//   }) async {
//     for (final charger in chargers) {
//       await fetchGunStatus(
//         context: context,
//         chargingGunId: charger.connectorId!,
//       );
//     }
//   }
// }
class ChargingGunStatusProvider extends ChangeNotifier {
  final ChargingService _service = ChargingService();

  // Instead of only status, store full Charger
  Map<int, Charger> _chargerMap = {}; // connectorId -> Charger
  bool _loading = false;

  bool get loading => _loading;

  // Public getter for UI
  Map<int, Charger> get chargers => _chargerMap;

  // Get just status easily
  String getStatus(int chargingGunId) =>
      _chargerMap[chargingGunId]?.lastStatus ?? "Unknown";

  /// Fetch individual charger status
//   Future<void> fetchGunStatus({
//     required BuildContext context,
//     required Charger charger,
//   }) async {
//     try {
//       final res = await _service.getChargingGunStatus(
//         context: context,
//         chargingGunId: charger.connectorId!,
//       );

//       if (res.success == true) {
//         // Update the charger object with new status
//         final updatedCharger = _chargerMap[charger.connectorId!] = Charger(
//   connectorId: charger.connectorId,

//   lastStatus: charger.lastStatus, chargePointId: charger.chargePointId, connectorName:  charger.connectorName,
// );


//         _chargerMap[charger.connectorId!] = updatedCharger;
//         notifyListeners();
//       }
//     } catch (e) {
//       debugPrint("Gun status error: $e");
//     }
//   }
Future<void> fetchGunStatus({
  required BuildContext context,
  required Charger charger,
}) async {
  try {
    final res = await _service.getChargingGunStatus(
      context: context,
      chargingGunId: int.parse(charger!.connectorId!.toString()),
    );

    if (res.success! && res.data != null) {
      final gunData = res.data!;

      // Update the charger object with new status
      final updatedCharger = _chargerMap[int.parse(charger!.connectorId!.toString())] = Charger(
        connectorId: charger.connectorId,
        lastStatus: charger.lastStatus, // ✅ use API status
        chargePointId: charger.chargePointId,
        connectorName: charger.connectorName,
        recId: charger.recId
      );

      _chargerMap[int.parse(charger!.connectorId!.toString())] = updatedCharger;
      notifyListeners();
    }
  } catch (e) {
    debugPrint("Gun status error: $e");
  }
}

  /// Refresh all chargers at once
  Future<void> refreshAll({
    required BuildContext context,
    required List<Charger> chargers,
  }) async {
    for (final charger in chargers) {
      await fetchGunStatus(context: context, charger: charger);
    }
  }
}
