import 'package:HyCharge/Services/ChargingService.dart';
import 'package:HyCharge/model/estimate_charging_response.dart';
import 'package:flutter/material.dart';

class ChargingEstimateProvider extends ChangeNotifier {
  // 🔌 Config (normally from API)
  final double? chargerPowerKW =null;
  final double? pricePerUnit=null;
  final double? batteryCapacity=null;
  final double? efficiency=null;
 final controller = TextEditingController();
  double amount = 0;
  double units = 0;
  double time = 0;
  double percentage = 0;

 
bool isDragging = false;

String activeMode = "amount"; // amount / units / time
void setUnits(double value) {
  units = value;
  notifyListeners();
}

void setTime(double value) {
  time = value;
  notifyListeners();
}

void setAmount(String value) {
  amount = double.tryParse(value) ?? 0;
  notifyListeners();
}


   EstimateChargingResponse? _estimateResponse;
  EstimateChargingResponse? get estimateResponse => _estimateResponse;

  bool _loading = false;
 final ChargingService _service = ChargingService();
 Future<void> estimateCharging({
  required BuildContext context,
  required String chargingGunId,
  required String chargingStationId,
  required String connectorId,
  double? desiredEnergy,
  int? desiredDuration,
  double? desiredCost,
  double? currentBatteryPercentage,
}) async {
  try {
    _loading = true;

    _estimateResponse = await _service.estimateCharging(
      context: context,
      chargingGunId: chargingGunId,
      chargingStationId: chargingStationId,
      connectorId: connectorId,
      batteryCapacity: batteryCapacity,
      desiredEnergy: desiredEnergy,
      desiredDuration: desiredDuration,
      currentBatteryPercentage: currentBatteryPercentage,
      desiredCost: desiredCost,
    );

    if (_estimateResponse != null && _estimateResponse!.success) {

      // if (!isDragging) {
      //   if (activeMode != "units") {
      //     units = _estimateResponse!.estimatedEnergy;
      //   }

      //   if (activeMode != "time") {
      //     time = _estimateResponse!.estimatedTimeMinutes;
      //   }

      //   if (activeMode != "amount") {
      //     amount = _estimateResponse!.estimatedCost;
      //     controller.text = amount.toStringAsFixed(0);
      //   }
      // }
if (activeMode != "units") {
  units = _estimateResponse!.estimatedEnergy;
}

if (activeMode != "time") {
  time = _estimateResponse!.estimatedTimeMinutes;
}

if (activeMode != "amount") {
  amount = _estimateResponse!.estimatedCost;
  controller.text = amount.toString();
  //.toStringAsFixed(0);
}
      percentage = _estimateResponse!.estimatedBatteryIncrease;
    }

  } catch (e) {
    debugPrint("Estimate Charging Error: $e");
  } finally {
    _loading = false;
    notifyListeners(); // ✅ ONLY ONE NOTIFY HERE
  }
}


}
