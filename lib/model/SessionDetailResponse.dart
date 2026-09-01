class SessionDetailResponse {
  bool success;
  String message;
  SessionDetailData? data;

  SessionDetailResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory SessionDetailResponse.fromJson(Map<String, dynamic> json) {
    return SessionDetailResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] != null
          ? SessionDetailData.fromJson(json["data"])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class SessionDetailData {
  dynamic id;
  dynamic providerType;
  dynamic status;
  bool isActive;
  dynamic? startTime;
  dynamic? endTime;
  dynamic? meterStart;
  dynamic? meterCurrent;
  dynamic energyDelivered;
  dynamic cost;
  dynamic currency;
  dynamic? locationName;
  dynamic? partnerName;
  dynamic? stationId;
  dynamic? connectorId;
  dynamic? energyLimit;
  dynamic? costLimit;
  dynamic? timeLimit;
  dynamic? batteryIncreaseLimit;
  LimitProgress? limitProgress;
  BatteryStateOfCharge? batteryStateOfCharge;
  dynamic walletTransaction;
  SessionRaw? raw;

  SessionDetailData({
    required this.id,
    required this.providerType,
    required this.status,
    required this.isActive,
    this.startTime,
    this.endTime,
    this.meterStart,
    this.meterCurrent,
    required this.energyDelivered,
    required this.cost,
    required this.currency,
    this.locationName,
    this.partnerName,
    this.stationId,
    this.connectorId,
    this.energyLimit,
    this.costLimit,
    this.timeLimit,
    this.batteryIncreaseLimit,
    this.limitProgress,
    this.batteryStateOfCharge,
    this.walletTransaction,
    this.raw,
  });

  factory SessionDetailData.fromJson(Map<String, dynamic> json) {
    return SessionDetailData(
      id: json["id"] ?? "",
      providerType: json["providerType"] ?? 0,
      status: json["status"] ?? "",
      isActive: json["isActive"] ?? false,
      startTime: json["startTime"],
      endTime: json["endTime"],
      meterStart: json["meterStart"] != null
          ? (json["meterStart"]).toString()
          : null,
      meterCurrent: json["meterCurrent"] != null
          ? (json["meterCurrent"]).toString()
          : null,
      energyDelivered: (json["energyDelivered"] ?? "0").toString(),
      cost: (json["cost"] ?? "0").toString(),
      currency: json["currency"] ?? "",
      locationName: json["locationName"],
      partnerName: json["partnerName"],
      stationId: json["stationId"],
      connectorId: json["connectorId"],
      energyLimit: json["energyLimit"] != null
          ? (json["energyLimit"]).toString()
          : null,
      costLimit: json["costLimit"] != null
          ? (json["costLimit"]).toString()
          : null,
      timeLimit: json["timeLimit"] != null
          ? (json["timeLimit"]).toString()
          : null,
      batteryIncreaseLimit: json["batteryIncreaseLimit"] != null
          ? (json["batteryIncreaseLimit"]).toString()
          : null,
      limitProgress: json["limitProgress"] != null
          ? LimitProgress.fromJson(json["limitProgress"])
          : null,
      batteryStateOfCharge: json["batteryStateOfCharge"] != null
          ? BatteryStateOfCharge.fromJson(json["batteryStateOfCharge"])
          : null,
      walletTransaction: json["walletTransaction"],
      raw: json["raw"] != null
          ? SessionRaw.fromJson(json["raw"])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "providerType": providerType,
        "status": status,
        "isActive": isActive,
        "startTime": startTime,
        "endTime": endTime,
        "meterStart": meterStart,
        "meterCurrent": meterCurrent,
        "energyDelivered": energyDelivered,
        "cost": cost,
        "currency": currency,
        "locationName": locationName,
        "partnerName": partnerName,
        "stationId": stationId,
        "connectorId": connectorId,
        "energyLimit": energyLimit,
        "costLimit": costLimit,
        "timeLimit": timeLimit,
        "batteryIncreaseLimit": batteryIncreaseLimit,
        "limitProgress": limitProgress?.toJson(),
        "batteryStateOfCharge": batteryStateOfCharge?.toJson(),
        "walletTransaction": walletTransaction,
        "raw": raw?.toJson(),
      };
}

class LimitProgress {
  dynamic? energyPct;
  dynamic? costPct;
  dynamic? timePct;

  LimitProgress({
    this.energyPct,
    this.costPct,
    this.timePct,
  });

  factory LimitProgress.fromJson(Map<String, dynamic> json) {
    return LimitProgress(
      energyPct: json["energyPct"] != null
          ? (json["energyPct"]).toString()
          : null,
      costPct: json["costPct"] != null
          ? (json["costPct"]).toString()
          : null,
      timePct: json["timePct"] != null
          ? (json["timePct"]).toString()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "energyPct": energyPct,
        "costPct": costPct,
        "timePct": timePct,
      };
}

class BatteryStateOfCharge {
  dynamic? startSoC;
  dynamic? endSoC;
  dynamic? currentSoC;
  dynamic? soCGain;
  dynamic? lastUpdate;
  dynamic unit;
  bool isRealtime;
  dynamic dataSource;

  BatteryStateOfCharge({
    this.startSoC,
    this.endSoC,
    this.currentSoC,
    this.soCGain,
    this.lastUpdate,
    required this.unit,
    required this.isRealtime,
    required this.dataSource,
  });

  factory BatteryStateOfCharge.fromJson(Map<String, dynamic> json) {
    return BatteryStateOfCharge(
      startSoC: json["startSoC"],
      endSoC: json["endSoC"],
      currentSoC: json["currentSoC"],
      soCGain: json["soCGain"],
      lastUpdate: json["lastUpdate"],
      unit: json["unit"] ?? "%",
      isRealtime: json["isRealtime"] ?? false,
      dataSource: json["dataSource"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "startSoC": startSoC,
        "endSoC": endSoC,
        "currentSoC": currentSoC,
        "soCGain": soCGain,
        "lastUpdate": lastUpdate,
        "unit": unit,
        "isRealtime": isRealtime,
        "dataSource": dataSource,
      };
}

class SessionRaw {
  dynamic sessionId;
  dynamic status;
  dynamic? startDateTime;
  dynamic? endDateTime;
  dynamic? totalEnergyKwh;
  dynamic? totalCost;
  dynamic? totalPayable;
  dynamic currency;
  dynamic durationMinutes;
  dynamic? currentStateOfCharge;
  dynamic? stateOfChargeLastUpdate;
  dynamic? ocpiLocationId;
  dynamic? locationName;
  dynamic? locationAddress;
  dynamic? locationCity;
  dynamic? partnerName;
  dynamic? evseUid;
  dynamic? connectorId;
  dynamic? energyLimit;
  dynamic? costLimit;
  dynamic? timeLimit;
  dynamic? batteryIncreaseLimit;
  bool limitViolationHandled;
  LimitProgress? limitProgress;

  SessionRaw({
    required this.sessionId,
    required this.status,
    this.startDateTime,
    this.endDateTime,
    this.totalEnergyKwh,
    this.totalCost,
    this.totalPayable,
    required this.currency,
    required this.durationMinutes,
    this.currentStateOfCharge,
    this.stateOfChargeLastUpdate,
    this.ocpiLocationId,
    this.locationName,
    this.locationAddress,
    this.locationCity,
    this.partnerName,
    this.evseUid,
    this.connectorId,
    this.energyLimit,
    this.costLimit,
    this.timeLimit,
    this.batteryIncreaseLimit,
    required this.limitViolationHandled,
    this.limitProgress,
  });

  factory SessionRaw.fromJson(Map<String, dynamic> json) {
    return SessionRaw(
      sessionId: json["sessionId"] ?? "",
      status: json["status"] ?? "",
      startDateTime: json["startDateTime"],
      endDateTime: json["endDateTime"],
      totalEnergyKwh: json["totalEnergyKwh"] != null
          ? (json["totalEnergyKwh"]).toString()
          : null,
      totalCost: json["totalCost"] != null
          ? (json["totalCost"]).toString()
          : null,
      totalPayable: json["totalPayable"] != null
          ? (json["totalPayable"]).toString()
          : null,
      currency: json["currency"] ?? "",
      durationMinutes: json["durationMinutes"] ?? 0,
      currentStateOfCharge: json["currentStateOfCharge"],
      stateOfChargeLastUpdate: json["stateOfChargeLastUpdate"],
      ocpiLocationId: json["ocpiLocationId"],
      locationName: json["locationName"],
      locationAddress: json["locationAddress"],
      locationCity: json["locationCity"],
      partnerName: json["partnerName"],
      evseUid: json["evseUid"],
      connectorId: json["connectorId"],
      energyLimit: json["energyLimit"] != null
          ? (json["energyLimit"]).toString()
          : null,
      costLimit: json["costLimit"] != null
          ? (json["costLimit"]).toString()
          : null,
      timeLimit: json["timeLimit"] != null
          ? (json["timeLimit"]).toString()
          : null,
      batteryIncreaseLimit: json["batteryIncreaseLimit"] != null
          ? (json["batteryIncreaseLimit"]).toString()
          : null,
      limitViolationHandled: json["limitViolationHandled"] ?? false,
      limitProgress: json["limitProgress"] != null
          ? LimitProgress.fromJson(json["limitProgress"])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "sessionId": sessionId,
        "status": status,
        "startDateTime": startDateTime,
        "endDateTime": endDateTime,
        "totalEnergyKwh": totalEnergyKwh,
        "totalCost": totalCost,
        "totalPayable": totalPayable,
        "currency": currency,
        "durationMinutes": durationMinutes,
        "currentStateOfCharge": currentStateOfCharge,
        "stateOfChargeLastUpdate": stateOfChargeLastUpdate,
        "ocpiLocationId": ocpiLocationId,
        "locationName": locationName,
        "locationAddress": locationAddress,
        "locationCity": locationCity,
        "partnerName": partnerName,
        "evseUid": evseUid,
        "connectorId": connectorId,
        "energyLimit": energyLimit,
        "costLimit": costLimit,
        "timeLimit": timeLimit,
        "batteryIncreaseLimit": batteryIncreaseLimit,
        "limitViolationHandled": limitViolationHandled,
        "limitProgress": limitProgress?.toJson(),
      };
}


// import 'package:HyCharge/model/StartChargingSessionResponse.dart';

// class SessionDetailResponse {
//   final bool success;
//   final String? message;
//   final SessionDetailData? data;

//   SessionDetailResponse({
//     required this.success,
//     this.message,
//     this.data,
//   });

//   factory SessionDetailResponse.fromJson(Map<String, dynamic> json) {
//     return SessionDetailResponse(
//       success: json['success'] ?? false,
//       message: json['message'],
//       data: json['data'] != null
//           ? SessionDetailData.fromJson(json['data'])
//           : null,
//     );
//   }
// }
// class SessionDetailData {
//   final ChargingSession? session;
//   final int? transactionId;
//   final String? status;
//   final bool? isActive;

//   final MeterReadings? meterReadings;
//   final EnergyConsumption? energyConsumption;
//   final ChargingPerformance? chargingPerformance;
//   final ChargerDetails? chargerDetails;
//   final CostDetails? costDetails;
//   final Timing? timing;
//   final Summary? summary;
//   final BatteryStateOfCharge? batteryStateOfCharge;

//   SessionDetailData({
//     this.session,
//     this.transactionId,
//     this.status,
//     this.isActive,
//     this.meterReadings,
//     this.energyConsumption,
//     this.chargingPerformance,
//     this.chargerDetails,
//     this.costDetails,
//     this.timing,
//     this.summary,
//     this.batteryStateOfCharge,
//   });

//   factory SessionDetailData.fromJson(Map<String, dynamic> json) {
//     return SessionDetailData(
//       session: json['session'] != null
//           ? ChargingSession.fromJson(json['session'])
//           : null,
//       transactionId: json['transactionId'],
//       status: json['status'],
//       isActive: json['isActive'],
//       meterReadings: json['meterReadings'] != null
//           ? MeterReadings.fromJson(json['meterReadings'])
//           : null,
//       energyConsumption: json['energyConsumption'] != null
//           ? EnergyConsumption.fromJson(json['energyConsumption'])
//           : null,
//       chargingPerformance: json['chargingPerformance'] != null
//           ? ChargingPerformance.fromJson(json['chargingPerformance'])
//           : null,
//       chargerDetails: json['chargerDetails'] != null
//           ? ChargerDetails.fromJson(json['chargerDetails'])
//           : null,
//       costDetails: json['costDetails'] != null
//           ? CostDetails.fromJson(json['costDetails'])
//           : null,
//       timing: json['timing'] != null
//           ? Timing.fromJson(json['timing'])
//           : null,
//       summary: json['summary'] != null
//           ? Summary.fromJson(json['summary'])
//           : null,
//       batteryStateOfCharge: json['batteryStateOfCharge'] != null
//           ? BatteryStateOfCharge.fromJson(json['batteryStateOfCharge'])
//           : null,
//     );
//   }
// }
// double? _toDouble(dynamic value) {
//   if (value == null) return null;
//   if (value is num) return value.toDouble();
//   return double.tryParse(value.toString());
// }
// class MeterReadings {
//   final double? startReading;
//   final double? currentReading;
//   final String? unit;
//   final String? dataSource;
//   final bool? isRealtime;

//   MeterReadings({
//     this.startReading,
//     this.currentReading,
//     this.unit,
//     this.dataSource,
//     this.isRealtime,
//   });

//   factory MeterReadings.fromJson(Map<String, dynamic> json) {
//     return MeterReadings(
//       startReading: _toDouble(json['startReading']),
//       currentReading: _toDouble(json['currentReading']),
//       unit: json['unit'],
//       dataSource: json['dataSource'],
//       isRealtime: json['isRealtime'],
//     );
//   }
// }
// class EnergyConsumption {
//   final double? totalEnergy;
//   final String? unit;
//   final String? description;

//   EnergyConsumption({
//     this.totalEnergy,
//     this.unit,
//     this.description,
//   });

//   factory EnergyConsumption.fromJson(Map<String, dynamic> json) {
//     return EnergyConsumption(
//       totalEnergy: _toDouble(json['totalEnergy']),
//       unit: json['unit'],
//       description: json['description'],
//     );
//   }
// }
// class ChargingPerformance {
//   final double? averageChargingSpeed;
//   final double? peakChargingSpeed;
//   final String? unit;
//   final double? chargingEfficiency;
//   final String? efficiencyUnit;
//   final String? description;

//   ChargingPerformance({
//     this.averageChargingSpeed,
//     this.peakChargingSpeed,
//     this.unit,
//     this.chargingEfficiency,
//     this.efficiencyUnit,
//     this.description,
//   });

//   factory ChargingPerformance.fromJson(Map<String, dynamic> json) {
//     return ChargingPerformance(
//       averageChargingSpeed: _toDouble(json['averageChargingSpeed']),
//       peakChargingSpeed: _toDouble(json['peakChargingSpeed']),
//       unit: json['unit'],
//       chargingEfficiency: _toDouble(json['chargingEfficiency']),
//       efficiencyUnit: json['efficiencyUnit'],
//       description: json['description'],
//     );
//   }
// }
// class ChargerDetails {
//   final String? chargerType;
//   final double? powerOutput;
//   final double? chargerTariff;
//   final String? tariffUnit;
//   final String? connectorId;
//   final String? chargerStatus;

//   ChargerDetails({
//     this.chargerType,
//     this.powerOutput,
//     this.chargerTariff,
//     this.tariffUnit,
//     this.connectorId,
//     this.chargerStatus,
//   });

//   factory ChargerDetails.fromJson(Map<String, dynamic> json) {
//     return ChargerDetails(
//       chargerType: json['chargerType'],
//       powerOutput: _toDouble(json['powerOutput']),
//       chargerTariff: _toDouble(json['chargerTariff']),
//       tariffUnit: json['tariffUnit'],
//       connectorId: json['connectorId'],
//       chargerStatus: json['chargerStatus'],
//     );
//   }
// }
// // class CostDetails {
// //   final double? energyCost;
// //   final double? serviceFee;
// //   final double? taxes;
// //   final double? totalCost;
// //   final String? currency;
// //   final double? tariffApplied;
// //   final String? tariffUnit;
// //   final String? breakdown;

// //   CostDetails({
// //     this.energyCost,
// //     this.serviceFee,
// //     this.taxes,
// //     this.totalCost,
// //     this.currency,
// //     this.tariffApplied,
// //     this.tariffUnit,
// //     this.breakdown,
// //   });

// //   factory CostDetails.fromJson(Map<String, dynamic> json) {
// //     return CostDetails(
// //       energyCost: _toDouble(json['energyCost']),
// //       serviceFee: _toDouble(json['serviceFee']),
// //       taxes: _toDouble(json['taxes']),
// //       totalCost: _toDouble(json['totalCost']),
// //       currency: json['currency'],
// //       tariffApplied: _toDouble(json['tariffApplied']),
// //       tariffUnit: json['tariffUnit'],
// //       breakdown: json['breakdown'],
// //     );
// //   }
// // }
// class CostDetails {
//   double? energyCost;
//   double? serviceFee;
//   double? taxes;
//   double? totalCost;
//   double? cgst;
//   double? sgst;
//   String? currency;
//   double? tariffApplied;
//   String? tariffUnit;
//   String? breakdown;

//   CostDetails({
//     this.energyCost,
//     this.serviceFee,
//     this.taxes,
//     this.totalCost,
//     this.cgst,
//     this.sgst,
//     this.currency,
//     this.tariffApplied,
//     this.tariffUnit,
//     this.breakdown,
//   });

//   factory CostDetails.fromJson(Map<String, dynamic> json) {
//     return CostDetails(
//       energyCost: (json['energyCost'] as num?)?.toDouble(),
//       serviceFee: (json['serviceFee'] as num?)?.toDouble(),
//       taxes: (json['taxes'] as num?)?.toDouble(),
//       totalCost: (json['totalCost'] as num?)?.toDouble(),
//       cgst: (json['cgst'] as num?)?.toDouble(),
//       sgst: (json['sgst'] as num?)?.toDouble(),
//       currency: json['currency'],
//       tariffApplied: (json['tariffApplied'] as num?)?.toDouble(),
//       tariffUnit: json['tariffUnit'],
//       breakdown: json['breakdown'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       "energyCost": energyCost,
//       "serviceFee": serviceFee,
//       "taxes": taxes,
//       "totalCost": totalCost,
//       "cgst": cgst,
//       "sgst": sgst,
//       "currency": currency,
//       "tariffApplied": tariffApplied,
//       "tariffUnit": tariffUnit,
//       "breakdown": breakdown,
//     };
//   }
// }
// class Timing {
//   final DateTime? startTime;
//   final DateTime? endTime;
//   final SessionDuration? duration;
//   final bool? isActive;
//   final DateTime? lastUpdate;

//   Timing({
//     this.startTime,
//     this.endTime,
//     this.duration,
//     this.isActive,
//     this.lastUpdate,
//   });

//   factory Timing.fromJson(Map<String, dynamic> json) {
//     return Timing(
//       startTime: DateTime.tryParse(json['startTime'] ?? ''),
//       endTime: DateTime.tryParse(json['endTime'] ?? ''),
//       duration: json['duration'] != null
//           ? SessionDuration.fromJson(json['duration'])
//           : null,
//       isActive: json['isActive'],
//       lastUpdate: DateTime.tryParse(json['lastUpdate'] ?? ''),
//     );
//   }
// }

// class SessionDuration {
//   final int? totalMinutes;
//   final int? hours;
//   final int? minutes;
//   final double? totalHours;
//   final String? formattedDuration;

//   SessionDuration({
//     this.totalMinutes,
//     this.hours,
//     this.minutes,
//     this.totalHours,
//     this.formattedDuration,
//   });

//   factory SessionDuration.fromJson(Map<String, dynamic> json) {
//     return SessionDuration(
//       totalMinutes: json['totalMinutes'],
//       hours: json['hours'],
//       minutes: json['minutes'],
//       totalHours: _toDouble(json['totalHours']),
//       formattedDuration: json['formattedDuration'],
//     );
//   }
// }
// class Summary {
//   final String? energyDelivered;
//   final String? socGained;
//   final String? rangeAdded;
//   final String? totalCost;
//   final String? chargingTime;
//   final String? averageSpeed;
//   final String? costPerKwh;

//   Summary({
//     this.energyDelivered,
//     this.socGained,
//     this.rangeAdded,
//     this.totalCost,
//     this.chargingTime,
//     this.averageSpeed,
//     this.costPerKwh,
//   });

//   factory Summary.fromJson(Map<String, dynamic> json) {
//     return Summary(
//       energyDelivered: json['energyDelivered'],
//       socGained: json['socGained'],
//       rangeAdded: json['rangeAdded'],
//       totalCost: json['totalCost'],
//       chargingTime: json['chargingTime'],
//       averageSpeed: json['averageSpeed'],
//       costPerKwh: json['costPerKwh'],
//     );
//   }
// }
