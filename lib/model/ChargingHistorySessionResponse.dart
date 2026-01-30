class ChargingSession {
  final String recId;
  final String chargingGunId;
  final String chargingStationId;
  final String chargingStationName;
  final String chargingHubName;
  final String startMeterReading;
  final String endMeterReading;
  final String energyTransmitted;
  final String startTime;
  final String? endTime;
  final String chargingSpeed;
  final String chargingTariff;
  final String chargingTotalFee;
  final String status;
  final String duration;
  final int active;
  final String createdOn;
  final String updatedOn;

  ChargingSession({
    required this.recId,
    required this.chargingGunId,
    required this.chargingStationId,
    required this.chargingStationName,
    required this.chargingHubName,
    required this.startMeterReading,
    required this.endMeterReading,
    required this.energyTransmitted,
    required this.startTime,
    this.endTime,
    required this.chargingSpeed,
    required this.chargingTariff,
    required this.chargingTotalFee,
    required this.status,
    required this.duration,
    required this.active,
    required this.createdOn,
    required this.updatedOn,
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
      chargingSpeed: json['chargingSpeed'].toString(),
      chargingTariff: json['chargingTariff'],
      chargingTotalFee: json['chargingTotalFee'].toString(),
      status: json['status'],
      duration: json['duration'],
      active: json['active'],
      createdOn: json['createdOn'],
      updatedOn: json['updatedOn'],
    );
  }
}

class ChargingSessionResponse {
  final bool success;
  final String message;
  final List<ChargingSession> sessions;
  final int totalRecords;
  final int page;
  final int pageSize;
  final int totalPages;

  ChargingSessionResponse({
    required this.success,
    required this.message,
    required this.sessions,
    required this.totalRecords,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  factory ChargingSessionResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data']['sessions'] as List;
    List<ChargingSession> sessionList =
        list.map((i) => ChargingSession.fromJson(i)).toList();

    return ChargingSessionResponse(
      success: json['success'],
      message: json['message'],
      sessions: sessionList,
      totalRecords: json['data']['totalRecords'],
      page: json['data']['page'],
      pageSize: json['data']['pageSize'],
      totalPages: json['data']['totalPages'],
    );
  }
}
