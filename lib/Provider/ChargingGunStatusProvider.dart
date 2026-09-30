import 'package:HyCharge/Services/ChargingService.dart';
import 'package:HyCharge/Services/LocationService.dart' as loc;
import 'package:HyCharge/Utils/ShowDialog.dart';
import 'package:HyCharge/model/ChargingGunStatusRefreshResponse.dart';
import 'package:HyCharge/model/ChargingGunStatusResponse.dart';
import 'package:HyCharge/model/ChargingcomprehensiveHubResponse.dart';
import 'package:HyCharge/model/LocalGunResponseModel.dart';
import 'package:HyCharge/model/UnifiedComprehensiveResponse.dart';
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
      _chargerMap[chargingGunId]?.status ?? "Unknown";

// final Map<int, Charger> _chargerMap = {};

//   Map<int, Charger> get chargers => _chargerMap;
// final Map<int, Charger> _chargerMap = {};
// Map<int, Charger> get chargers => _chargerMap;
final Map<String, Connector> _chargerMap = {};
Map<String, Connector> get chargers => _chargerMap;
Future<void> fetchGunStatus({
  required BuildContext context,
  required Connector charger,
}) async {
  try {
    final res = await _service.getChargingGunStatus(
      context: context,
      chargingGunId: charger.id!,
    );
if(res is ChargingGunStatusResponse){
    if (res.success == true && res.data != null) {
      final gunData = res.data!;
      print("RCU");
      // final key = int.parse(charger.connectorId!);
final key = charger.id!;
 print("RCU1");
  print("RCU CONNECTOR ${charger.connectorId} ${gunData.status} ${key}");
      _chargerMap[key] = Connector(
        connectorId: charger.connectorId,
        status: gunData.status, 
       providerType: charger.providerType,
        chargerTypeName: charger.chargerTypeName,
       
        powerOutput: charger.powerOutput,
        id: charger.id,
        lastUpdated: gunData.status, // ✅ updated value
      );
       print("RCU3 ${gunData.status} ${_chargerMap[key] }");
    }
}else if(res is LocalGunResponseModel){
    if (res.success == true && res.data != null) {
      final gunData = res.data!;
      print("RCU");
      // final key = int.parse(charger.connectorId!);
final key = charger.id!;
 print("RCU1");
      _chargerMap[key] = Connector(
        connectorId: charger.connectorId,
        status: gunData.status!.status,
       providerType: charger.providerType,
        chargerTypeName: charger.chargerTypeName,
       
        powerOutput: charger.powerOutput,
        id: charger.id,
        lastUpdated: gunData.status!.status, // ✅ updated value
      );
       print("RCU3");
    }
}
  } catch (e) {
    debugPrint("Gun status error: $e");
  }
}
Future<dynamic> fetchGunStatusValue({
  required BuildContext context,
  required Connector charger,
}) async {
  try {
    _loading=true;
    notifyListeners();
    final res = await _service.getChargingGunStatus(
      context: context,
      chargingGunId: charger.id!,
    );
if(res is ChargingGunStatusResponse){
    if (res.success == true && res.data != null) {
      final gunData = res.data!;
     final key = charger.id!;

      _chargerMap[key] = Connector(
        connectorId: charger.connectorId,
        providerType: charger.providerType,
       status:gunData.status,
        chargerTypeName: charger.chargerTypeName,
       tariff: charger.tariff,
        powerOutput: charger.powerOutput,
        id: charger.id,
        lastUpdated: gunData.status,
      );
       _loading=false;
       notifyListeners();
    }
}else if(res is LocalGunResponseModel)
{
  if (res.success == true && res.data != null) {
      final gunData = res.data!;
     final key = charger.id!;

      _chargerMap[key] = Connector(
        connectorId: charger.connectorId,
        providerType: charger.providerType,
       status: gunData.status!.status,
        chargerTypeName: charger.chargerTypeName,
       tariff: charger.tariff,
        powerOutput: charger.powerOutput,
        id: charger.id,
        lastUpdated: gunData.status!.status,
      );
       _loading=false;
       notifyListeners();
  }
}
_loading=false;
       notifyListeners();
    return res; // ✅ return response

  } catch (e) {
      _loading=false;
       notifyListeners();
    debugPrint("Gun status RUCH: $e");
    return null; // ❌ handle errors by returning null
  }
}


Future<void> refreshAll({
  required BuildContext context,
  required List<Connector> chargers,
}) async {
  for (final charger in chargers) {

    await fetchGunStatus(context: context, charger: charger);
  }
  notifyListeners(); // 🔥 triggers UI rebuild
}

final loc.LocationService _locationService = loc.LocationService();

Future<void> getLocations(
  BuildContext context,
  String hubID,
) async {
  try {
    final response = await _locationService.getLocationLiveStatus(
      context,
      hubID,
    );

    print("====================================");
    print("LIVE API RESPONSE");
    print("====================================");

    print("Success: ${response.success}");
    print("Total locations: ${response.totalCount}");

    final location = response.location;

    if (location == null) {
      print("LOCATION IS NULL");
      return;
    }

    print("Location: ${location.name}");
    print("EVSE count: ${location.evses.length}");

    // Match LIVE API connectorId with existing charger.connectorId
    for (final evse in location.evses) {
      print("EVSE ID: ${evse.evseId}");
      print("REFERENCE: ${evse.physicalReference}");
      print("LIVE STATUS: ${evse.status}");

      for (final liveConnector in evse.connectors) {
        print("LIVE CONNECTOR ID: ${liveConnector.id}");
        print("LIVE STATUS: ${evse.status}");

        // Find existing charger using connectorId
        for (final entry in _chargerMap.entries) {
          final charger = entry.value;

          if (charger.connectorId == liveConnector.id) {
            print("MATCH FOUND");
            print("Existing charger ID: ${charger.id}");
            print("Connector ID: ${charger.connectorId}");
            print("Old status: ${charger.status}");
            print("New status: ${evse.status}");

            _chargerMap[entry.key] = Connector(
              connectorId: charger.connectorId,
              status: evse.status,
              providerType: charger.providerType,
              chargerTypeName: charger.chargerTypeName,
              powerOutput: charger.powerOutput,
              id: charger.id,
              lastUpdated: evse.status,
            );
          }
        }
      }
    }

    // Important: rebuild Consumer<ChargingGunStatusProvider>
    notifyListeners();

    print("====================================");
    print("UPDATED CHARGERS");
    print("====================================");

    for (final entry in _chargerMap.entries) {
      print(
        "ID = ${entry.value.id} | "
        "CONNECTOR ID = ${entry.value.connectorId} | "
        "STATUS = ${entry.value.status}",
      );
    }

    print("====================================");
  } catch (e) {
    print("Location API error: $e");
  }
}
void printExistingChargers() {
  print("====================================");
  print("EXISTING CHARGERS IN PROVIDER");
  print("====================================");

  for (final entry in _chargerMap.entries) {
    final charger = entry.value;

    print(
      "MAP KEY = ${entry.key} | "
      "ID = ${charger.id} | "
      "CONNECTOR ID = ${charger.connectorId} | "
      "NAME = ${charger.chargerTypeName} | "
      "STATUS = ${charger.status}",
    );
  }

  print("====================================");
}
}
