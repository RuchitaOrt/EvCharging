import 'package:HyCharge/model/StartChargingSessionResponse.dart';

class SessionDetailResponse {
  final bool success;
  final String? message;
  final SessionDetailData? data;

  SessionDetailResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory SessionDetailResponse.fromJson(Map<String, dynamic> json) {
    return SessionDetailResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'] != null
          ? SessionDetailData.fromJson(json['data'])
          : null,
    );
  }
}
class SessionDetailData {
  final ChargingSession? session;
  final int? transactionId;
  final String? status;
  final bool? isActive;

  final MeterReadings? meterReadings;
  final EnergyConsumption? energyConsumption;
  final ChargingPerformance? chargingPerformance;
  final ChargerDetails? chargerDetails;
  final CostDetails? costDetails;
  final Timing? timing;
  final Summary? summary;
  final BatteryStateOfCharge? batteryStateOfCharge;

  SessionDetailData({
    this.session,
    this.transactionId,
    this.status,
    this.isActive,
    this.meterReadings,
    this.energyConsumption,
    this.chargingPerformance,
    this.chargerDetails,
    this.costDetails,
    this.timing,
    this.summary,
    this.batteryStateOfCharge,
  });

  factory SessionDetailData.fromJson(Map<String, dynamic> json) {
    return SessionDetailData(
      session: json['session'] != null
          ? ChargingSession.fromJson(json['session'])
          : null,
      transactionId: json['transactionId'],
      status: json['status'],
      isActive: json['isActive'],
      meterReadings: json['meterReadings'] != null
          ? MeterReadings.fromJson(json['meterReadings'])
          : null,
      energyConsumption: json['energyConsumption'] != null
          ? EnergyConsumption.fromJson(json['energyConsumption'])
          : null,
      chargingPerformance: json['chargingPerformance'] != null
          ? ChargingPerformance.fromJson(json['chargingPerformance'])
          : null,
      chargerDetails: json['chargerDetails'] != null
          ? ChargerDetails.fromJson(json['chargerDetails'])
          : null,
      costDetails: json['costDetails'] != null
          ? CostDetails.fromJson(json['costDetails'])
          : null,
      timing: json['timing'] != null
          ? Timing.fromJson(json['timing'])
          : null,
      summary: json['summary'] != null
          ? Summary.fromJson(json['summary'])
          : null,
      batteryStateOfCharge: json['batteryStateOfCharge'] != null
          ? BatteryStateOfCharge.fromJson(json['batteryStateOfCharge'])
          : null,
    );
  }
}
double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}
class MeterReadings {
  final double? startReading;
  final double? currentReading;
  final String? unit;
  final String? dataSource;
  final bool? isRealtime;

  MeterReadings({
    this.startReading,
    this.currentReading,
    this.unit,
    this.dataSource,
    this.isRealtime,
  });

  factory MeterReadings.fromJson(Map<String, dynamic> json) {
    return MeterReadings(
      startReading: _toDouble(json['startReading']),
      currentReading: _toDouble(json['currentReading']),
      unit: json['unit'],
      dataSource: json['dataSource'],
      isRealtime: json['isRealtime'],
    );
  }
}
class EnergyConsumption {
  final double? totalEnergy;
  final String? unit;
  final String? description;

  EnergyConsumption({
    this.totalEnergy,
    this.unit,
    this.description,
  });

  factory EnergyConsumption.fromJson(Map<String, dynamic> json) {
    return EnergyConsumption(
      totalEnergy: _toDouble(json['totalEnergy']),
      unit: json['unit'],
      description: json['description'],
    );
  }
}
class ChargingPerformance {
  final double? averageChargingSpeed;
  final double? peakChargingSpeed;
  final String? unit;
  final double? chargingEfficiency;
  final String? efficiencyUnit;
  final String? description;

  ChargingPerformance({
    this.averageChargingSpeed,
    this.peakChargingSpeed,
    this.unit,
    this.chargingEfficiency,
    this.efficiencyUnit,
    this.description,
  });

