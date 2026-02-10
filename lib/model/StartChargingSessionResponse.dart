class StartChargingSessionResponse {
  final bool success;
  final String message;
  final StartChargingSessionData? data;

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
          ? StartChargingSessionData.fromJson(json['data'])
          : null,
    );
  }
}
class StartChargingSessionData {
  final ChargingSession? session;
  final int? transactionId;
  final double meterStart;
  final String meterSource;
  final String tariff;
  final DateTime? startTime;
  final BatteryStateOfCharge? batteryStateOfCharge;
  final String recommendation;

  StartChargingSessionData({
    this.session,
    this.transactionId,
    required this.meterStart,
    required this.meterSource,
    required this.tariff,
    this.startTime,
    this.batteryStateOfCharge,
    required this.recommendation,
  });

  factory StartChargingSessionData.fromJson(Map<String, dynamic> json) {
    return StartChargingSessionData(
      session: json['session'] != null
          ? ChargingSession.fromJson(json['session'])
          : null,
      transactionId: json['transactionId'],
      meterStart: (json['meterStart'] ?? 0).toDouble(),
      meterSource: json['meterSource'] ?? '',
      tariff: json['tariff'] ?? '0',
      startTime: json['startTime'] != null
          ? DateTime.tryParse(json['startTime'])
          : null,
      batteryStateOfCharge: json['batteryStateOfCharge'] != null
          ? BatteryStateOfCharge.fromJson(json['batteryStateOfCharge'])
          : null,
      recommendation: json['recommendation'] ?? '',
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
class BatteryStateOfCharge {
  final int? startSoC;
  final int? endSoC;
  final int? currentSoC;
  final int? soCGain;
  final String? lastUpdate;
  final String unit;
  final bool isRealtime;
  final String dataSource;

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
      startSoC: json['startSoC'],
      endSoC: json['endSoC'],
      currentSoC: json['currentSoC'],
      soCGain: json['soCGain'],
      lastUpdate: json['lastUpdate'],
      unit: json['unit'] ?? '%',
      isRealtime: json['isRealtime'] ?? false,
      dataSource: json['dataSource'] ?? 'Not Available',
    );
  }
}


// class StartChargingSessionResponse {
//   final bool success;
//   final String message;
//   final StartChargingData? data;

//   StartChargingSessionResponse({
//     required this.success,
//     required this.message,
//     this.data,
//   });

//   factory StartChargingSessionResponse.fromJson(Map<String, dynamic> json) {
//     return StartChargingSessionResponse(
//       success: json['success'] ?? false,
//       message: json['message'] ?? '',
//       data: json['data'] != null
//           ? StartChargingData.fromJson(json['data'])
//           : null,
//     );
//   }
// }

// class StartChargingData {
//   final ChargingSession? session;
//   final int? transactionId;
//   final int? meterStart;
//   final String? tariff;

//   StartChargingData({
//     this.session,
//     this.transactionId,
//     this.meterStart,
//     this.tariff,
//   });

//   factory StartChargingData.fromJson(Map<String, dynamic> json) {
//     return StartChargingData(
//       session: json['session'] != null
//           ? ChargingSession.fromJson(json['session'])
//           : null,
//       transactionId: json['transactionId'],
//       meterStart: json['meterStart'],
//       tariff: json['tariff'],
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
