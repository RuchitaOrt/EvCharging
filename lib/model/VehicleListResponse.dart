class VehicleListResponse {
  final bool success;
  final String? message;
  final List<Vehicle> vehicles;

  VehicleListResponse({
    required this.success,
    this.message,
    required this.vehicles,
  });

  factory VehicleListResponse.fromJson(Map<String, dynamic> json) {
    return VehicleListResponse(
      success: json['success'] ?? false,
      message: json['message'],
      vehicles: (json['vehicles'] as List?)
              ?.map((e) => Vehicle.fromJson(e))
              .toList() ??
          [],
    );
  }
}
class Vehicle {
  final String? recId;
  final String? userId;
  final String? evManufacturerID;
  final String? carModelID;
  final String? carModelVariant;
  final String? carRegistrationNumber;
  final int? defaultConfig;
  final String? batteryTypeId;
  final String? batteryCapacityId;
  final DateTime? createdOn;
  final DateTime? updatedOn;

  Vehicle({
    this.recId,
    this.userId,
    this.evManufacturerID,
    this.carModelID,
    this.carModelVariant,
    this.carRegistrationNumber,
    this.defaultConfig,
    this.batteryTypeId,
    this.batteryCapacityId,
    this.createdOn,
    this.updatedOn,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      recId: json['recId'],
      userId: json['userId'],
      evManufacturerID: json['evManufacturerID'],
      carModelID: json['carModelID'],
      carModelVariant: json['carModelVariant'],
      carRegistrationNumber: json['carRegistrationNumber'],
      defaultConfig: json['defaultConfig'],
      batteryTypeId: json['batteryTypeId'],
      batteryCapacityId: json['batteryCapacityId'],
      createdOn: json['createdOn'] != null
          ? DateTime.tryParse(json['createdOn'])
          : null,
      updatedOn: json['updatedOn'] != null
          ? DateTime.tryParse(json['updatedOn'])
          : null,
    );
  }
}