  factory ChargingPerformance.fromJson(Map<String, dynamic> json) {
    return ChargingPerformance(
      averageChargingSpeed: _toDouble(json['averageChargingSpeed']),
      peakChargingSpeed: _toDouble(json['peakChargingSpeed']),
      unit: json['unit'],
      chargingEfficiency: _toDouble(json['chargingEfficiency']),
      efficiencyUnit: json['efficiencyUnit'],
      description: json['description'],
    );
  }
}
class ChargerDetails {
  final String? chargerType;
  final double? powerOutput;
  final double? chargerTariff;
  final String? tariffUnit;
  final String? connectorId;
  final String? chargerStatus;

  ChargerDetails({
    this.chargerType,
    this.powerOutput,
    this.chargerTariff,
    this.tariffUnit,
    this.connectorId,
    this.chargerStatus,
  });

  factory ChargerDetails.fromJson(Map<String, dynamic> json) {
    return ChargerDetails(
      chargerType: json['chargerType'],
      powerOutput: _toDouble(json['powerOutput']),
      chargerTariff: _toDouble(json['chargerTariff']),
      tariffUnit: json['tariffUnit'],
      connectorId: json['connectorId'],
      chargerStatus: json['chargerStatus'],
    );
  }
}
class CostDetails {
  final double? energyCost;
  final double? serviceFee;
  final double? taxes;
  final double? totalCost;
  final String? currency;
  final double? tariffApplied;
  final String? tariffUnit;
  final String? breakdown;

  CostDetails({
    this.energyCost,
    this.serviceFee,
    this.taxes,
    this.totalCost,
    this.currency,
    this.tariffApplied,
    this.tariffUnit,
    this.breakdown,
  });

  factory CostDetails.fromJson(Map<String, dynamic> json) {
    return CostDetails(
      energyCost: _toDouble(json['energyCost']),
      serviceFee: _toDouble(json['serviceFee']),
      taxes: _toDouble(json['taxes']),
      totalCost: _toDouble(json['totalCost']),
      currency: json['currency'],
      tariffApplied: _toDouble(json['tariffApplied']),
      tariffUnit: json['tariffUnit'],
      breakdown: json['breakdown'],
    );
  }
}
class Timing {
  final DateTime? startTime;
  final DateTime? endTime;
  final SessionDuration? duration;
  final bool? isActive;
  final DateTime? lastUpdate;

  Timing({
    this.startTime,
    this.endTime,
    this.duration,
    this.isActive,
    this.lastUpdate,
  });

  factory Timing.fromJson(Map<String, dynamic> json) {
    return Timing(
      startTime: DateTime.tryParse(json['startTime'] ?? ''),
      endTime: DateTime.tryParse(json['endTime'] ?? ''),
      duration: json['duration'] != null
          ? SessionDuration.fromJson(json['duration'])
          : null,
      isActive: json['isActive'],
      lastUpdate: DateTime.tryParse(json['lastUpdate'] ?? ''),
    );
  }
}

class SessionDuration {
  final int? totalMinutes;
  final int? hours;
  final int? minutes;
  final double? totalHours;
  final String? formattedDuration;

  SessionDuration({
    this.totalMinutes,
    this.hours,
    this.minutes,
    this.totalHours,
    this.formattedDuration,
  });

  factory SessionDuration.fromJson(Map<String, dynamic> json) {
    return SessionDuration(
      totalMinutes: json['totalMinutes'],
      hours: json['hours'],
      minutes: json['minutes'],
      totalHours: _toDouble(json['totalHours']),
      formattedDuration: json['formattedDuration'],
    );
  }
}
class Summary {
  final String? energyDelivered;
  final String? socGained;
  final String? rangeAdded;
  final String? totalCost;
  final String? chargingTime;
  final String? averageSpeed;
  final String? costPerKwh;

  Summary({
    this.energyDelivered,
    this.socGained,
    this.rangeAdded,
    this.totalCost,
    this.chargingTime,
    this.averageSpeed,
    this.costPerKwh,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      energyDelivered: json['energyDelivered'],
      socGained: json['socGained'],
      rangeAdded: json['rangeAdded'],
      totalCost: json['totalCost'],
      chargingTime: json['chargingTime'],
      averageSpeed: json['averageSpeed'],
      costPerKwh: json['costPerKwh'],
    );
  }
}

