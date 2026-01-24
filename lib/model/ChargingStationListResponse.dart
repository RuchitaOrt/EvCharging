class ChargingStationListResponse {
  final bool success;
  final String message;
  final List<ChargingStation> stations;
  final int totalCount;

  ChargingStationListResponse({
    required this.success,
    required this.message,
    required this.stations,
    required this.totalCount,
  });

  factory ChargingStationListResponse.fromJson(Map<String, dynamic> json) {
    return ChargingStationListResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      stations: (json['stations'] as List<dynamic>?)
              ?.map((e) => ChargingStation.fromJson(e))
              .toList() ??
          [],
      totalCount: json['totalCount'] ?? 0,
    );
  }
}
class ChargingStation {
  final String recId;
  final String chargingPointId;
  final String chargingHubId;
  final int chargingGunCount;
  final String? chargingStationImage;
  final DateTime? createdOn;
  final DateTime? updatedOn;
  final String chargePointName;
  final String? chargePointComment;
  final String? hubCity;
  final String? hubState;

  ChargingStation({
    required this.recId,
    required this.chargingPointId,
    required this.chargingHubId,
    required this.chargingGunCount,
    this.chargingStationImage,
    this.createdOn,
    this.updatedOn,
    required this.chargePointName,
    this.chargePointComment,
    this.hubCity,
    this.hubState,
  });

  factory ChargingStation.fromJson(Map<String, dynamic> json) {
    return ChargingStation(
      recId: json['recId'] ?? '',
      chargingPointId: json['chargingPointId'] ?? '',
      chargingHubId: json['chargingHubId'] ?? '',
      chargingGunCount: json['chargingGunCount'] ?? 0,
      chargingStationImage: json['chargingStationImage'],
      createdOn: json['createdOn'] != null
          ? DateTime.tryParse(json['createdOn'])
          : null,
      updatedOn: json['updatedOn'] != null
          ? DateTime.tryParse(json['updatedOn'])
          : null,
      chargePointName: json['chargePointName'] ?? '',
      chargePointComment: json['chargePointComment'],
      hubCity: json['hubCity'],
      hubState: json['hubState'],
    );
  }
}
