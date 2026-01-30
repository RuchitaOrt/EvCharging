class StartChargingSessionResponse {
  final bool success;
  final String message;
  final StartChargingData? data;

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
          ? StartChargingData.fromJson(json['data'])
          : null,
    );
  }
}

class StartChargingData {
  final ChargingSession? session;
  final int? transactionId;
  final int? meterStart;
  final String? tariff;

  StartChargingData({
    this.session,
    this.transactionId,
    this.meterStart,
    this.tariff,
  });

  factory StartChargingData.fromJson(Map<String, dynamic> json) {
    return StartChargingData(
      session: json['session'] != null
          ? ChargingSession.fromJson(json['session'])
          : null,
      transactionId: json['transactionId'],
      meterStart: json['meterStart'],
      tariff: json['tariff'],
    );
  }
}

class ChargingSession {
  final String? recId;
  final String? chargingGunId;
  final String? chargingStationId;
  final String? chargingStationName;
  final String? chargingHubName;
  final String? startMeterReading;
  final String? endMeterReading;
  final String? energyTransmitted;
  final String? startTime;
  final String? endTime;
  final String? chargingSpeed;
  final String? chargingTariff;
  final String? chargingTotalFee;
  final String? status;
  final String? duration;
  final int? active;
  final String? createdOn;
  final String? updatedOn;

  ChargingSession({
    this.recId,
    this.chargingGunId,
    this.chargingStationId,
    this.chargingStationName,
    this.chargingHubName,
    this.startMeterReading,
    this.endMeterReading,
    this.energyTransmitted,
    this.startTime,
    this.endTime,
    this.chargingSpeed,
    this.chargingTariff,
    this.chargingTotalFee,
    this.status,
    this.duration,
    this.active,
    this.createdOn,
    this.updatedOn,
  });

  factory ChargingSession.fromJson(Map<String, dynamic> json) {
    return ChargingSession(
      recId: json['recId'],
      chargingGunId: json['chargingGunId'],
      chargingStationId: json['chargingStationId'],
      chargingStationName: json['chargingStationName'],
      chargingHubName: json['chargingHubName'],
      startMeterReading: json['startMeterReading'],
      endMeterReading: json['endMeterReading'],
      energyTransmitted: json['energyTransmitted'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      chargingSpeed: json['chargingSpeed'],
      chargingTariff: json['chargingTariff'],
      chargingTotalFee: json['chargingTotalFee'],
      status: json['status'],
      duration: json['duration'],
      active: json['active'],
      createdOn: json['createdOn'],
      updatedOn: json['updatedOn'],
    );
  }
}
