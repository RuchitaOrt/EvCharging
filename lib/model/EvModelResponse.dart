import 'dart:convert';

EvModelResponse evModelResponseFromJson(String str) =>
    EvModelResponse.fromJson(json.decode(str));

String evModelResponseToJson(EvModelResponse data) =>
    json.encode(data.toJson());

class EvModelResponse {
  bool? success;
  String? message;
  List<EvModelData>? data;

  EvModelResponse({
    this.success,
    this.message,
    this.data,
  });

  factory EvModelResponse.fromJson(Map<String, dynamic> json) {
    return EvModelResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null
          ? []
          : List<EvModelData>.from(
              json["data"].map(
                (x) => EvModelData.fromJson(x),
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

class EvModelData {
  String? recId;
  String? modelName;
  String? manufacturerId;
  String? manufacturerName;
  String? variant;
  String? batteryTypeId;
  String? batteryTypeName;
  String? batteryCapacityId;
  String? batteryCapacityValue;
  String? carModelImage;
  bool? typeASupport;
  bool? typeBSupport;
  bool? chadeMOSupport;
  bool? ccsSupport;
  int? active;
  String? createdOn;
  String? updatedOn;

  EvModelData({
    this.recId,
    this.modelName,
    this.manufacturerId,
    this.manufacturerName,
    this.variant,
    this.batteryTypeId,
    this.batteryTypeName,
    this.batteryCapacityId,
    this.batteryCapacityValue,
    this.carModelImage,
    this.typeASupport,
    this.typeBSupport,
    this.chadeMOSupport,
    this.ccsSupport,
    this.active,
    this.createdOn,
    this.updatedOn,
  });

  factory EvModelData.fromJson(Map<String, dynamic> json) {
    return EvModelData(
      recId: json["recId"] ?? "",
      modelName: json["modelName"] ?? "",
      manufacturerId: json["manufacturerId"] ?? "",
      manufacturerName: json["manufacturerName"] ?? "",
      variant: json["variant"] ?? "",
      batteryTypeId: json["batteryTypeId"] ?? "",
      batteryTypeName: json["batteryTypeName"] ?? "",
      batteryCapacityId: json["batteryCapacityId"] ?? "",
      batteryCapacityValue: json["batteryCapacityValue"] ?? "",
      carModelImage: json["carModelImage"] ?? "",
      typeASupport: json["typeASupport"],
      typeBSupport: json["typeBSupport"],
      chadeMOSupport: json["chadeMOSupport"],
      ccsSupport: json["ccsSupport"],
      active: json["active"] ?? 0,
      createdOn: json["createdOn"] ?? "",
      updatedOn: json["updatedOn"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "recId": recId,
      "modelName": modelName,
      "manufacturerId": manufacturerId,
      "manufacturerName": manufacturerName,
      "variant": variant,
      "batteryTypeId": batteryTypeId,
      "batteryTypeName": batteryTypeName,
      "batteryCapacityId": batteryCapacityId,
      "batteryCapacityValue": batteryCapacityValue,
      "carModelImage": carModelImage,
      "typeASupport": typeASupport,
      "typeBSupport": typeBSupport,
      "chadeMOSupport": chadeMOSupport,
      "ccsSupport": ccsSupport,
      "active": active,
      "createdOn": createdOn,
      "updatedOn": updatedOn,
    };
  }
}