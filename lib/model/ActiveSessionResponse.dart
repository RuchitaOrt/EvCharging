class ActiveSessionResponse {
  final bool success;
  final String message;
  final ActiveSessionData? data;

  ActiveSessionResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ActiveSessionResponse.fromJson(Map<String, dynamic> json) {
    return ActiveSessionResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? "",
      data: json['data'] != null
          ? ActiveSessionData.fromJson(json['data'])
          : null,
    );
  }
}
class ActiveSessionData {
  final int totalRecords;
  final List<ChargingSession> sessions;
  final ChargingSessionsSummary? summary;

  ActiveSessionData({
    required this.totalRecords,
    required this.sessions,
    this.summary,
  });

  factory ActiveSessionData.fromJson(Map<String, dynamic> json) {
    return ActiveSessionData(
      totalRecords: json['totalRecords'] ?? 0,
      sessions: (json['sessions'] as List<dynamic>?)
              ?.map((e) => ChargingSession.fromJson(e))
              .toList() ??
          [],
      summary: json['summary'] != null
          ? ChargingSessionsSummary.fromJson(json['summary'])
          : null,
    );
  }
}
class ChargingSessionsSummary {
  final double totalEnergyTransmitted;
  final String totalEnergyUnit;
  final double totalChargingTotalFee;
  final String totalFeeUnit;
  final ChargingTimeSummary totalChargingTime;

  ChargingSessionsSummary({
    required this.totalEnergyTransmitted,
    required this.totalEnergyUnit,
    required this.totalChargingTotalFee,
    required this.totalFeeUnit,
    required this.totalChargingTime,
  });

  factory ChargingSessionsSummary.fromJson(Map<String, dynamic> json) {
    return ChargingSessionsSummary(
      totalEnergyTransmitted:
          double.tryParse(json['totalEnergyTransmitted']?.toString() ?? '') ??
              0.0,
      totalEnergyUnit: json['totalEnergyUnit'] ?? "",
      totalChargingTotalFee:
          double.tryParse(json['totalChargingTotalFee']?.toString() ?? '') ??
              0.0,
      totalFeeUnit: json['totalFeeUnit'] ?? "",
      totalChargingTime:
          ChargingTimeSummary.fromJson(json['totalChargingTime']),
    );
  }
}
class ChargingTimeSummary {
  final double totalHours;
  final int totalMinutes;
  final String formattedDuration;

  ChargingTimeSummary({
    required this.totalHours,
    required this.totalMinutes,
    required this.formattedDuration,
  });

  factory ChargingTimeSummary.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return ChargingTimeSummary(
        totalHours: 0,
        totalMinutes: 0,
        formattedDuration: "0m",
      );
    }

    return ChargingTimeSummary(
      totalHours:
          double.tryParse(json['totalHours']?.toString() ?? '') ?? 0.0,
      totalMinutes:
          int.tryParse(json['totalMinutes']?.toString() ?? '') ?? 0,
      formattedDuration: json['formattedDuration'] ?? "0m",
    );
  }
}
class ChargingSession {
  final String recId;
  final String chargingGunId;
  final String connectorName;
  final String chargingStationId;
  final String chargingStationName;
  final String chargingHubName;
  final String startMeterReading;
  final String endMeterReading;
  final String energyTransmitted;
  final DateTime? startTime;
  final DateTime? endTime;
  final String chargingSpeed;
  final String chargingTariff;
  final String chargingTotalFee;
  final String status;
  final String duration;
  final int active;
  final DateTime? createdOn;
  final DateTime? updatedOn;
  final int? soCStart;
  final int? soCEnd;
  final String? soCLastUpdate;

  ChargingSession({
    required this.recId,
    required this.chargingGunId,
    required this.connectorName,
    required this.chargingStationId,
    required this.chargingStationName,
    required this.chargingHubName,
    required this.startMeterReading,
    required this.endMeterReading,
    required this.energyTransmitted,
    this.startTime,
    this.endTime,
    required this.chargingSpeed,
    required this.chargingTariff,
    required this.chargingTotalFee,
    required this.status,
    required this.duration,
    required this.active,
    this.createdOn,
    this.updatedOn,
    this.soCStart,
    this.soCEnd,
    this.soCLastUpdate,
  });

