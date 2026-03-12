
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
