class ChargingHubResponse {
  final bool success;
  final String message;
  final List<ChargingHub> hubs;
  final int totalCount;

  ChargingHubResponse({
    required this.success,
    required this.message,
    required this.hubs,
    required this.totalCount,
  });

  factory ChargingHubResponse.fromJson(Map<String, dynamic> json) {
    return ChargingHubResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      hubs: (json['hubs'] as List<dynamic>?)
              ?.map((e) => ChargingHub.fromJson(e))
              .toList() ??
          [],
      totalCount: json['totalCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'hubs': hubs.map((e) => e.toJson()).toList(),
      'totalCount': totalCount,
    };
  }
}

class ChargingHub {
  final String? recId;
  final String? chargingHubName;
  final String? addressLine1;
  final String? addressLine2;
  final String? addressLine3;
  final String? chargingHubImage;
  final String? city;
  final String? state;
  final String? pincode;
  final String? latitude;
  final String? longitude;
  final String? openingTime;
  final String? closingTime;
  final String? typeATariff;
  final String? typeBTariff;
  final String? amenities;
  final String? additionalInfo1;
  final String? additionalInfo2;
  final String? additionalInfo3;
  final int? active;
  final DateTime? createdOn;
  final DateTime? updatedOn;
  final double? distanceKm;
  final int? stationCount;
  final double? averageRating;

  ChargingHub({
    this.recId,
    this.chargingHubName,
    this.addressLine1,
    this.addressLine2,
    this.addressLine3,
    this.chargingHubImage,
    this.city,
    this.state,
    this.pincode,
    this.latitude,
    this.longitude,
    this.openingTime,
    this.closingTime,
    this.typeATariff,
    this.typeBTariff,
    this.amenities,
    this.additionalInfo1,
    this.additionalInfo2,
    this.additionalInfo3,
    this.active,
    this.createdOn,
    this.updatedOn,
    this.distanceKm,
    this.stationCount,
    this.averageRating,
  });

  factory ChargingHub.fromJson(Map<String, dynamic> json) {
    return ChargingHub(
      recId: json['recId'],
      chargingHubName: json['chargingHubName'],
      addressLine1: json['addressLine1'],
      addressLine2: json['addressLine2'],
      addressLine3: json['addressLine3'],
      chargingHubImage: json['chargingHubImage'],
      city: json['city'],
      state: json['state'],
      pincode: json['pincode'],

      // Lat/Long is sent as string, parse safely
      // latitude: json['latitude'] != null
      //     ? double.tryParse(json['latitude'].toString())
      //     : null,
      // longitude: json['longitude'] != null
      //     ? double.tryParse(json['longitude'].toString())
      //     : null,
      latitude: json['latitude'],
      longitude: json['longitude'],
      openingTime: json['openingTime'],
      closingTime: json['closingTime'],
      typeATariff: json['typeATariff'],
      typeBTariff: json['typeBTariff'],
      amenities: json['amenities'],

      additionalInfo1: json['additionalInfo1'],
      additionalInfo2: json['additionalInfo2'],
      additionalInfo3: json['additionalInfo3'],

      active: json['active'],
      createdOn: json['createdOn'] != null
          ? DateTime.tryParse(json['createdOn'])
          : null,
      updatedOn: json['updatedOn'] != null
          ? DateTime.tryParse(json['updatedOn'])
          : null,

      distanceKm: json['distanceKm'] != null
          ? double.tryParse(json['distanceKm'].toString())
          : null,
      stationCount: json['stationCount'],
      averageRating: json['averageRating'] != null
          ? double.tryParse(json['averageRating'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recId': recId,
      'chargingHubName': chargingHubName,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'addressLine3': addressLine3,
      'chargingHubImage': chargingHubImage,
      'city': city,
      'state': state,
      'pincode': pincode,
      'latitude': latitude,
      'longitude': longitude,
      'openingTime': openingTime,
      'closingTime': closingTime,
      'typeATariff': typeATariff,
      'typeBTariff': typeBTariff,
      'amenities': amenities,
      'additionalInfo1': additionalInfo1,
      'additionalInfo2': additionalInfo2,
      'additionalInfo3': additionalInfo3,
      'active': active,
      'createdOn': createdOn?.toIso8601String(),
      'updatedOn': updatedOn?.toIso8601String(),
      'distanceKm': distanceKm,
      'stationCount': stationCount,
      'averageRating': averageRating,
    };
  }
}
