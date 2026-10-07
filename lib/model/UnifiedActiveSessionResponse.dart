// // class UnifiedActiveSessionResponse {
// //   final bool? success;
// //   final dynamic? message;
// //   final List<Session>? sessions;
// //   final dynamic? totalCount;
// //   final dynamic? page;
// //   final dynamic? pageSize;
// //   final dynamic? totalPages;

// //   UnifiedActiveSessionResponse({
// //     this.success,
// //     this.message,
// //     this.sessions,
// //     this.totalCount,
// //     this.page,
// //     this.pageSize,
// //     this.totalPages,
// //   });

// //   factory UnifiedActiveSessionResponse.fromJson(Map<String, dynamic> json) {
// //     return UnifiedActiveSessionResponse(
// //       success: json['success'] as bool?,
// //       message: json['message'] as dynamic?,
// //       sessions: (json['sessions'] as List?)
// //           ?.map((e) => Session.fromJson(e as Map<String, dynamic>))
// //           .toList(),
// //       totalCount: json['totalCount'] as dynamic?,
// //       page: json['page'] as dynamic?,
// //       pageSize: json['pageSize'] as dynamic?,
// //       totalPages: json['totalPages'] as dynamic?,
// //     );
// //   }

// //   Map<String, dynamic> toJson() => {
// //         "success": success,
// //         "message": message,
// //         "sessions": sessions?.map((e) => e.toJson()).toList(),
// //         "totalCount": totalCount,
// //         "page": page,
// //         "pageSize": pageSize,
// //         "totalPages": totalPages,
// //       };
// // }

// // class Session {
// //   final dynamic? id;
// //   final dynamic? providerType;
// //   final dynamic? status;
// //   final bool? isActive;
// //   final DateTime? startTime;
// //   final DateTime? endTime;
// //   final dynamic? meterStart;
// //   final dynamic? meterCurrent;
// //   final dynamic? energyDelivered;
// //   final dynamic? cost;
// //   final dynamic? currency;
// //   final dynamic? locationName;
// //   final dynamic? partnerName;
// //   final dynamic? stationId;
// //   final dynamic? connectorId;
// //   final dynamic? energyLimit;
// //   final dynamic? costLimit;
// //   final dynamic? timeLimit;
// //   final dynamic? batteryIncreaseLimit;
// //   final dynamic? limitProgress;
// //   final BatteryStateOfCharge? batteryStateOfCharge;
// //   final dynamic walletTransaction;

// //   /// Keep raw dynamic because Local & Partner have different structures
// //   final Map<String, dynamic>? raw;

// //   Session({
// //     this.id,
// //     this.providerType,
// //     this.status,
// //     this.isActive,
// //     this.startTime,
// //     this.endTime,
// //     this.meterStart,
// //     this.meterCurrent,
// //     this.energyDelivered,
// //     this.cost,
// //     this.currency,
// //     this.locationName,
// //     this.partnerName,
// //     this.stationId,
// //     this.connectorId,
// //     this.energyLimit,
// //     this.costLimit,
// //     this.timeLimit,
// //     this.batteryIncreaseLimit,
// //     this.limitProgress,
// //     this.batteryStateOfCharge,
// //     this.walletTransaction,
// //     this.raw,
// //   });

// //   factory Session.fromJson(Map<String, dynamic> json) {
// //     return Session(
// //       id: json["id"] as dynamic?,
// //       providerType: json["providerType"] as dynamic?,
// //       status: json["status"] as dynamic?,
// //       isActive: json["isActive"] as bool?,
// //       startTime: json["startTime"] != null
// //           ? DateTime.tryParse(json["startTime"])
// //           : null,
// //       endTime:
// //           json["endTime"] != null ? DateTime.tryParse(json["endTime"]) : null,
// //       meterStart: (json["meterStart"]).toString(),
// //       meterCurrent: (json["meterCurrent"])?.toString(),
// //       energyDelivered: (json["energyDelivered"])?.toString(),
// //       cost: (json["cost"])?.toString(),
// //       currency: json["currency"] as dynamic?,
// //       locationName: json["locationName"] as dynamic?,
// //       partnerName: json["partnerName"] as dynamic?,
// //       stationId: json["stationId"] as dynamic?,
// //       connectorId: json["connectorId"] as dynamic?,
// //       energyLimit: (json["energyLimit"])?.toString(),
// //       costLimit: (json["costLimit"])?.toString(),
// //       timeLimit: (json["timeLimit"] )?.toString(),
// //       batteryIncreaseLimit:
// //           (json["batteryIncreaseLimit"])?.toString(),
// //       limitProgress: (json["limitProgress"])?.toString(),
// //       batteryStateOfCharge: json["batteryStateOfCharge"] != null
// //           ? BatteryStateOfCharge.fromJson(
// //               json["batteryStateOfCharge"] as Map<String, dynamic>)
// //           : null,
// //       walletTransaction: json["walletTransaction"],
// //       raw: json["raw"] as Map<String, dynamic>?,
// //     );
// //   }

