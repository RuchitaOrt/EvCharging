class SessionDetailResponse {
  final bool? success;
  final String? message;
  final SessionDetailData? data;

  SessionDetailResponse({
    this.success,
    this.message,
    this.data,
  });

  factory SessionDetailResponse.fromJson(Map<String, dynamic> json) {
    return SessionDetailResponse(
      success: json['success'],
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
  final dynamic stateOfCharge;
  final dynamic vehicle;
  final ChargingPerformance? chargingPerformance;
  final ChargerDetails? chargerDetails;
  final CostDetails? costDetails;
  final TimingDetails? timing;
  final SessionSummary? summary;

  SessionDetailData({
    this.session,
    this.transactionId,
    this.status,
    this.isActive,
    this.meterReadings,
    this.energyConsumption,
    this.stateOfCharge,
    this.vehicle,
    this.chargingPerformance,
    this.chargerDetails,
    this.costDetails,
    this.timing,
    this.summary,
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
      stateOfCharge: json['stateOfCharge'],
      vehicle: json['vehicle'],
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
          ? TimingDetails.fromJson(json['timing'])
          : null,
      summary: json['summary'] != null
          ? SessionSummary.fromJson(json['summary'])
          : null,
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

class MeterReadings {
  final num? startReading;
  final num? currentReading;
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
      startReading: json['startReading'],
      currentReading: json['currentReading'],
      unit: json['unit'],
      dataSource: json['dataSource'],
      isRealtime: json['isRealtime'],
    );
  }
}
class EnergyConsumption {
  final num? totalEnergy;
  final String? unit;
  final String? description;

  EnergyConsumption({
    this.totalEnergy,
    this.unit,
    this.description,
  });

  factory EnergyConsumption.fromJson(Map<String, dynamic> json) {
    return EnergyConsumption(
      totalEnergy: json['totalEnergy'],
      unit: json['unit'],
      description: json['description'],
    );
  }
}
class ChargingPerformance {
  final num? averageChargingSpeed;
  final num? peakChargingSpeed;
  final String? unit;
  final num? chargingEfficiency;
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
      averageChargingSpeed: json['averageChargingSpeed'],
      peakChargingSpeed: json['peakChargingSpeed'],
      unit: json['unit'],
      chargingEfficiency: json['chargingEfficiency'],
      efficiencyUnit: json['efficiencyUnit'],
      description: json['description'],
    );
  }
}
class ChargerDetails {
  final String? chargerType;
  final String? powerOutput;
  final num? chargerTariff;
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
      powerOutput: json['powerOutput'],
      chargerTariff: json['chargerTariff'],
      tariffUnit: json['tariffUnit'],
      connectorId: json['connectorId'],
      chargerStatus: json['chargerStatus'],
    );
  }
}
class CostDetails {
  final num? energyCost;
  final num? serviceFee;
  final num? taxes;
  final num? totalCost;
  final String? currency;
  final num? tariffApplied;
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
      energyCost: json['energyCost'],
      serviceFee: json['serviceFee'],
      taxes: json['taxes'],
      totalCost: json['totalCost'],
      currency: json['currency'],
      tariffApplied: json['tariffApplied'],
      tariffUnit: json['tariffUnit'],
      breakdown: json['breakdown'],
    );
  }
}
class TimingDetails {
  final String? startTime;
  final String? endTime;
  final DurationDetails? duration;
  final bool? isActive;
  final String? lastUpdate;

  TimingDetails({
    this.startTime,
    this.endTime,
    this.duration,
    this.isActive,
    this.lastUpdate,
  });

  factory TimingDetails.fromJson(Map<String, dynamic> json) {
    return TimingDetails(
      startTime: json['startTime'],
      endTime: json['endTime'],
      duration: json['duration'] != null
          ? DurationDetails.fromJson(json['duration'])
          : null,
      isActive: json['isActive'],
      lastUpdate: json['lastUpdate'],
    );
  }
}
class DurationDetails {
  final int? totalMinutes;
  final int? hours;
  final int? minutes;
  final num? totalHours;
  final String? formattedDuration;

  DurationDetails({
    this.totalMinutes,
    this.hours,
    this.minutes,
    this.totalHours,
    this.formattedDuration,
  });

  factory DurationDetails.fromJson(Map<String, dynamic> json) {
    return DurationDetails(
      totalMinutes: json['totalMinutes'],
      hours: json['hours'],
      minutes: json['minutes'],
      totalHours: json['totalHours'],
      formattedDuration: json['formattedDuration'],
    );
  }
}
class SessionSummary {
  final String? energyDelivered;
  final String? socGained;
  final String? rangeAdded;
  final String? totalCost;
  final String? chargingTime;
  final String? averageSpeed;
  final String? costPerKwh;

