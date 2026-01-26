class UserVehicleUpdateResponse {
  final bool success;
  final String message;
  final UpdatedVehicle? vehicle;

  UserVehicleUpdateResponse({
    required this.success,
    required this.message,
    this.vehicle,
  });

  factory UserVehicleUpdateResponse.fromJson(Map<String, dynamic> json) {
    return UserVehicleUpdateResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      vehicle:
          json['vehicle'] != null ? UpdatedVehicle.fromJson(json['vehicle']) : null,
    );
  }
}

class UpdatedVehicle {
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

  UpdatedVehicle({
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

  factory UpdatedVehicle.fromJson(Map<String, dynamic> json) {
    return UpdatedVehicle(
      recId: json['recId'],
      userId: json['userId'],
      evManufacturerID: json['evManufacturerID'],
      carModelID: json['carModelID'],
      carModelVariant: json['carModelVariant'],
      carRegistrationNumber: json['carRegistrationNumber'],
      defaultConfig: json['defaultConfig'],
      batteryTypeId: json['batteryTypeId'],
      batteryCapacityId: json['batteryCapacityId'],
      createdOn:
          json['createdOn'] != null ? DateTime.parse(json['createdOn']) : null,
      updatedOn:
          json['updatedOn'] != null ? DateTime.parse(json['updatedOn']) : null,
    );
  }
}
