class ActiveSessionResponse {
  final bool success;
  final String? message;
  final ActiveSessionData? data;

  ActiveSessionResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory ActiveSessionResponse.fromJson(Map<String, dynamic> json) {
    return ActiveSessionResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'] != null
          ? ActiveSessionData.fromJson(json['data'])
          : null,
    );
  }
}

class ActiveSessionData {
  final int totalRecords;
  final int page;
  final int pageSize;
  final int totalPages;
  final List<Session> sessions;

  ActiveSessionData({
    required this.totalRecords,
    required this.page,
    required this.pageSize,
    required this.totalPages,
    required this.sessions,
  });

  factory ActiveSessionData.fromJson(Map<String, dynamic> json) {
    return ActiveSessionData(
      totalRecords: json['totalRecords'] ?? 0,
      page: json['page'] ?? 1,
      pageSize: json['pageSize'] ?? 50,
      totalPages: json['totalPages'] ?? 1,
      sessions: json['sessions'] != null
          ? List<Session>.from(
              (json['sessions'] as List).map((x) => Session.fromJson(x)))
          : [],
    );
  }
}

class Session {
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

  Session({
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

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      recId: json['recId'] ?? '',
      chargingGunId: json['chargingGunId'] ?? '',
      chargingStationId: json['chargingStationId'] ?? '',
      chargingStationName: json['chargingStationName'] ?? '',
      chargingHubName: json['chargingHubName'] ?? '',
      startMeterReading: json['startMeterReading'] ?? '0.0',
      endMeterReading: json['endMeterReading'] ?? '0.0',
      energyTransmitted: json['energyTransmitted'] ?? '0.0',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'],
      chargingSpeed: json['chargingSpeed'] ?? '0',
      chargingTariff: json['chargingTariff'] ?? '',
      chargingTotalFee: json['chargingTotalFee'] ?? '0',
      status: json['status'] ?? 'Unknown',
      duration: json['duration'] ?? '0',
      active: json['active'] ?? 0,
      createdOn: json['createdOn'] ?? '',
      updatedOn: json['updatedOn'] ?? '',
    );
  }
}