// //   Map<String, dynamic> toJson() => {
// //         "id": id,
// //         "providerType": providerType,
// //         "status": status,
// //         "isActive": isActive,
// //         "startTime": startTime?.toString(),
// //         "endTime": endTime?.toString(),
// //         "meterStart": meterStart,
// //         "meterCurrent": meterCurrent,
// //         "energyDelivered": energyDelivered,
// //         "cost": cost,
// //         "currency": currency,
// //         "locationName": locationName,
// //         "partnerName": partnerName,
// //         "stationId": stationId,
// //         "connectorId": connectorId,
// //         "energyLimit": energyLimit,
// //         "costLimit": costLimit,
// //         "timeLimit": timeLimit,
// //         "batteryIncreaseLimit": batteryIncreaseLimit,
// //         "limitProgress": limitProgress,
// //         "batteryStateOfCharge": batteryStateOfCharge?.toJson(),
// //         "walletTransaction": walletTransaction,
// //         "raw": raw,
// //       };
// // }

// // class BatteryStateOfCharge {
// //   final dynamic? startSoC;
// //   final dynamic? endSoC;
// //   final dynamic? currentSoC;
// //   final dynamic? soCGain;
// //   final DateTime? lastUpdate;
// //   final dynamic? unit;
// //   final bool? isRealtime;
// //   final dynamic? dataSource;

// //   BatteryStateOfCharge({
// //     this.startSoC,
// //     this.endSoC,
// //     this.currentSoC,
// //     this.soCGain,
// //     this.lastUpdate,
// //     this.unit,
// //     this.isRealtime,
// //     this.dataSource,
// //   });

// //   factory BatteryStateOfCharge.fromJson(Map<String, dynamic> json) {
// //     return BatteryStateOfCharge(
// //       startSoC: json["startSoC"] as dynamic?,
// //       endSoC: json["endSoC"] as dynamic?,
// //       currentSoC: json["currentSoC"] as dynamic?,
// //       soCGain: json["soCGain"] as dynamic?,
// //       lastUpdate: json["lastUpdate"] != null
// //           ? DateTime.tryParse(json["lastUpdate"])
// //           : null,
// //       unit: json["unit"] as dynamic?,
// //       isRealtime: json["isRealtime"] as bool?,
// //       dataSource: json["dataSource"] as dynamic?,
// //     );
// //   }

// //   Map<String, dynamic> toJson() => {
// //         "startSoC": startSoC,
// //         "endSoC": endSoC,
// //         "currentSoC": currentSoC,
// //         "soCGain": soCGain,
// //         "lastUpdate": lastUpdate?.toString(),
// //         "unit": unit,
// //         "isRealtime": isRealtime,
// //         "dataSource": dataSource,
// //       };
// // }
// class UnifiedActiveSessionResponse {
//   final bool? success;
//   final SessionData? data;

//   UnifiedActiveSessionResponse({
//     this.success,
//     this.data,
//   });

//   factory UnifiedActiveSessionResponse.fromJson(Map<String, dynamic> json) {
//     return UnifiedActiveSessionResponse(
//       success: json['success'],
//       data: json['data'] != null
//           ? SessionData.fromJson(json['data'])
//           : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       "success": success,
//       "data": data?.toJson(),
//     };
//   }
// }


// class SessionData {
//   final int? totalCount;
//   final int? page;
//   final int? pageSize;
//   final int? totalPages;
//   final List<Session>? sessions;

//   SessionData({
//     this.totalCount,
//     this.page,
//     this.pageSize,
//     this.totalPages,
//     this.sessions,
//   });