  factory ChargingSession.fromJson(Map<String, dynamic> json) {
    return ChargingSession(
      recId: json['recId'] ?? '',
      chargingGunId: json['chargingGunId'] ?? '',
      connectorName: json['connectorName'] ?? '',
      chargingStationId: json['chargingStationId'] ?? '',
      chargingStationName: json['chargingStationName'] ?? '',
      chargingHubName: json['chargingHubName'] ?? '',
      startMeterReading: json['startMeterReading'] ?? '0',
      endMeterReading: json['endMeterReading'] ?? '0',
      energyTransmitted: json['energyTransmitted'] ?? '0',
      startTime: json['startTime'] != null
          ? DateTime.tryParse(json['startTime'])
          : null,
      endTime: json['endTime'] != null
          ? DateTime.tryParse(json['endTime'])
          : null,
      chargingSpeed: json['chargingSpeed'] ?? '0',
      chargingTariff: json['chargingTariff'] ?? '0',
      chargingTotalFee: json['chargingTotalFee'] ?? '0',
      status: json['status'] ?? '',
      duration: json['duration'] ?? '',
      active: json['active'] ?? 0,
      createdOn: json['createdOn'] != null
          ? DateTime.tryParse(json['createdOn'])
          : null,
      updatedOn: json['updatedOn'] != null
          ? DateTime.tryParse(json['updatedOn'])
          : null,
      soCStart: json['soCStart'],
      soCEnd: json['soCEnd'],
      soCLastUpdate: json['soCLastUpdate'],
    );
  }
}


// class ActiveSessionResponse {
//   final bool success;
//   final String message;
//   final ActiveSessionData? data;

//   ActiveSessionResponse({
//     required this.success,
//     required this.message,
//     this.data,
//   });

//   factory ActiveSessionResponse.fromJson(Map<String, dynamic> json) {
//     return ActiveSessionResponse(
//       success: json['success'] ?? false,
//       message: json['message'] ?? '',
//       data: json['data'] != null
//           ? ActiveSessionData.fromJson(json['data'])
//           : null,
//     );
//   }
// }
// class ActiveSessionData {
//   final int totalRecords;
//   final int page;
//   final int pageSize;
//   final int totalPages;
//   final List<Session> sessions;

//   ActiveSessionData({
//     required this.totalRecords,
//     required this.page,
//     required this.pageSize,
//     required this.totalPages,
//     required this.sessions,
//   });

//   factory ActiveSessionData.fromJson(Map<String, dynamic> json) {
//     return ActiveSessionData(
//       totalRecords: json['totalRecords'] ?? 0,
//       page: json['page'] ?? 0,
//       pageSize: json['pageSize'] ?? 0,
//       totalPages: json['totalPages'] ?? 0,
//       sessions: (json['sessions'] as List<dynamic>?)
//               ?.map((e) => Session.fromJson(e))
//               .toList() ??
//           [],
//     );
//   }
// }
// class Session {
//   final String recId;
//   final String chargingGunId;
//   final String connectorName;
//   final String chargingStationId;
//   final String chargingStationName;
//   final String chargingHubName;

//   final String startMeterReading;
//   final String endMeterReading;
//   final String energyTransmitted;

//   final DateTime? startTime;
//   final DateTime? endTime;

//   final String chargingSpeed;
//   final String chargingTariff;
//   final String chargingTotalFee;

//   final String status;
//   final String duration;
//   final int active;

//   final DateTime? createdOn;
//   final DateTime? updatedOn;

//   final int? soCStart;
//   final int? soCEnd;
//   final DateTime? soCLastUpdate;

//   Session({
//     required this.recId,
//     required this.chargingGunId,
//     required this.connectorName,
//     required this.chargingStationId,
//     required this.chargingStationName,
//     required this.chargingHubName,
//     required this.startMeterReading,
//     required this.endMeterReading,
//     required this.energyTransmitted,
//     required this.startTime,
//     required this.endTime,
//     required this.chargingSpeed,
//     required this.chargingTariff,
//     required this.chargingTotalFee,
//     required this.status,
//     required this.duration,
//     required this.active,
//     required this.createdOn,
//     required this.updatedOn,
//     required this.soCStart,
//     required this.soCEnd,
//     required this.soCLastUpdate,
//   });

//   factory Session.fromJson(Map<String, dynamic> json) {
//     DateTime? parseDate(String? value) {
//       if (value == null || value.isEmpty) return null;
//       return DateTime.tryParse(value);
//     }

//     return Session(
//       recId: json['recId'] ?? '',
//       chargingGunId: json['chargingGunId'] ?? '',
//       connectorName: json['connectorName'] ?? '',
//       chargingStationId: json['chargingStationId'] ?? '',
//       chargingStationName: json['chargingStationName'] ?? '',
//       chargingHubName: json['chargingHubName'] ?? '',

//       startMeterReading: json['startMeterReading'] ?? '0',
//       endMeterReading: json['endMeterReading'] ?? '0',
//       energyTransmitted: json['energyTransmitted'] ?? '0',