// class SessionDetailResponse {
//   final bool success;
//   final String message;
//   final SessionDetailData? data;

//   SessionDetailResponse({
//     required this.success,
//     required this.message,
//     required this.data,
//   });

//   factory SessionDetailResponse.fromJson(Map<String, dynamic> json) {
//     return SessionDetailResponse(
//       success: json['success'] ?? false,
//       message: json['message'] ?? '',
//       data: json['data'] != null
//           ? SessionDetailData.fromJson(json['data'])
//           : null,
//     );
//   }
// }
// class SessionDetailData {
//   final ChargingSession session;
//   final dynamic transactionId;
//   final String status;
//   final bool isActive;
//   final MeterReadings meterReadings;
//   final EnergyConsumption energyConsumption;
//   final ChargingPerformance chargingPerformance;
//   final ChargerDetails chargerDetails;
//   final CostDetails costDetails;
//   final Timing timing;
//   final Summary summary;
//   final BatteryStateOfCharge batteryStateOfCharge;

//   SessionDetailData({
//     required this.session,
//     required this.transactionId,
//     required this.status,
//     required this.isActive,
//     required this.meterReadings,
//     required this.energyConsumption,
//     required this.chargingPerformance,
//     required this.chargerDetails,
//     required this.costDetails,
//     required this.timing,
//     required this.summary,
//     required this.batteryStateOfCharge,
//   });

//   factory SessionDetailData.fromJson(Map<String, dynamic> json) {
//     return SessionDetailData(
//       session: ChargingSession.fromJson(json['session'] ?? {}),
//       transactionId: json['transactionId'] ?? 0,
//       status: json['status'] ?? '',
//       isActive: json['isActive'] ?? false,
//       meterReadings: MeterReadings.fromJson(json['meterReadings'] ?? {}),
//       energyConsumption:
//           EnergyConsumption.fromJson(json['energyConsumption'] ?? {}),
//       chargingPerformance:
//           ChargingPerformance.fromJson(json['chargingPerformance'] ?? {}),
//       chargerDetails:
//           ChargerDetails.fromJson(json['chargerDetails'] ?? {}),
//       costDetails: CostDetails.fromJson(json['costDetails'] ?? {}),
//       timing: Timing.fromJson(json['timing'] ?? {}),
//       summary: Summary.fromJson(json['summary'] ?? {}),
//       batteryStateOfCharge:
//           BatteryStateOfCharge.fromJson(json['batteryStateOfCharge'] ?? {}),
//     );
//   }
// }
// class ChargingSession {
//   final String recId;
//   final String chargingGunId;
//   final String connectorName;
//   final String chargingStationId;
//   final String chargingStationName;
//   final String chargingHubName;
//   final String startMeterReading;
//   final String endMeterReading;
//   final String energyTransmitted;
//   final DateTime startTime;
//   final DateTime? endTime;
//   final String chargingSpeed;
//   final String chargingTariff;
//   final String chargingTotalFee;
//   final String status;
//   final String duration;
//   final dynamic active;

//   ChargingSession({
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
//   });

//   factory ChargingSession.fromJson(Map<String, dynamic> json) {
//     return ChargingSession(
//       recId: json['recId'] ?? '',
//       chargingGunId: json['chargingGunId'] ?? '',
//       connectorName: json['connectorName'] ?? '',
//       chargingStationId: json['chargingStationId'] ?? '',
//       chargingStationName: json['chargingStationName'] ?? '',
//       chargingHubName: json['chargingHubName'] ?? '',
//       startMeterReading: json['startMeterReading'] ?? '0',
//       endMeterReading: json['endMeterReading'] ?? '0',
//       energyTransmitted: json['energyTransmitted'] ?? '0',
//       startTime: DateTime.tryParse(json['startTime'] ?? '') ??
//           DateTime.fromMillisecondsSinceEpoch(0),
//       endTime: json['endTime'] != null
//           ? DateTime.tryParse(json['endTime'])
//           : null,
//       chargingSpeed: json['chargingSpeed'] ?? '0',
//       chargingTariff: json['chargingTariff'] ?? '0',
//       chargingTotalFee: json['chargingTotalFee'] ?? '0',
//       status: json['status'] ?? '',
//       duration: json['duration'] ?? '',
//       active: json['active'] ?? 0,
//     );
//   }
// }
// class MeterReadings {
//   final dynamic startReading;
//   final dynamic currentReading;
//   final String unit;
//   final String dataSource;
//   final bool isRealtime;