//   factory SessionData.fromJson(Map<String, dynamic> json) {
//     return SessionData(
//       totalCount: json['totalCount'],
//       page: json['page'],
//       pageSize: json['pageSize'],
//       totalPages: json['totalPages'],

//       sessions: json['sessions'] != null
//           ? List<Session>.from(
//               json['sessions']
//                   .map((x) => Session.fromJson(x)),
//             )
//           : [],
//     );
//   }


//   Map<String, dynamic> toJson() {
//     return {
//       "totalCount": totalCount,
//       "page": page,
//       "pageSize": pageSize,
//       "totalPages": totalPages,
//       "sessions": sessions?.map((e) => e.toJson()).toList(),
//     };
//   }
// }



// class Session {
//   final String? sessionId;
//   final String? status;

//   final DateTime? startDateTime;
//   final DateTime? endDateTime;

//   final double? totalEnergyKwh;
//   final double? totalCost;
//   final double? totalPayable;

//   final String? currency;

//   final int? durationMinutes;

//   final String? ocpiLocationId;
//   final String? locationName;
//   final String? locationCity;

//   final int? partnerCredentialId;
//   final String? partnerName;

//   final String? evseUid;
//   final String? connectorId;

//   final String? userId;
//   final String? userName;
//   final String? userEmail;
//   final String? userPhone;

//   final String? invoiceNumber;

//     final dynamic? soCStart;
//       final dynamic? soCEnd;
//         final dynamic? soCCurrent;



//   Session({
//     this.sessionId,
//     this.status,
//     this.startDateTime,
//     this.endDateTime,
//     this.totalEnergyKwh,
//     this.totalCost,
//     this.totalPayable,
//     this.currency,
//     this.durationMinutes,
//     this.ocpiLocationId,
//     this.locationName,
//     this.locationCity,
//     this.partnerCredentialId,
//     this.partnerName,
//     this.evseUid,
//     this.connectorId,
//     this.userId,
//     this.userName,
//     this.userEmail,
//     this.userPhone,
//     this.invoiceNumber,
//     this.soCStart,
//     this.soCEnd,
//     this.soCCurrent
//   });



//   factory Session.fromJson(Map<String, dynamic> json) {
//     return Session(

//       sessionId: json['sessionId'],

//       status: json['status'],

//       startDateTime: json['startDateTime'] != null
//           ? DateTime.tryParse(json['startDateTime'])
//           : null,

//       endDateTime: json['endDateTime'] != null
//           ? DateTime.tryParse(json['endDateTime'])
//           : null,


//       totalEnergyKwh:
//           (json['totalEnergyKwh'] as num?)?.toDouble(),

//       totalCost:
//           (json['totalCost'] as num?)?.toDouble(),

//       totalPayable:
//           (json['totalPayable'] as num?)?.toDouble(),


//       currency: json['currency'],

//       durationMinutes: json['durationMinutes'],


//       ocpiLocationId: json['ocpiLocationId'],

//       locationName: json['locationName'],

//       locationCity: json['locationCity'],


//       partnerCredentialId:
//           json['partnerCredentialId'],

//       partnerName:
//           json['partnerName'],


//       evseUid:
//           json['evseUid'],

//       connectorId:
//           json['connectorId'],


//       userId:
//           json['userId'],

//       userName:
//           json['userName'],

//       userEmail:
//           json['userEmail'],

//       userPhone:
//           json['userPhone'],

// soCStart:json['soCStart'],
// soCEnd:json['soCEnd'],
// soCCurrent:json['soCCurrent'],
//       invoiceNumber:
//           json['invoiceNumber'],
//     );
//   }



//   Map<String, dynamic> toJson() {
//     return {

//       "sessionId": sessionId,

//       "status": status,

//       "startDateTime":
//           startDateTime?.toIso8601String(),

//       "endDateTime":
//           endDateTime?.toIso8601String(),


//       "totalEnergyKwh":
//           totalEnergyKwh,

//       "totalCost":
//           totalCost,

//       "totalPayable":
//           totalPayable,


//       "currency":
//           currency,


//       "durationMinutes":
//           durationMinutes,


//       "ocpiLocationId":
//           ocpiLocationId,

//       "locationName":
//           locationName,

//       "locationCity":
//           locationCity,


//       "partnerCredentialId":
//           partnerCredentialId,

//       "partnerName":
//           partnerName,


//       "evseUid":
//           evseUid,

