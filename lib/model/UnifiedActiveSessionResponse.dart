// class UnifiedActiveSessionResponse {
//   final bool? success;
//   final dynamic? message;
//   final List<UnifiedSession>? sessions;
//   final dynamic? totalCount;
//   final dynamic? page;
//   final dynamic? pageSize;
//   final dynamic? totalPages;

//   UnifiedActiveSessionResponse({
//     this.success,
//     this.message,
//     this.sessions,
//     this.totalCount,
//     this.page,
//     this.pageSize,
//     this.totalPages,
//   });

//   factory UnifiedActiveSessionResponse.fromJson(Map<String, dynamic> json) {
//     return UnifiedActiveSessionResponse(
//       success: json['success'] as bool?,
//       message: json['message'] as dynamic?,
//       sessions: (json['sessions'] as List?)
//           ?.map((e) => UnifiedSession.fromJson(e as Map<String, dynamic>))
//           .toList(),
//       totalCount: json['totalCount'] as dynamic?,
//       page: json['page'] as dynamic?,
//       pageSize: json['pageSize'] as dynamic?,
//       totalPages: json['totalPages'] as dynamic?,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "success": success,
//         "message": message,
//         "sessions": sessions?.map((e) => e.toJson()).toList(),
//         "totalCount": totalCount,
//         "page": page,
//         "pageSize": pageSize,
//         "totalPages": totalPages,
//       };
// }

// class UnifiedSession {
//   final dynamic? id;
//   final dynamic? providerType;
//   final dynamic? status;
//   final bool? isActive;
//   final DateTime? startTime;
//   final DateTime? endTime;
//   final dynamic? meterStart;
//   final dynamic? meterCurrent;
//   final dynamic? energyDelivered;
//   final dynamic? cost;
//   final dynamic? currency;
//   final dynamic? locationName;
//   final dynamic? partnerName;
//   final dynamic? stationId;
//   final dynamic? connectorId;
//   final dynamic? energyLimit;
//   final dynamic? costLimit;
//   final dynamic? timeLimit;
//   final dynamic? batteryIncreaseLimit;
//   final dynamic? limitProgress;
//   final BatteryStateOfCharge? batteryStateOfCharge;
//   final dynamic walletTransaction;

//   /// Keep raw dynamic because Local & Partner have different structures
//   final Map<String, dynamic>? raw;

//   UnifiedSession({
//     this.id,
//     this.providerType,
//     this.status,
//     this.isActive,
//     this.startTime,
//     this.endTime,
//     this.meterStart,
//     this.meterCurrent,
//     this.energyDelivered,
//     this.cost,
//     this.currency,
//     this.locationName,
//     this.partnerName,
//     this.stationId,
//     this.connectorId,
//     this.energyLimit,
//     this.costLimit,
//     this.timeLimit,
//     this.batteryIncreaseLimit,
//     this.limitProgress,
//     this.batteryStateOfCharge,
//     this.walletTransaction,
//     this.raw,
//   });

//   factory UnifiedSession.fromJson(Map<String, dynamic> json) {
//     return UnifiedSession(
//       id: json["id"] as dynamic?,
//       providerType: json["providerType"] as dynamic?,
//       status: json["status"] as dynamic?,
//       isActive: json["isActive"] as bool?,
//       startTime: json["startTime"] != null
//           ? DateTime.tryParse(json["startTime"])
//           : null,
//       endTime:
//           json["endTime"] != null ? DateTime.tryParse(json["endTime"]) : null,
//       meterStart: (json["meterStart"]).toString(),
//       meterCurrent: (json["meterCurrent"])?.toString(),
//       energyDelivered: (json["energyDelivered"])?.toString(),
//       cost: (json["cost"])?.toString(),
//       currency: json["currency"] as dynamic?,
//       locationName: json["locationName"] as dynamic?,
//       partnerName: json["partnerName"] as dynamic?,
//       stationId: json["stationId"] as dynamic?,
//       connectorId: json["connectorId"] as dynamic?,
//       energyLimit: (json["energyLimit"])?.toString(),
//       costLimit: (json["costLimit"])?.toString(),
//       timeLimit: (json["timeLimit"] )?.toString(),
//       batteryIncreaseLimit:
//           (json["batteryIncreaseLimit"])?.toString(),
//       limitProgress: (json["limitProgress"])?.toString(),
//       batteryStateOfCharge: json["batteryStateOfCharge"] != null
//           ? BatteryStateOfCharge.fromJson(
//               json["batteryStateOfCharge"] as Map<String, dynamic>)
//           : null,
//       walletTransaction: json["walletTransaction"],
//       raw: json["raw"] as Map<String, dynamic>?,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "providerType": providerType,
//         "status": status,
//         "isActive": isActive,
//         "startTime": startTime?.toString(),
//         "endTime": endTime?.toString(),
//         "meterStart": meterStart,
//         "meterCurrent": meterCurrent,
//         "energyDelivered": energyDelivered,
//         "cost": cost,
//         "currency": currency,
//         "locationName": locationName,
//         "partnerName": partnerName,
//         "stationId": stationId,
//         "connectorId": connectorId,
//         "energyLimit": energyLimit,
//         "costLimit": costLimit,
//         "timeLimit": timeLimit,
//         "batteryIncreaseLimit": batteryIncreaseLimit,
//         "limitProgress": limitProgress,
//         "batteryStateOfCharge": batteryStateOfCharge?.toJson(),
//         "walletTransaction": walletTransaction,
//         "raw": raw,
//       };
// }

