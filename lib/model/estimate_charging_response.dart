class EstimateChargingResponse {
  final bool success;
  final String message;

  final double? estimatedEnergy;
  final double? estimatedCost;
  final double? estimatedCostWithTax;
  final int? estimatedTimeMinutes;
  final double? estimatedTimeHours;
  final double? estimatedKilometres;
  final double? estimatedBatteryIncrease;

  final dynamic charger;
  final dynamic car;
  final dynamic costDetails;

  EstimateChargingResponse({
    required this.success,
    required this.message,
    this.estimatedEnergy,
    this.estimatedCost,
    this.estimatedCostWithTax,
    this.estimatedTimeMinutes,
    this.estimatedTimeHours,
    this.estimatedKilometres,
    this.estimatedBatteryIncrease,
    this.charger,
    this.car,
    this.costDetails,
  });

  factory EstimateChargingResponse.fromJson(Map<String, dynamic>? json) {
    return EstimateChargingResponse(
      success: json?['success'] ?? false,
      message: json?['message'] ?? "",

      estimatedEnergy: (json?['estimatedEnergy'] as num?)?.toDouble(),
      estimatedCost: (json?['estimatedCost'] as num?)?.toDouble(),
      estimatedCostWithTax: (json?['estimatedCostWithTax'] as num?)?.toDouble(),
      estimatedTimeMinutes: json?['estimatedTimeMinutes'],
      estimatedTimeHours: (json?['estimatedTimeHours'] as num?)?.toDouble(),
      estimatedKilometres: (json?['estimatedKilometres'] as num?)?.toDouble(),
      estimatedBatteryIncrease:
          (json?['estimatedBatteryIncrease'] as num?)?.toDouble(),

      charger: json?['charger'],
      car: json?['car'],
      costDetails: json?['costDetails'],
    );
  }
}