//       "connectorId":
//           connectorId,


//       "userId":
//           userId,

//       "userName":
//           userName,

//       "userEmail":
//           userEmail,

//       "userPhone":
//           userPhone,
// "soCEnd":soCEnd,
// "soCStart":soCStart,
// "soCCurrent":soCCurrent,
//       "invoiceNumber":
//           invoiceNumber,
//     };
//   }
// }
class UnifiedActiveSessionResponse {
  bool? success;
  UnifiedActiveSessionData? data;

  UnifiedActiveSessionResponse({
    this.success,
    this.data,
  });

  factory UnifiedActiveSessionResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return UnifiedActiveSessionResponse();
    }

    return UnifiedActiveSessionResponse(
      success: json['success'] as bool?,
      data: json['data'] != null
          ? UnifiedActiveSessionData.fromJson(
              json['data'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
    };
  }
}

class UnifiedActiveSessionData {
  int? totalCount;
  int? page;
  int? pageSize;
  int? totalPages;
  List<Session> sessions;
  SessionSummary? summary;

  UnifiedActiveSessionData({
    this.totalCount,
    this.page,
    this.pageSize,
    this.totalPages,
    List<Session>? sessions,
    this.summary,
  }) : sessions = sessions ?? [];

  factory UnifiedActiveSessionData.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return UnifiedActiveSessionData();
    }

    return UnifiedActiveSessionData(
      totalCount: _toInt(json['totalCount']),
      page: _toInt(json['page']),
      pageSize: _toInt(json['pageSize']),
      totalPages: _toInt(json['totalPages']),
      sessions: json['sessions'] is List
          ? (json['sessions'] as List)
              .whereType<Map<String, dynamic>>()
              .map((e) => Session.fromJson(e))
              .toList()
          : [],
      summary: json['summary'] is Map<String, dynamic>
          ? SessionSummary.fromJson(
              json['summary'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalCount': totalCount,
      'page': page,
      'pageSize': pageSize,
      'totalPages': totalPages,
      'sessions': sessions.map((e) => e.toJson()).toList(),
      'summary': summary?.toJson(),
    };
  }
}

class Session {
  String? sessionId;
  String? status;
  DateTime? startDateTime;
  DateTime? endDateTime;

  double? totalEnergyKwh;
  double? totalCost;
  double? totalPayable;

  String? currency;
  int? durationMinutes;

  String? ocpiLocationId;
  String? locationName;
  String? locationCity;

  int? partnerCredentialId;
  String? partnerName;

  String? evseUid;
  String? connectorId;

  String? userId;
  String? userName;
  String? userEmail;
  String? userPhone;

  String? invoiceNumber;

  double? soCStart;
  double? soCEnd;
  double? soCCurrent;

  DateTime? soCLastUpdate;

  Session({
    this.sessionId,
    this.status,
    this.startDateTime,
    this.endDateTime,
    this.totalEnergyKwh,
    this.totalCost,
    this.totalPayable,
    this.currency,
    this.durationMinutes,
    this.ocpiLocationId,
    this.locationName,
    this.locationCity,
    this.partnerCredentialId,
    this.partnerName,
    this.evseUid,
    this.connectorId,
    this.userId,
    this.userName,
    this.userEmail,
    this.userPhone,
    this.invoiceNumber,
    this.soCStart,
    this.soCEnd,
    this.soCCurrent,
    this.soCLastUpdate,
  });

