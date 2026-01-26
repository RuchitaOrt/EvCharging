import 'car_manufacturer_model.dart';

class CarManufacturerListResponse {
  final bool success;
  final String message;
  final List<CarManufacturer> data;

  CarManufacturerListResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CarManufacturerListResponse.fromJson(
      Map<String, dynamic> json) {
    return CarManufacturerListResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => CarManufacturer.fromJson(e))
              .toList() ??
          [],
    );
  }
}
class CarManufacturer {
  final String recId;
  final String manufacturerName;
  final String manufacturerLogoImage;
  final int active;
  final DateTime? createdOn;
  final DateTime? updatedOn;

  CarManufacturer({
    required this.recId,
    required this.manufacturerName,
    required this.manufacturerLogoImage,
    required this.active,
    this.createdOn,
    this.updatedOn,
  });

  factory CarManufacturer.fromJson(Map<String, dynamic> json) {
    return CarManufacturer(
      recId: json['recId'] ?? '',
      manufacturerName: json['manufacturerName'] ?? '',
      manufacturerLogoImage: json['manufacturerLogoImage'] ?? '',
      active: json['active'] ?? 0,
      createdOn: json['createdOn'] != null
          ? DateTime.tryParse(json['createdOn'])
          : null,
      updatedOn: json['updatedOn'] != null
          ? DateTime.tryParse(json['updatedOn'])
          : null,
    );
  }
}
