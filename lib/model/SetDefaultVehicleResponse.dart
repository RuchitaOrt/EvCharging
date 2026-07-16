class SetDefaultVehicleResponse {
  bool? success;
  String? message;
  DefaultVehicle? vehicle;

  SetDefaultVehicleResponse({
    this.success,
    this.message,
    this.vehicle,
  });

  factory SetDefaultVehicleResponse.fromJson(Map<String, dynamic> json) {
    return SetDefaultVehicleResponse(
      success: json["success"],
      message: json["message"],
      vehicle: json["vehicle"] != null
          ? DefaultVehicle.fromJson(json["vehicle"])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "vehicle": vehicle?.toJson(),
      };
}

class DefaultVehicle {
  String? recId;
  String? userId;
  String? evManufacturerID;
  String? carModelID;
  String? carRegistrationNumber;
  int? defaultConfig;
  String? createdOn;
  String? updatedOn;

  DefaultVehicle({
    this.recId,
    this.userId,
    this.evManufacturerID,
    this.carModelID,
    this.carRegistrationNumber,
    this.defaultConfig,
    this.createdOn,
    this.updatedOn,
  });

  factory DefaultVehicle.fromJson(Map<String, dynamic> json) {
    return DefaultVehicle(
      recId: json["recId"],
      userId: json["userId"],
      evManufacturerID: json["evManufacturerID"],
      carModelID: json["carModelID"],
      carRegistrationNumber: json["carRegistrationNumber"],
      defaultConfig: json["defaultConfig"],
      createdOn: json["createdOn"],
      updatedOn: json["updatedOn"],
    );
  }

  Map<String, dynamic> toJson() => {
        "recId": recId,
        "userId": userId,
        "evManufacturerID": evManufacturerID,
        "carModelID": carModelID,
        "carRegistrationNumber": carRegistrationNumber,
        "defaultConfig": defaultConfig,
        "createdOn": createdOn,
        "updatedOn": updatedOn,
      };
}