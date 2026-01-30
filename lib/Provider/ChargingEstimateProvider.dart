import 'package:flutter/material.dart';

class ChargingEstimateProvider extends ChangeNotifier {
  // 🔌 Config (normally from API)
  final double chargerPowerKW = 7.4;
  final double pricePerUnit = 18;
  final double batteryCapacity = 40;
  final double efficiency = 0.9;

  double amount = 0;
  double units = 0;
  double time = 0;
  double percentage = 0;

  void updateByAmount(double value) {
    amount = value;
    units = amount / pricePerUnit;
    time = units / (chargerPowerKW * efficiency);
    percentage = (units / batteryCapacity) * 100;
    _capValues();
  }

  void updateByUnits(double value) {
    units = value;
    amount = units * pricePerUnit;
    time = units / (chargerPowerKW * efficiency);
    percentage = (units / batteryCapacity) * 100;
    _capValues();
  }

  void updateByTime(double value) {
    time = value;
    units = time * chargerPowerKW * efficiency;
    amount = units * pricePerUnit;
    percentage = (units / batteryCapacity) * 100;
    _capValues();
  }

  void updateByPercentage(double value) {
    percentage = value;
    units = (percentage / 100) * batteryCapacity;
    time = units / (chargerPowerKW * efficiency);
    amount = units * pricePerUnit;
    _capValues();
  }

  void _capValues() {
    percentage = percentage.clamp(0, 100);
    units = units.clamp(0, batteryCapacity);
    notifyListeners();
  }
    final double chargerPower = 7.4;
  
  void calculateFromAmount(double value) {
    amount = value;
    units = amount / pricePerUnit;
    time = units / chargerPower;
    percentage = (units / batteryCapacity) * 100;
    notifyListeners();
  }
}
