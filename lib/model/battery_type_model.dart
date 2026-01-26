// models/battery_type_model.dart
class BatteryType {
  final String recId;
  final String batteryType;
  final int active;

  BatteryType({
    required this.recId,
    required this.batteryType,
    required this.active,
  });

  factory BatteryType.fromJson(Map<String, dynamic> json) {
    return BatteryType(
      recId: json['recId'] ?? '',
      batteryType: json['batteryType'] ?? '',
      active: json['active'] ?? 0,
    );
  }
}