//   MeterReadings({
//     required this.startReading,
//     required this.currentReading,
//     required this.unit,
//     required this.dataSource,
//     required this.isRealtime,
//   });

//   factory MeterReadings.fromJson(Map<String, dynamic> json) {
//     return MeterReadings(
//       startReading: json['startReading'] ?? 0,
//       currentReading: json['currentReading'] ?? 0,
//       unit: json['unit'] ?? '',
//       dataSource: json['dataSource'] ?? '',
//       isRealtime: json['isRealtime'] ?? false,
//     );
//   }
// }
// class EnergyConsumption {
//   final dynamic totalEnergy;
//   final String unit;
//   final String description;

//   EnergyConsumption({
//     required this.totalEnergy,
//     required this.unit,
//     required this.description,
//   });

//   factory EnergyConsumption.fromJson(Map<String, dynamic> json) {
//     return EnergyConsumption(
//       totalEnergy: json['totalEnergy'] ?? 0,
//       unit: json['unit'] ?? '',
//       description: json['description'] ?? '',
//     );
//   }
// }
// class ChargingPerformance {
//   final dynamic averageChargingSpeed;
//   final dynamic peakChargingSpeed;
//   final String unit;
//   final dynamic chargingEfficiency;
//   final String efficiencyUnit;
//   final String description;

//   ChargingPerformance({
//     required this.averageChargingSpeed,
//     required this.peakChargingSpeed,
//     required this.unit,
//     required this.chargingEfficiency,
//     required this.efficiencyUnit,
//     required this.description,
//   });

//   factory ChargingPerformance.fromJson(Map<String, dynamic> json) {
//     return ChargingPerformance(
//       averageChargingSpeed: json['averageChargingSpeed'] ?? 0,
//       peakChargingSpeed: json['peakChargingSpeed'] ?? 0,
//       unit: json['unit'] ?? '',
//       chargingEfficiency: json['chargingEfficiency'] ?? 0,
//       efficiencyUnit: json['efficiencyUnit'] ?? '',
//       description: json['description'] ?? '',
//     );
//   }
// }
// class ChargerDetails {
//   final String chargerType;
//   final String powerOutput;
//   final dynamic chargerTariff;
//   final String tariffUnit;
//   final String connectorId;
//   final String chargerStatus;

//   ChargerDetails({
//     required this.chargerType,
//     required this.powerOutput,
//     required this.chargerTariff,
//     required this.tariffUnit,
//     required this.connectorId,
//     required this.chargerStatus,
//   });

//   factory ChargerDetails.fromJson(Map<String, dynamic> json) {
//     return ChargerDetails(
//       chargerType: json['chargerType'] ?? '',
//       powerOutput: json['powerOutput'] ?? '',
//       chargerTariff: json['chargerTariff'] ?? 0,
//       tariffUnit: json['tariffUnit'] ?? '',
//       connectorId: json['connectorId'] ?? '',
//       chargerStatus: json['chargerStatus'] ?? '',
//     );
//   }
// }
// class CostDetails {
//   final dynamic totalCost;
//   final String currency;
//   final String breakdown;

//   CostDetails({
//     required this.totalCost,
//     required this.currency,
//     required this.breakdown,
//   });

//   factory CostDetails.fromJson(Map<String, dynamic> json) {
//     return CostDetails(
//       totalCost: json['totalCost'] ?? 0,
//       currency: json['currency'] ?? '',
//       breakdown: json['breakdown'] ?? '',
//     );
//   }
// }
// class Timing {
//   final bool isActive;
//   final String formattedDuration;

//   Timing({
//     required this.isActive,
//     required this.formattedDuration,
//   });

//   factory Timing.fromJson(Map<String, dynamic> json) {
//     return Timing(
//       isActive: json['isActive'] ?? false,
//       formattedDuration:
//           json['duration']?['formattedDuration'] ?? '',
//     );
//   }
// }
// class Summary {
//   final String energyDelivered;
//   final String totalCost;
//   final String chargingTime;

