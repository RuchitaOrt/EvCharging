class UserVehicle {
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

  UserVehicle({
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

  factory UserVehicle.fromJson(Map<String, dynamic> json) => UserVehicle(
        recId: json['recId'] as String?,
        userId: json['userId'] as String?,
        evManufacturerID: json['evManufacturerID'] as String?,
        carModelID: json['carModelID'] as String?,
        carModelVariant: json['carModelVariant'] as String?,
        carRegistrationNumber: json['carRegistrationNumber'] as String?,
        defaultConfig: json['defaultConfig'] != null
            ? int.tryParse(json['defaultConfig'].toString())
            : null,
        batteryTypeId: json['batteryTypeId'] as String?,
        batteryCapacityId: json['batteryCapacityId'] as String?,
        createdOn: json['createdOn'] != null
            ? DateTime.tryParse(json['createdOn'])
            : null,
        updatedOn: json['updatedOn'] != null
            ? DateTime.tryParse(json['updatedOn'])
            : null,
      );
}

class UserVehicleResponse {
  final bool success;
  final String? message;
  final UserVehicle? vehicle;

  UserVehicleResponse({
    required this.success,
    this.message,
    this.vehicle,
  });

  factory UserVehicleResponse.fromJson(Map<String, dynamic> json) =>
      UserVehicleResponse(
        success: json['success'] ?? false,
        message: json['message'] as String?,
        vehicle: json['vehicle'] != null
            ? UserVehicle.fromJson(json['vehicle'])
            : null,
      );
}
