class EndChargingSessionResponse {
  bool success;
  String message;
  EndChargingSessionData? data;

  EndChargingSessionResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory EndChargingSessionResponse.fromJson(Map<String, dynamic> json) {
    return EndChargingSessionResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? EndChargingSessionData.fromJson(json['data'])
          : null,
    );
  }
}

class EndChargingSessionData {
  String? sessionId;
  String? userId;
  String? chargingStationId;
  String? chargingGunId;
  int? connectorId;
  String? startMeterReading;
  String? endMeterReading;
  String? chargingTariff;
  String? startTime;
  String? endTime;
  double? totalConsumedKWh;
  double? totalAmount;

  EndChargingSessionData({
    this.sessionId,
    this.userId,
    this.chargingStationId,
    this.chargingGunId,
    this.connectorId,
    this.startMeterReading,
    this.endMeterReading,
    this.chargingTariff,
    this.startTime,
    this.endTime,
    this.totalConsumedKWh,
    this.totalAmount,
  });

  factory EndChargingSessionData.fromJson(Map<String, dynamic> json) {
    return EndChargingSessionData(
      sessionId: json['sessionId'],
      userId: json['userId'],
      chargingStationId: json['chargingStationId'],
      chargingGunId: json['chargingGunId'],
      connectorId: json['connectorId'],
      startMeterReading: json['startMeterReading'],
      endMeterReading: json['endMeterReading'],
      chargingTariff: json['chargingTariff'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      totalConsumedKWh: (json['totalConsumedKWh'] != null)
          ? double.tryParse(json['totalConsumedKWh'].toString())
          : null,
      totalAmount: (json['totalAmount'] != null)
          ? double.tryParse(json['totalAmount'].toString())
          : null,
    );
  }
}