//   Summary({
//     required this.energyDelivered,
//     required this.totalCost,
//     required this.chargingTime,
//   });

//   factory Summary.fromJson(Map<String, dynamic> json) {
//     return Summary(
//       energyDelivered: json['energyDelivered'] ?? '',
//       totalCost: json['totalCost'] ?? '',
//       chargingTime: json['chargingTime'] ?? '',
//     );
//   }
// }
// class BatteryStateOfCharge {
//   final dynamic? startSoC;
//   final dynamic? endSoC;
//   final dynamic? currentSoC;
//   final String unit;
//   final bool isRealtime;

//   BatteryStateOfCharge({
//     required this.startSoC,
//     required this.endSoC,
//     required this.currentSoC,
//     required this.unit,
//     required this.isRealtime,
//   });

//   factory BatteryStateOfCharge.fromJson(Map<String, dynamic> json) {
//     return BatteryStateOfCharge(
//       startSoC: json['startSoC'],
//       endSoC: json['endSoC'],
//       currentSoC: json['currentSoC'],
//       unit: json['unit'] ?? '%',
//       isRealtime: json['isRealtime'] ?? false,
//     );
//   }
// }

// // class SessionDetailResponse {
// //   final bool? success;
// //   final String? message;
// //   final SessionDetailData? data;

// //   SessionDetailResponse({
// //     this.success,
// //     this.message,
// //     this.data,
// //   });

// //   factory SessionDetailResponse.fromJson(Map<String, dynamic> json) {
// //     return SessionDetailResponse(
// //       success: json['success'],
// //       message: json['message'],
// //       data: json['data'] != null
// //           ? SessionDetailData.fromJson(json['data'])
// //           : null,
// //     );
// //   }
// // }
// // class SessionDetailData {
// //   final ChargingSession? session;
// //   final int? transactionId;
// //   final String? status;
// //   final bool? isActive;
// //   final MeterReadings? meterReadings;
// //   final EnergyConsumption? energyConsumption;
// //   final dynamic stateOfCharge;
// //   final dynamic vehicle;
// //   final ChargingPerformance? chargingPerformance;
// //   final ChargerDetails? chargerDetails;
// //   final CostDetails? costDetails;
// //   final TimingDetails? timing;
// //   final SessionSummary? summary;

// //   SessionDetailData({
// //     this.session,
// //     this.transactionId,
// //     this.status,
// //     this.isActive,
// //     this.meterReadings,
// //     this.energyConsumption,
// //     this.stateOfCharge,
// //     this.vehicle,
// //     this.chargingPerformance,
// //     this.chargerDetails,
// //     this.costDetails,
// //     this.timing,
// //     this.summary,
// //   });

// //   factory SessionDetailData.fromJson(Map<String, dynamic> json) {
// //     return SessionDetailData(
// //       session: json['session'] != null
// //           ? ChargingSession.fromJson(json['session'])
// //           : null,
// //       transactionId: json['transactionId'],
// //       status: json['status'],
// //       isActive: json['isActive'],
// //       meterReadings: json['meterReadings'] != null
// //           ? MeterReadings.fromJson(json['meterReadings'])
// //           : null,
// //       energyConsumption: json['energyConsumption'] != null
// //           ? EnergyConsumption.fromJson(json['energyConsumption'])
// //           : null,
// //       stateOfCharge: json['stateOfCharge'],
// //       vehicle: json['vehicle'],
// //       chargingPerformance: json['chargingPerformance'] != null
// //           ? ChargingPerformance.fromJson(json['chargingPerformance'])
// //           : null,
// //       chargerDetails: json['chargerDetails'] != null
// //           ? ChargerDetails.fromJson(json['chargerDetails'])
// //           : null,
// //       costDetails: json['costDetails'] != null
// //           ? CostDetails.fromJson(json['costDetails'])
// //           : null,
// //       timing: json['timing'] != null
// //           ? TimingDetails.fromJson(json['timing'])
// //           : null,
// //       summary: json['summary'] != null
// //           ? SessionSummary.fromJson(json['summary'])
// //           : null,
// //     );
// //   }
// // }
// // class ChargingSession {
// //   final String? recId;
// //   final String? chargingGunId;
// //   final String? chargingStationId;
// //   final String? chargingStationName;
// //   final String? chargingHubName;
// //   final String? startMeterReading;
// //   final String? endMeterReading;
// //   final String? energyTransmitted;
// //   final String? startTime;
// //   final String? endTime;
// //   final String? chargingSpeed;
// //   final String? chargingTariff;
// //   final String? chargingTotalFee;
// //   final String? status;
// //   final String? duration;
// //   final int? active;
// //   final String? createdOn;
// //   final String? updatedOn;