//       startTime: parseDate(json['startTime']),
//       endTime: parseDate(json['endTime']),

//       chargingSpeed: json['chargingSpeed'] ?? '0',
//       chargingTariff: json['chargingTariff'] ?? '0',
//       chargingTotalFee: json['chargingTotalFee'] ?? '0',

//       status: json['status'] ?? '',
//       duration: json['duration'] ?? '',
//       active: json['active'] ?? 0,

//       createdOn: parseDate(json['createdOn']),
//       updatedOn: parseDate(json['updatedOn']),

//       soCStart: json['soCStart'],
//       soCEnd: json['soCEnd'],
//       soCLastUpdate: parseDate(json['soCLastUpdate']),
//     );
//   }
// }


// // class ActiveSessionResponse {
// //   final bool success;
// //   final String? message;
// //   final ActiveSessionData? data;

// //   ActiveSessionResponse({
// //     required this.success,
// //     this.message,
// //     this.data,
// //   });

// //   factory ActiveSessionResponse.fromJson(Map<String, dynamic> json) {
// //     return ActiveSessionResponse(
// //       success: json['success'] ?? false,
// //       message: json['message'],
// //       data: json['data'] != null
// //           ? ActiveSessionData.fromJson(json['data'])
// //           : null,
// //     );
// //   }
// // }

// // class ActiveSessionData {
// //   final int totalRecords;
// //   final int page;
// //   final int pageSize;
// //   final int totalPages;
// //   final List<Session> sessions;

// //   ActiveSessionData({
// //     required this.totalRecords,
// //     required this.page,
// //     required this.pageSize,
// //     required this.totalPages,
// //     required this.sessions,
// //   });

// //   factory ActiveSessionData.fromJson(Map<String, dynamic> json) {
// //     return ActiveSessionData(
// //       totalRecords: json['totalRecords'] ?? 0,
// //       page: json['page'] ?? 1,
// //       pageSize: json['pageSize'] ?? 50,
// //       totalPages: json['totalPages'] ?? 1,
// //       sessions: json['sessions'] != null
// //           ? List<Session>.from(
// //               (json['sessions'] as List).map((x) => Session.fromJson(x)))
// //           : [],
// //     );
// //   }
// // }

// // class Session {
// //   final String recId;
// //   final String chargingGunId;
// //   final String connectorName;
// //   final String chargingStationId;
// //   final String chargingStationName;
// //   final String chargingHubName;
// //   final String startMeterReading;
// //   final String endMeterReading;
// //   final String energyTransmitted;
// //   final String startTime;
// //   final String? endTime;
// //   final String chargingSpeed;
// //   final String chargingTariff;
// //   final String chargingTotalFee;
// //   final String status;
// //   final String duration;
// //   final int active;
// //   final String createdOn;
// //   final String updatedOn;

// //   Session({
// //     required this.recId,
// //     required this.chargingGunId,
// //     required this.connectorName,
// //     required this.chargingStationId,
// //     required this.chargingStationName,
// //     required this.chargingHubName,
// //     required this.startMeterReading,
// //     required this.endMeterReading,
// //     required this.energyTransmitted,
// //     required this.startTime,
// //     this.endTime,
// //     required this.chargingSpeed,
// //     required this.chargingTariff,
// //     required this.chargingTotalFee,
// //     required this.status,
// //     required this.duration,
// //     required this.active,
// //     required this.createdOn,
// //     required this.updatedOn,
// //   });

// //   factory Session.fromJson(Map<String, dynamic> json) {
// //     return Session(
// //       recId: json['recId'] ?? '',
// //       chargingGunId: json['chargingGunId'] ?? '',
// //       connectorName: json['connectorName'] ?? '',
// //       chargingStationId: json['chargingStationId'] ?? '',
// //       chargingStationName: json['chargingStationName'] ?? '',
// //       chargingHubName: json['chargingHubName'] ?? '',
// //       startMeterReading: json['startMeterReading'] ?? '0.0',
// //       endMeterReading: json['endMeterReading'] ?? '0.0',
// //       energyTransmitted: json['energyTransmitted'] ?? '0.0',
// //       startTime: json['startTime'] ?? '',
// //       endTime: json['endTime'],
// //       chargingSpeed: json['chargingSpeed'] ?? '0',
// //       chargingTariff: json['chargingTariff'] ?? '',
// //       chargingTotalFee: json['chargingTotalFee'] ?? '0',
// //       status: json['status'] ?? 'Unknown',
// //       duration: json['duration'] ?? '0',
// //       active: json['active'] ?? 0,
// //       createdOn: json['createdOn'] ?? '',
// //       updatedOn: json['updatedOn'] ?? '',
// //     );
// //   }
// // }
