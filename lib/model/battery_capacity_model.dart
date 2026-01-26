// models/battery_capacity_model.dart
class BatteryCapacity {
  final String recId;
  final String batteryCapacity;
  final String batteryCapacityUnit;
  final int active;

  BatteryCapacity({
    required this.recId,
    required this.batteryCapacity,
    required this.batteryCapacityUnit,
    required this.active,
  });

  factory BatteryCapacity.fromJson(Map<String, dynamic> json) {
    return BatteryCapacity(
      recId: json['recId'] ?? '',
      batteryCapacity: json['batteryCapacity'] ?? '',
      batteryCapacityUnit: json['batteryCapacityUnit'] ?? '',
      active: json['active'] ?? 0,
    );
  }
}