// //   ChargingSession({
// //     this.recId,
// //     this.chargingGunId,
// //     this.chargingStationId,
// //     this.chargingStationName,
// //     this.chargingHubName,
// //     this.startMeterReading,
// //     this.endMeterReading,
// //     this.energyTransmitted,
// //     this.startTime,
// //     this.endTime,
// //     this.chargingSpeed,
// //     this.chargingTariff,
// //     this.chargingTotalFee,
// //     this.status,
// //     this.duration,
// //     this.active,
// //     this.createdOn,
// //     this.updatedOn,
// //   });

// //   factory ChargingSession.fromJson(Map<String, dynamic> json) {
// //     return ChargingSession(
// //       recId: json['recId'],
// //       chargingGunId: json['chargingGunId'],
// //       chargingStationId: json['chargingStationId'],
// //       chargingStationName: json['chargingStationName'],
// //       chargingHubName: json['chargingHubName'],
// //       startMeterReading: json['startMeterReading'],
// //       endMeterReading: json['endMeterReading'],
// //       energyTransmitted: json['energyTransmitted'],
// //       startTime: json['startTime'],
// //       endTime: json['endTime'],
// //       chargingSpeed: json['chargingSpeed'],
// //       chargingTariff: json['chargingTariff'],
// //       chargingTotalFee: json['chargingTotalFee'],
// //       status: json['status'],
// //       duration: json['duration'],
// //       active: json['active'],
// //       createdOn: json['createdOn'],
// //       updatedOn: json['updatedOn'],
// //     );
// //   }
// // }

// // class MeterReadings {
// //   final num? startReading;
// //   final num? currentReading;
// //   final String? unit;
// //   final String? dataSource;
// //   final bool? isRealtime;

// //   MeterReadings({
// //     this.startReading,
// //     this.currentReading,
// //     this.unit,
// //     this.dataSource,
// //     this.isRealtime,
// //   });

// //   factory MeterReadings.fromJson(Map<String, dynamic> json) {
// //     return MeterReadings(
// //       startReading: json['startReading'],
// //       currentReading: json['currentReading'],
// //       unit: json['unit'],
// //       dataSource: json['dataSource'],
// //       isRealtime: json['isRealtime'],
// //     );
// //   }
// // }
// // class EnergyConsumption {
// //   final num? totalEnergy;
// //   final String? unit;
// //   final String? description;

// //   EnergyConsumption({
// //     this.totalEnergy,
// //     this.unit,
// //     this.description,
// //   });

// //   factory EnergyConsumption.fromJson(Map<String, dynamic> json) {
// //     return EnergyConsumption(
// //       totalEnergy: json['totalEnergy'],
// //       unit: json['unit'],
// //       description: json['description'],
// //     );
// //   }
// // }
// // class ChargingPerformance {
// //   final num? averageChargingSpeed;
// //   final num? peakChargingSpeed;
// //   final String? unit;
// //   final num? chargingEfficiency;
// //   final String? efficiencyUnit;
// //   final String? description;

// //   ChargingPerformance({
// //     this.averageChargingSpeed,
// //     this.peakChargingSpeed,
// //     this.unit,
// //     this.chargingEfficiency,
// //     this.efficiencyUnit,
// //     this.description,
// //   });

