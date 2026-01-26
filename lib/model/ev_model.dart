// models/ev_model.dart
class EVModel {
  final String recId;
  final String modelName;
  final String manufacturerId;
  final String manufacturerName;
  final String batteryTypeId;
  final String batteryTypeName;
  final String batteryCapacityId;
  final String batteryCapacityValue;
  final String carModelImage;
  final int active;

  EVModel({
    required this.recId,
    required this.modelName,
    required this.manufacturerId,
    required this.manufacturerName,
    required this.batteryTypeId,
    required this.batteryTypeName,
    required this.batteryCapacityId,
    required this.batteryCapacityValue,
    required this.carModelImage,
    required this.active,
  });

  factory EVModel.fromJson(Map<String, dynamic> json) {
    return EVModel(
      recId: json['recId'] ?? '',
      modelName: json['modelName'] ?? '',
      manufacturerId: json['manufacturerId'] ?? '',
      manufacturerName: json['manufacturerName'] ?? '',
      batteryTypeId: json['batteryTypeId'] ?? '',
      batteryTypeName: json['batteryTypeName'] ?? '',
      batteryCapacityId: json['batteryCapacityId'] ?? '',
      batteryCapacityValue: json['batteryCapacityValue'] ?? '',
      carModelImage: json['carModelImage'] ?? '',
      active: json['active'] ?? 0,
    );
  }
}
