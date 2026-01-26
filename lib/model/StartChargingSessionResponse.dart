class StartChargingSessionResponse {
  bool success;
  String message;
  ChargingSessionData? data;

  StartChargingSessionResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory StartChargingSessionResponse.fromJson(Map<String, dynamic> json) {
    return StartChargingSessionResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? ChargingSessionData.fromJson(json['data'])
          : null,
    );
  }
}

class ChargingSessionData {
  String? sessionId;
  String? userId;
  String? chargingStationId;
  String? chargingGunId;
  int? connectorId;
  String? startMeterReading;
  String? chargingTariff;
  String? startTime;

  ChargingSessionData({
    this.sessionId,
    this.userId,
    this.chargingStationId,
    this.chargingGunId,
    this.connectorId,
    this.startMeterReading,
    this.chargingTariff,
    this.startTime,
  });

  factory ChargingSessionData.fromJson(Map<String, dynamic> json) {
    return ChargingSessionData(
      sessionId: json['sessionId'],
      userId: json['userId'],
      chargingStationId: json['chargingStationId'],
      chargingGunId: json['chargingGunId'],
      connectorId: json['connectorId'],
      startMeterReading: json['startMeterReading'],
      chargingTariff: json['chargingTariff'],
      startTime: json['startTime'],
    );
  }
}