// class BatteryStateOfCharge {
//   final dynamic? startSoC;
//   final dynamic? endSoC;
//   final dynamic? currentSoC;
//   final dynamic? soCGain;
//   final DateTime? lastUpdate;
//   final dynamic? unit;
//   final bool? isRealtime;
//   final dynamic? dataSource;

//   BatteryStateOfCharge({
//     this.startSoC,
//     this.endSoC,
//     this.currentSoC,
//     this.soCGain,
//     this.lastUpdate,
//     this.unit,
//     this.isRealtime,
//     this.dataSource,
//   });

//   factory BatteryStateOfCharge.fromJson(Map<String, dynamic> json) {
//     return BatteryStateOfCharge(
//       startSoC: json["startSoC"] as dynamic?,
//       endSoC: json["endSoC"] as dynamic?,
//       currentSoC: json["currentSoC"] as dynamic?,
//       soCGain: json["soCGain"] as dynamic?,
//       lastUpdate: json["lastUpdate"] != null
//           ? DateTime.tryParse(json["lastUpdate"])
//           : null,
//       unit: json["unit"] as dynamic?,
//       isRealtime: json["isRealtime"] as bool?,
//       dataSource: json["dataSource"] as dynamic?,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "startSoC": startSoC,
//         "endSoC": endSoC,
//         "currentSoC": currentSoC,
//         "soCGain": soCGain,
//         "lastUpdate": lastUpdate?.toString(),
//         "unit": unit,
//         "isRealtime": isRealtime,
//         "dataSource": dataSource,
//       };
// }
class UnifiedActiveSessionResponse {
  final bool? success;
  final SessionData? data;

  UnifiedActiveSessionResponse({
    this.success,
    this.data,
  });

  factory UnifiedActiveSessionResponse.fromJson(Map<String, dynamic> json) {
    return UnifiedActiveSessionResponse(
      success: json['success'],
      data: json['data'] != null
          ? SessionData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "data": data?.toJson(),
    };
  }
}


class SessionData {
  final int? totalCount;
  final int? page;
  final int? pageSize;
  final int? totalPages;
  final List<Session>? sessions;

  SessionData({
    this.totalCount,
    this.page,
    this.pageSize,
    this.totalPages,
    this.sessions,
  });


  factory SessionData.fromJson(Map<String, dynamic> json) {
    return SessionData(
      totalCount: json['totalCount'],
      page: json['page'],
      pageSize: json['pageSize'],
      totalPages: json['totalPages'],

      sessions: json['sessions'] != null
          ? List<Session>.from(
              json['sessions']
                  .map((x) => Session.fromJson(x)),
            )
          : [],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      "totalCount": totalCount,
      "page": page,
      "pageSize": pageSize,
      "totalPages": totalPages,
      "sessions": sessions?.map((e) => e.toJson()).toList(),
    };
  }
}



class Session {
  final String? sessionId;
  final String? status;

  final DateTime? startDateTime;
  final DateTime? endDateTime;

  final double? totalEnergyKwh;
  final double? totalCost;
  final double? totalPayable;

  final String? currency;

  final int? durationMinutes;

  final String? ocpiLocationId;
  final String? locationName;
  final String? locationCity;

  final int? partnerCredentialId;
  final String? partnerName;

  final String? evseUid;
  final String? connectorId;

  final String? userId;
  final String? userName;
  final String? userEmail;
  final String? userPhone;

  final String? invoiceNumber;


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
  });



  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(

      sessionId: json['sessionId'],

      status: json['status'],

      startDateTime: json['startDateTime'] != null
          ? DateTime.tryParse(json['startDateTime'])
          : null,

      endDateTime: json['endDateTime'] != null
          ? DateTime.tryParse(json['endDateTime'])
          : null,


      totalEnergyKwh:
          (json['totalEnergyKwh'] as num?)?.toDouble(),

      totalCost:
          (json['totalCost'] as num?)?.toDouble(),

      totalPayable:
          (json['totalPayable'] as num?)?.toDouble(),


      currency: json['currency'],

      durationMinutes: json['durationMinutes'],


      ocpiLocationId: json['ocpiLocationId'],

      locationName: json['locationName'],

      locationCity: json['locationCity'],


      partnerCredentialId:
          json['partnerCredentialId'],

      partnerName:
          json['partnerName'],


      evseUid:
          json['evseUid'],

      connectorId:
          json['connectorId'],


      userId:
          json['userId'],

      userName:
          json['userName'],

      userEmail:
          json['userEmail'],

      userPhone:
          json['userPhone'],


      invoiceNumber:
          json['invoiceNumber'],
    );
  }



  Map<String, dynamic> toJson() {
    return {

      "sessionId": sessionId,

      "status": status,

      "startDateTime":
          startDateTime?.toIso8601String(),

      "endDateTime":
          endDateTime?.toIso8601String(),


      "totalEnergyKwh":
          totalEnergyKwh,

      "totalCost":
          totalCost,

      "totalPayable":
          totalPayable,


      "currency":
          currency,


      "durationMinutes":
          durationMinutes,


      "ocpiLocationId":
          ocpiLocationId,

      "locationName":
          locationName,

      "locationCity":
          locationCity,


      "partnerCredentialId":
          partnerCredentialId,

      "partnerName":
          partnerName,


      "evseUid":
          evseUid,

      "connectorId":
          connectorId,


      "userId":
          userId,

      "userName":
          userName,

      "userEmail":
          userEmail,

      "userPhone":
          userPhone,


      "invoiceNumber":
          invoiceNumber,
    };
  }
}