// //   factory ChargingPerformance.fromJson(Map<String, dynamic> json) {
// //     return ChargingPerformance(
// //       averageChargingSpeed: json['averageChargingSpeed'],
// //       peakChargingSpeed: json['peakChargingSpeed'],
// //       unit: json['unit'],
// //       chargingEfficiency: json['chargingEfficiency'],
// //       efficiencyUnit: json['efficiencyUnit'],
// //       description: json['description'],
// //     );
// //   }
// // }
// // class ChargerDetails {
// //   final String? chargerType;
// //   final String? powerOutput;
// //   final num? chargerTariff;
// //   final String? tariffUnit;
// //   final String? connectorId;
// //   final String? chargerStatus;

// //   ChargerDetails({
// //     this.chargerType,
// //     this.powerOutput,
// //     this.chargerTariff,
// //     this.tariffUnit,
// //     this.connectorId,
// //     this.chargerStatus,
// //   });

// //   factory ChargerDetails.fromJson(Map<String, dynamic> json) {
// //     return ChargerDetails(
// //       chargerType: json['chargerType'],
// //       powerOutput: json['powerOutput'],
// //       chargerTariff: json['chargerTariff'],
// //       tariffUnit: json['tariffUnit'],
// //       connectorId: json['connectorId'],
// //       chargerStatus: json['chargerStatus'],
// //     );
// //   }
// // }
// // class CostDetails {
// //   final num? energyCost;
// //   final num? serviceFee;
// //   final num? taxes;
// //   final num? totalCost;
// //   final String? currency;
// //   final num? tariffApplied;
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
// //       energyCost: json['energyCost'],
// //       serviceFee: json['serviceFee'],
// //       taxes: json['taxes'],
// //       totalCost: json['totalCost'],
// //       currency: json['currency'],
// //       tariffApplied: json['tariffApplied'],
// //       tariffUnit: json['tariffUnit'],
// //       breakdown: json['breakdown'],
// //     );
// //   }
// // }
// // class TimingDetails {
// //   final String? startTime;
// //   final String? endTime;
// //   final DurationDetails? duration;
// //   final bool? isActive;
// //   final String? lastUpdate;

// //   TimingDetails({
// //     this.startTime,
// //     this.endTime,
// //     this.duration,
// //     this.isActive,
// //     this.lastUpdate,
// //   });

// //   factory TimingDetails.fromJson(Map<String, dynamic> json) {
// //     return TimingDetails(
// //       startTime: json['startTime'],
// //       endTime: json['endTime'],
// //       duration: json['duration'] != null
// //           ? DurationDetails.fromJson(json['duration'])
// //           : null,
// //       isActive: json['isActive'],
// //       lastUpdate: json['lastUpdate'],
// //     );
// //   }
// // }
// // class DurationDetails {
// //   final int? totalMinutes;
// //   final int? hours;
// //   final int? minutes;
// //   final num? totalHours;
// //   final String? formattedDuration;

// //   DurationDetails({
// //     this.totalMinutes,
// //     this.hours,
// //     this.minutes,
// //     this.totalHours,
// //     this.formattedDuration,
// //   });

// //   factory DurationDetails.fromJson(Map<String, dynamic> json) {
// //     return DurationDetails(
// //       totalMinutes: json['totalMinutes'],
// //       hours: json['hours'],
// //       minutes: json['minutes'],
// //       totalHours: json['totalHours'],
// //       formattedDuration: json['formattedDuration'],
// //     );
// //   }
// // }
// // class SessionSummary {
// //   final String? energyDelivered;
// //   final String? socGained;
// //   final String? rangeAdded;
// //   final String? totalCost;
// //   final String? chargingTime;
// //   final String? averageSpeed;
// //   final String? costPerKwh;

// //   SessionSummary({
// //     this.energyDelivered,
// //     this.socGained,
// //     this.rangeAdded,
// //     this.totalCost,
// //     this.chargingTime,
// //     this.averageSpeed,
// //     this.costPerKwh,
// //   });

// //   factory SessionSummary.fromJson(Map<String, dynamic> json) {
// //     return SessionSummary(
// //       energyDelivered: json['energyDelivered'],
// //       socGained: json['socGained'],
// //       rangeAdded: json['rangeAdded'],
// //       totalCost: json['totalCost'],
// //       chargingTime: json['chargingTime'],
// //       averageSpeed: json['averageSpeed'],
// //       costPerKwh: json['costPerKwh'],
// //     );
// //   }
// // }
