import 'dart:convert';

CarManufacturerResponse carManufacturerResponseFromJson(String str) =>
    CarManufacturerResponse.fromJson(json.decode(str));

String carManufacturerResponseToJson(CarManufacturerResponse data) =>
    json.encode(data.toJson());

class CarManufacturerResponse {
  bool? success;
  String? message;
  List<CarManufacturerData>? data;

  CarManufacturerResponse({
    this.success,
    this.message,
    this.data,
  });

  factory CarManufacturerResponse.fromJson(Map<String, dynamic> json) {
    return CarManufacturerResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null
          ? []
          : List<CarManufacturerData>.from(
              json["data"].map(
                (x) => CarManufacturerData.fromJson(x),
              ),
            ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
      "data": data?.map((e) => e.toJson()).toList() ?? [],
    };
  }
}

class CarManufacturerData {
  String? recId;
  String? manufacturerName;
  String? manufacturerLogoImage;
  int? active;
  String? createdOn;
  String? updatedOn;

  CarManufacturerData({
    this.recId,
    this.manufacturerName,
    this.manufacturerLogoImage,
    this.active,
    this.createdOn,
    this.updatedOn,
  });

  factory CarManufacturerData.fromJson(Map<String, dynamic> json) {
    return CarManufacturerData(
      recId: json["recId"] ?? "",
      manufacturerName: json["manufacturerName"] ?? "",
      manufacturerLogoImage: json["manufacturerLogoImage"] ?? "",
      active: json["active"] ?? 0,
      createdOn: json["createdOn"] ?? "",
      updatedOn: json["updatedOn"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "recId": recId,
      "manufacturerName": manufacturerName,
      "manufacturerLogoImage": manufacturerLogoImage,
      "active": active,
      "createdOn": createdOn,
      "updatedOn": updatedOn,
    };
  }
}