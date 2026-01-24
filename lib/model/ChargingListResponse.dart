class ChargingListResponse {
  final bool success;
  final String message;
  final List<Charger> chargers;
  final int totalCount;

  ChargingListResponse({
    required this.success,
    required this.message,
    required this.chargers,
    required this.totalCount,
  });

  factory ChargingListResponse.fromJson(Map<String, dynamic> json) {
    return ChargingListResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      chargers: (json['chargers'] as List<dynamic>?)
              ?.map((e) => Charger.fromJson(e))
              .toList() ??
          [],
      totalCount: json['totalCount'] ?? 0,
    );
  }
}
class Charger {
  final String chargePointId;
  final int connectorId;
  final String connectorName;
  final String lastStatus;
  final DateTime? lastStatusTime;
  final double? lastMeter;
  final DateTime? lastMeterTime;
  final String stationRecId;
  final String chargePointName;

  Charger({
    required this.chargePointId,
    required this.connectorId,
    required this.connectorName,
    required this.lastStatus,
    this.lastStatusTime,
    this.lastMeter,
    this.lastMeterTime,
    required this.stationRecId,
    required this.chargePointName,
  });

  factory Charger.fromJson(Map<String, dynamic> json) {
    return Charger(
      chargePointId: json['chargePointId'] ?? '',
      connectorId: json['connectorId'] ?? 0,
      connectorName: json['connectorName'] ?? '',
      lastStatus: json['lastStatus'] ?? '',
      lastStatusTime: json['lastStatusTime'] != null
          ? DateTime.tryParse(json['lastStatusTime'])
          : null,
      lastMeter: json['lastMeter'] != null
          ? (json['lastMeter'] as num).toDouble()
          : null,
      lastMeterTime: json['lastMeterTime'] != null
          ? DateTime.tryParse(json['lastMeterTime'])
          : null,
      stationRecId: json['stationRecId'] ?? '',
      chargePointName: json['chargePointName'] ?? '',
    );
  }
}
