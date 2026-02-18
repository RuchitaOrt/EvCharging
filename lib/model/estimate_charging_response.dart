class EstimateChargingResponse {
  final bool success;
  final String message;
  final double estimatedEnergy;
  final double estimatedCost;
  final double estimatedCostWithTax;
  final double estimatedTimeMinutes;
  final double estimatedTimeHours;
  final double estimatedKilometres;
  final double estimatedBatteryIncrease;
  final ChargerInfo? charger;
  final CarInfo? car;
  final CostDetails? costDetails;

  EstimateChargingResponse({
    required this.success,
    required this.message,
    required this.estimatedEnergy,
    required this.estimatedCost,
    required this.estimatedCostWithTax,
    required this.estimatedTimeMinutes,
    required this.estimatedTimeHours,
    required this.estimatedKilometres,
    required this.estimatedBatteryIncrease,
    this.charger,
    this.car,
    this.costDetails,
  });

  factory EstimateChargingResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return EstimateChargingResponse.empty();
    }

    return EstimateChargingResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      estimatedEnergy: _toDouble(json["estimatedEnergy"]),
      estimatedCost: _toDouble(json["estimatedCost"]),
      estimatedCostWithTax: _toDouble(json["estimatedCostWithTax"]),
      estimatedTimeMinutes: _toDouble(json["estimatedTimeMinutes"]),
      estimatedTimeHours: _toDouble(json["estimatedTimeHours"]),
      estimatedKilometres: _toDouble(json["estimatedKilometres"]),
      estimatedBatteryIncrease:
          _toDouble(json["estimatedBatteryIncrease"]),
      charger: json["charger"] != null
          ? ChargerInfo.fromJson(json["charger"])
          : null,
      car: json["car"] != null
          ? CarInfo.fromJson(json["car"])
          : null,
      costDetails: json["costDetails"] != null
          ? CostDetails.fromJson(json["costDetails"])
          : null,
    );
  }

  /// Empty fallback model
  factory EstimateChargingResponse.empty() {
    return EstimateChargingResponse(
      success: false,
      message: "",
      estimatedEnergy: 0,
      estimatedCost: 0,
      estimatedCostWithTax: 0,
      estimatedTimeMinutes: 0,
      estimatedTimeHours: 0,
      estimatedKilometres: 0,
      estimatedBatteryIncrease: 0,
    );
  }

  /// Safe double converter
  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    return double.tryParse(value.toString()) ?? 0;
  }
}
class ChargerInfo {
  final double powerOutput;
  final double tariff;
  final String chargerType;
  final String connectorId;

  ChargerInfo({
    required this.powerOutput,
    required this.tariff,
    required this.chargerType,
    required this.connectorId,
  });

  factory ChargerInfo.fromJson(Map<String, dynamic> json) {
    return ChargerInfo(
      powerOutput: EstimateChargingResponse._toDouble(json["powerOutput"]),
      tariff: EstimateChargingResponse._toDouble(json["tariff"]),
      chargerType: json["chargerType"] ?? "",
      connectorId: json["connectorId"] ?? "",
    );
  }
}
class CarInfo {
  final double batteryCapacity;
  final double efficiency;
  final double? currentBatteryPercentage;
  final double chargingEfficiency;

  CarInfo({
    required this.batteryCapacity,
    required this.efficiency,
    this.currentBatteryPercentage,
    required this.chargingEfficiency,
  });

  factory CarInfo.fromJson(Map<String, dynamic> json) {
    return CarInfo(
      batteryCapacity:
          EstimateChargingResponse._toDouble(json["batteryCapacity"]),
      efficiency:
          EstimateChargingResponse._toDouble(json["efficiency"]),
      currentBatteryPercentage: json["currentBatteryPercentage"] != null
          ? EstimateChargingResponse._toDouble(
              json["currentBatteryPercentage"])
          : null,
      chargingEfficiency:
          EstimateChargingResponse._toDouble(json["chargingEfficiency"]),
    );
  }
}
class CostDetails {
  final double energyCost;
  final double taxAmount;
  final double totalCost;
  final double costPerKm;
  final double tariffApplied;
  final String currency;

  CostDetails({
    required this.energyCost,
    required this.taxAmount,
    required this.totalCost,
    required this.costPerKm,
    required this.tariffApplied,
    required this.currency,
  });

  factory CostDetails.fromJson(Map<String, dynamic> json) {
    return CostDetails(
      energyCost:
          EstimateChargingResponse._toDouble(json["energyCost"]),
      taxAmount:
          EstimateChargingResponse._toDouble(json["taxAmount"]),
      totalCost:
          EstimateChargingResponse._toDouble(json["totalCost"]),
      costPerKm:
          EstimateChargingResponse._toDouble(json["costPerKm"]),
      tariffApplied:
          EstimateChargingResponse._toDouble(json["tariffApplied"]),
      currency: json["currency"] ?? "",
    );
  }
}

// class EstimateChargingResponse {
//   final bool success;
//   final String message;

//   final double? estimatedEnergy;
//   final double? estimatedCost;
//   final double? estimatedCostWithTax;
//   final int? estimatedTimeMinutes;
//   final double? estimatedTimeHours;
//   final double? estimatedKilometres;
//   final double? estimatedBatteryIncrease;

//   final dynamic charger;
//   final dynamic car;
//   final dynamic costDetails;

//   EstimateChargingResponse({
//     required this.success,
//     required this.message,
//     this.estimatedEnergy,
//     this.estimatedCost,
//     this.estimatedCostWithTax,
//     this.estimatedTimeMinutes,
//     this.estimatedTimeHours,
//     this.estimatedKilometres,
//     this.estimatedBatteryIncrease,
//     this.charger,
//     this.car,
//     this.costDetails,
//   });

//   factory EstimateChargingResponse.fromJson(Map<String, dynamic>? json) {
//     return EstimateChargingResponse(
//       success: json?['success'] ?? false,
//       message: json?['message'] ?? "",

//       estimatedEnergy: (json?['estimatedEnergy'] as num?)?.toDouble(),
//       estimatedCost: (json?['estimatedCost'] as num?)?.toDouble(),
//       estimatedCostWithTax: (json?['estimatedCostWithTax'] as num?)?.toDouble(),
//       estimatedTimeMinutes: json?['estimatedTimeMinutes'],
//       estimatedTimeHours: (json?['estimatedTimeHours'] as num?)?.toDouble(),
//       estimatedKilometres: (json?['estimatedKilometres'] as num?)?.toDouble(),
//       estimatedBatteryIncrease:
//           (json?['estimatedBatteryIncrease'] as num?)?.toDouble(),

//       charger: json?['charger'],
//       car: json?['car'],
//       costDetails: json?['costDetails'],
//     );
//   }
// }