  factory Session.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Session();
    }

    return Session(
      sessionId: json['sessionId']?.toString(),
      status: json['status']?.toString(),

      startDateTime: _toDateTime(json['startDateTime']),
      endDateTime: _toDateTime(json['endDateTime']),

      totalEnergyKwh: _toDouble(json['totalEnergyKwh']),
      totalCost: _toDouble(json['totalCost']),
      totalPayable: _toDouble(json['totalPayable']),

      currency: json['currency']?.toString(),
      durationMinutes: _toInt(json['durationMinutes']),

      ocpiLocationId: json['ocpiLocationId']?.toString(),
      locationName: json['locationName']?.toString(),
      locationCity: json['locationCity']?.toString(),

      partnerCredentialId: _toInt(json['partnerCredentialId']),
      partnerName: json['partnerName']?.toString(),

      evseUid: json['evseUid']?.toString(),
      connectorId: json['connectorId']?.toString(),

      userId: json['userId']?.toString(),
      userName: json['userName']?.toString(),
      userEmail: json['userEmail']?.toString(),
      userPhone: json['userPhone']?.toString(),

      invoiceNumber: json['invoiceNumber']?.toString(),

      soCStart: _toDouble(json['soCStart']),
      soCEnd: _toDouble(json['soCEnd']),
      soCCurrent: _toDouble(json['soCCurrent']),

      soCLastUpdate: _toDateTime(json['soCLastUpdate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'status': status,
      'startDateTime': startDateTime?.toIso8601String(),
      'endDateTime': endDateTime?.toIso8601String(),
      'totalEnergyKwh': totalEnergyKwh,
      'totalCost': totalCost,
      'totalPayable': totalPayable,
      'currency': currency,
      'durationMinutes': durationMinutes,
      'ocpiLocationId': ocpiLocationId,
      'locationName': locationName,
      'locationCity': locationCity,
      'partnerCredentialId': partnerCredentialId,
      'partnerName': partnerName,
      'evseUid': evseUid,
      'connectorId': connectorId,
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'userPhone': userPhone,
      'invoiceNumber': invoiceNumber,
      'soCStart': soCStart,
      'soCEnd': soCEnd,
      'soCCurrent': soCCurrent,
      'soCLastUpdate': soCLastUpdate?.toIso8601String(),
    };
  }
}

class SessionSummary {
  double? totalEnergyTransmitted;
  String? totalEnergyUnit;

  double? totalChargingTotalFee;
  String? totalFeeUnit;

  UnifiedChargingTime? totalChargingTime;

  int? activeSessions;
  int? completedSessions;

  SessionSummary({
    this.totalEnergyTransmitted,
    this.totalEnergyUnit,
    this.totalChargingTotalFee,
    this.totalFeeUnit,
    this.totalChargingTime,
    this.activeSessions,
    this.completedSessions,
  });

  factory SessionSummary.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return SessionSummary();
    }

    return SessionSummary(
      totalEnergyTransmitted: _toDouble(
        json['totalEnergyTransmitted'],
      ),
      totalEnergyUnit: json['totalEnergyUnit']?.toString(),

      totalChargingTotalFee: _toDouble(
        json['totalChargingTotalFee'],
      ),
      totalFeeUnit: json['totalFeeUnit']?.toString(),

      totalChargingTime: json['totalChargingTime'] is Map<String, dynamic>
          ? UnifiedChargingTime.fromJson(
              json['totalChargingTime'] as Map<String, dynamic>,
            )
          : null,

      activeSessions: _toInt(json['activeSessions']),
      completedSessions: _toInt(json['completedSessions']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalEnergyTransmitted': totalEnergyTransmitted,
      'totalEnergyUnit': totalEnergyUnit,
      'totalChargingTotalFee': totalChargingTotalFee,
      'totalFeeUnit': totalFeeUnit,
      'totalChargingTime': totalChargingTime?.toJson(),
      'activeSessions': activeSessions,
      'completedSessions': completedSessions,
    };
  }
}

class UnifiedChargingTime {
  double? totalHours;
  int? totalMinutes;
  String? formattedDuration;

  UnifiedChargingTime({
    this.totalHours,
    this.totalMinutes,
    this.formattedDuration,
  });

  factory UnifiedChargingTime.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return UnifiedChargingTime();
    }

    return UnifiedChargingTime(
      totalHours: _toDouble(json['totalHours']),
      totalMinutes: _toInt(json['totalMinutes']),
      formattedDuration: json['formattedDuration']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalHours': totalHours,
      'totalMinutes': totalMinutes,
      'formattedDuration': formattedDuration,
    };
  }
}


// -------------------------
// Null-safe helper methods
// -------------------------

double? _toDouble(dynamic value) {
  if (value == null) return null;

  if (value is double) return value;
  if (value is int) return value.toDouble();

  return double.tryParse(value.toString());
}

int? _toInt(dynamic value) {
  if (value == null) return null;

  if (value is int) return value;
  if (value is double) return value.toInt();

  return int.tryParse(value.toString());
}

DateTime? _toDateTime(dynamic value) {
  if (value == null) return null;

  final stringValue = value.toString();

  if (stringValue.isEmpty) return null;

  return DateTime.tryParse(stringValue);
}