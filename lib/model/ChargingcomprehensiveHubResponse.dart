class ChargingcomprehensiveHubResponse {
  final bool success;
  final String message;
  final List<ChargingHub> hubs;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final int totalPages;

  ChargingcomprehensiveHubResponse({
    required this.success,
    required this.message,
    required this.hubs,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
  });

  factory ChargingcomprehensiveHubResponse.fromJson(Map<String, dynamic> json) {
    return ChargingcomprehensiveHubResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      hubs: (json['hubs'] as List? ?? [])
          .map((e) => ChargingHub.fromJson(e))
          .toList(),
      totalCount: json['totalCount'] ?? 0,
      pageNumber: json['pageNumber'] ?? 0,
      pageSize: json['pageSize'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }
}
class ChargingHub {
  final String recId;
  final String chargingHubName;
  final String addressLine1;
  final String city;
  final String state;
  final String pincode;
  final String? latitude;
  final String? longitude;
  final String? chargingHubImage;
  final String openingTime;
  final String closingTime;
  final String? typeATariff;
  final String? typeBTariff;
  final String? amenities;
  final String? distanceKm;
  final int totalStations;
  final int totalChargers;
  final int availableChargers;
  final List<ChargingStation> stations;

  ChargingHub({
    required this.recId,
    required this.chargingHubName,
    required this.addressLine1,
    required this.city,
    required this.state,
    required this.pincode,
    this.latitude,
    this.longitude,
    this.chargingHubImage,
    required this.openingTime,
    required this.closingTime,
    this.typeATariff,
    this.typeBTariff,
    this.amenities,
    this.distanceKm,
    required this.totalStations,
    required this.totalChargers,
    required this.availableChargers,
    required this.stations,
  });

  factory ChargingHub.fromJson(Map<String, dynamic> json) {
    return ChargingHub(
      recId: json['recId'] ?? '',
      chargingHubName: json['chargingHubName'] ?? '',
      addressLine1: json['addressLine1'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? '',
      latitude: json['latitude'],
      longitude: json['longitude'],
      chargingHubImage: json['chargingHubImage'],
      openingTime: json['openingTime'] ?? '',
      closingTime: json['closingTime'] ?? '',
      typeATariff: json['typeATariff'],
      typeBTariff: json['typeBTariff'],
      amenities: json['amenities'],
      // distanceKm: json['distanceKm']?.toDouble(),
      distanceKm: json['distanceKm']?? '',
      totalStations: json['totalStations'] ?? 0,
      totalChargers: json['totalChargers'] ?? 0,
      availableChargers: json['availableChargers'] ?? 0,
      stations: (json['stations'] as List? ?? [])
          .map((e) => ChargingStation.fromJson(e))
          .toList(),
    );
  }
}
class ChargingStation {
  final String recId;
  final String chargingPointId;
  final String chargePointName;
  final int chargingGunCount;
  final String? chargingStationImage;
  final int totalChargers;
  final int availableChargers;
  final List<Charger> chargers;

  ChargingStation({
    required this.recId,
    required this.chargingPointId,
    required this.chargePointName,
    required this.chargingGunCount,
    this.chargingStationImage,
    required this.totalChargers,
    required this.availableChargers,
    required this.chargers,
  });

  factory ChargingStation.fromJson(Map<String, dynamic> json) {
    return ChargingStation(
      recId: json['recId'] ?? '',
      chargingPointId: json['chargingPointId'] ?? '',
      chargePointName: json['chargePointName'] ?? '',
      chargingGunCount: json['chargingGunCount'] ?? 0,
      chargingStationImage: json['chargingStationImage'],
      totalChargers: json['totalChargers'] ?? 0,
      availableChargers: json['availableChargers'] ?? 0,
      chargers: (json['chargers'] as List? ?? [])
          .map((e) => Charger.fromJson(e))
          .toList(),
    );
  }
}
class Charger {
  final String chargePointId;
  final int connectorId;
  final String connectorName;
  final String lastStatus;
  final String? lastStatusTime;
  final String? lastMeter;
  final String? lastMeterTime;

  Charger({
    required this.chargePointId,
    required this.connectorId,
    required this.connectorName,
    required this.lastStatus,
    this.lastStatusTime,
    this.lastMeter,
    this.lastMeterTime,
  });

  factory Charger.fromJson(Map<String, dynamic> json) {
    return Charger(
      chargePointId: json['chargePointId'] ?? '',
      connectorId: json['connectorId'] ?? 0,
      connectorName: json['connectorName'] ?? '',
      lastStatus: json['lastStatus'] ?? '',
      lastStatusTime: json['lastStatusTime'],
      lastMeter: json['lastMeter']?.toString(),
      lastMeterTime: json['lastMeterTime']?.toString(),
    );
  }
}