  SessionSummary({
    this.energyDelivered,
    this.socGained,
    this.rangeAdded,
    this.totalCost,
    this.chargingTime,
    this.averageSpeed,
    this.costPerKwh,
  });

  factory SessionSummary.fromJson(Map<String, dynamic> json) {
    return SessionSummary(
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
//     this.data,
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
//   final ChargingSession? session;
//   final int? transactionId;
//   final String? status;
//   final bool? isActive;
//   final int? meterStart;
//   final int? meterCurrent;
//   final double? energyConsumed;
//   final double? estimatedCost;
//   final int? chargingSpeed;
//   final String? tariff;
//   final SessionDuration? duration;
//   final String? startTime;
//   final String? endTime;
//   final String? lastUpdate;

//   SessionDetailData({
//     this.session,
//     this.transactionId,
//     this.status,
//     this.isActive,
//     this.meterStart,
//     this.meterCurrent,
//     this.energyConsumed,
//     this.estimatedCost,
//     this.chargingSpeed,
//     this.tariff,
//     this.duration,
//     this.startTime,
//     this.endTime,
//     this.lastUpdate,
//   });

//   factory SessionDetailData.fromJson(Map<String, dynamic> json) {
//     return SessionDetailData(
//       session: json['session'] != null
//           ? ChargingSession.fromJson(json['session'])
//           : null,
//       transactionId: json['transactionId'],
//       status: json['status'],
//       isActive: json['isActive'],
//       meterStart: json['meterStart'],
//       meterCurrent: json['meterCurrent'],
//       energyConsumed: (json['energyConsumed'] as num?)?.toDouble(),
//       estimatedCost: (json['estimatedCost'] as num?)?.toDouble(),
//       chargingSpeed: json['chargingSpeed'],
//       tariff: json['tariff'],
//       duration: json['duration'] != null
//           ? SessionDuration.fromJson(json['duration'])
//           : null,
//       startTime: json['startTime'],
//       endTime: json['endTime'],
//       lastUpdate: json['lastUpdate'],
//     );
//   }
// }

// class SessionDuration {
//   final int? totalMinutes;
//   final int? hours;
//   final int? minutes;
//   final double? totalHours;

//   SessionDuration({
//     this.totalMinutes,
//     this.hours,
//     this.minutes,
//     this.totalHours,
//   });

//   factory SessionDuration.fromJson(Map<String, dynamic> json) {
//     return SessionDuration(
//       totalMinutes: json['totalMinutes'],
//       hours: json['hours'],
//       minutes: json['minutes'],
//       totalHours: (json['totalHours'] as num?)?.toDouble(),
//     );
//   }
// }

// class ChargingSession {
//   final String? recId;
//   final String? chargingGunId;
//   final String? chargingStationId;
//   final String? chargingStationName;
//   final String? chargingHubName;
//   final String? startMeterReading;
//   final String? endMeterReading;
//   final String? energyTransmitted;
//   final String? startTime;
//   final String? endTime;
//   final String? chargingSpeed;
//   final String? chargingTariff;
//   final String? chargingTotalFee;
//   final String? status;
//   final String? duration;
//   final int? active;
//   final String? createdOn;
//   final String? updatedOn;

//   ChargingSession({
//     this.recId,
//     this.chargingGunId,
//     this.chargingStationId,
//     this.chargingStationName,
//     this.chargingHubName,
//     this.startMeterReading,
//     this.endMeterReading,
//     this.energyTransmitted,
//     this.startTime,
//     this.endTime,
//     this.chargingSpeed,
//     this.chargingTariff,
//     this.chargingTotalFee,
//     this.status,
//     this.duration,
//     this.active,
//     this.createdOn,
//     this.updatedOn,
//   });

//   factory ChargingSession.fromJson(Map<String, dynamic> json) {
//     return ChargingSession(
//       recId: json['recId'],
//       chargingGunId: json['chargingGunId'],
//       chargingStationId: json['chargingStationId'],
//       chargingStationName: json['chargingStationName'],
//       chargingHubName: json['chargingHubName'],
//       startMeterReading: json['startMeterReading'],
//       endMeterReading: json['endMeterReading'],
//       energyTransmitted: json['energyTransmitted'],
//       startTime: json['startTime'],
//       endTime: json['endTime'],
//       chargingSpeed: json['chargingSpeed'],
//       chargingTariff: json['chargingTariff'],
//       chargingTotalFee: json['chargingTotalFee'],
//       status: json['status'],
//       duration: json['duration'],
//       active: json['active'],
//       createdOn: json['createdOn'],
//       updatedOn: json['updatedOn'],
//     );
//   }
// }
