class StartChargingSessionResponse {
  final bool success;
  final String? message;
  final StartChargingSessionData? data;

  StartChargingSessionResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory StartChargingSessionResponse.fromJson(Map<String, dynamic> json) {
    return StartChargingSessionResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'] != null
          ? StartChargingSessionData.fromJson(json['data'])
          : null,
    );
  }
}
class StartChargingSessionData {
  final ChargingSession? session;
  final int? transactionId;
  final double? meterStart;
  final String? meterSource;
  final String? tariff;
  final DateTime? startTime;
  final BatteryStateOfCharge? batteryStateOfCharge;
  final String? recommendation;

  StartChargingSessionData({
    this.session,
    this.transactionId,
    this.meterStart,
    this.meterSource,
    this.tariff,
    this.startTime,
    this.batteryStateOfCharge,
    this.recommendation,
  });

  factory StartChargingSessionData.fromJson(Map<String, dynamic> json) {
    return StartChargingSessionData(
      session: json['session'] != null
          ? ChargingSession.fromJson(json['session'])
          : null,
      transactionId: json['transactionId'],
      meterStart: _toDouble(json['meterStart']),
      meterSource: json['meterSource'],
      tariff: json['tariff'],
      startTime: json['startTime'] != null
          ? DateTime.tryParse(json['startTime'])
          : null,
      batteryStateOfCharge: json['batteryStateOfCharge'] != null
          ? BatteryStateOfCharge.fromJson(json['batteryStateOfCharge'])
          : null,
      recommendation: json['recommendation'],
    );
  }
}
class ChargingSession {
  final String? recId;
  final String? chargingGunId;
  final String? connectorName;
  final String? chargingStationId;
  final String? chargingStationName;
  final String? chargingHubName;

  final ChargingHub? chargingHub;
  final ChargingGun? chargingGun;

  final double? startMeterReading;
  final double? endMeterReading;
  final double? energyTransmitted;
  final double? chargingSpeed;

  final DateTime? startTime;
  final DateTime? endTime;

  final double? chargingTariff;
  final double? chargingTotalFee;

  final String? status;
  final String? duration;

  final int? energyLimit;
  final int? costLimit;
  final int? timeLimit;
  final int? batteryIncreaseLimit;

  final int? active;
  final DateTime? createdOn;
  final DateTime? updatedOn;

  // ✅ MISSING FIELDS ADDED
  final double? soCStart;
  final double? soCEnd;
  final DateTime? soCLastUpdate;

  ChargingSession({
    this.recId,
    this.chargingGunId,
    this.connectorName,
    this.chargingStationId,
    this.chargingStationName,
    this.chargingHubName,
    this.chargingHub,
    this.chargingGun,
    this.startMeterReading,
    this.endMeterReading,
    this.energyTransmitted,
    this.chargingSpeed,
    this.startTime,
    this.endTime,
    this.chargingTariff,
    this.chargingTotalFee,
    this.status,
    this.duration,
    this.energyLimit,
    this.costLimit,
    this.timeLimit,
    this.batteryIncreaseLimit,
    this.active,
    this.createdOn,
    this.updatedOn,
    this.soCStart,
    this.soCEnd,
    this.soCLastUpdate,
  });

  factory ChargingSession.fromJson(Map<String, dynamic> json) {
    return ChargingSession(
      recId: json['recId'],
      chargingGunId: json['chargingGunId'],
      connectorName: json['connectorName'],
      chargingStationId: json['chargingStationId'],
      chargingStationName: json['chargingStationName'],
      chargingHubName: json['chargingHubName'],

      chargingHub: json['chargingHub'] != null
          ? ChargingHub.fromJson(json['chargingHub'])
          : null,

      chargingGun: json['chargingGun'] != null
          ? ChargingGun.fromJson(json['chargingGun'])
          : null,

      startMeterReading: _toDouble(json['startMeterReading']),
      endMeterReading: _toDouble(json['endMeterReading']),
      energyTransmitted: _toDouble(json['energyTransmitted']),
      chargingSpeed: _toDouble(json['chargingSpeed']),

      startTime: json['startTime'] != null
          ? DateTime.tryParse(json['startTime'])
          : null,

      endTime: json['endTime'] != null
          ? DateTime.tryParse(json['endTime'])
          : null,

      chargingTariff: _toDouble(json['chargingTariff']),
      chargingTotalFee: _toDouble(json['chargingTotalFee']),

      status: json['status'],
      duration: json['duration'],

      energyLimit: json['energyLimit'],
      costLimit: json['costLimit'],
      timeLimit: json['timeLimit'],
      batteryIncreaseLimit: json['batteryIncreaseLimit'],

      active: json['active'],
      createdOn: json['createdOn'] != null
          ? DateTime.tryParse(json['createdOn'])
          : null,
      updatedOn: json['updatedOn'] != null
          ? DateTime.tryParse(json['updatedOn'])
          : null,

      // ✅ Newly added fields
      soCStart: _toDouble(json['soCStart']),
      soCEnd: _toDouble(json['soCEnd']),
      soCLastUpdate: json['soCLastUpdate'] != null
          ? DateTime.tryParse(json['soCLastUpdate'])
          : null,
    );
  }
}

class ChargingGun {
  final String? recId;
  final String? chargingStationId;
  final String? connectorId;
  final String? chargingHubId;
  final String? chargerTypeId;

  final double? chargerTariff;
  final double? powerOutput;
  final double? chargerMeterReading;

  final String? chargerStatus;
  final int? active;

  final DateTime? createdOn;
  final DateTime? updatedOn;

  ChargingGun({
    this.recId,
    this.chargingStationId,
    this.connectorId,
    this.chargingHubId,
    this.chargerTypeId,
    this.chargerTariff,
    this.powerOutput,
    this.chargerMeterReading,
    this.chargerStatus,
    this.active,
    this.createdOn,
    this.updatedOn,
  });

  factory ChargingGun.fromJson(Map<String, dynamic> json) {
    return ChargingGun(
      recId: json['recId'],
      chargingStationId: json['chargingStationId'],
      connectorId: json['connectorId'],
      chargingHubId: json['chargingHubId'],
      chargerTypeId: json['chargerTypeId'],

      chargerTariff: _toDouble(json['chargerTariff']),
      powerOutput: _toDouble(json['powerOutput']),
      chargerMeterReading: _toDouble(json['chargerMeterReading']),

      chargerStatus: json['chargerStatus'],
      active: json['active'],

      createdOn: DateTime.tryParse(json['createdOn'] ?? ''),
      updatedOn: DateTime.tryParse(json['updatedOn'] ?? ''),
    );
  }
}
class ChargingHub {
  final String? recId;
  final String? chargingHubName;
  final double? latitude;
  final double? longitude;
  final int? active;
  final DateTime? createdOn;
  final DateTime? updatedOn;

  ChargingHub({
    this.recId,
    this.chargingHubName,
    this.latitude,
    this.longitude,
    this.active,
    this.createdOn,
    this.updatedOn,
  });

  factory ChargingHub.fromJson(Map<String, dynamic> json) {
    return ChargingHub(
      recId: json['recId'],
      chargingHubName: json['chargingHubName'],
      latitude: _toDouble(json['latitude']),
      longitude: _toDouble(json['longitude']),
      active: json['active'],
      createdOn: DateTime.tryParse(json['createdOn'] ?? ''),
      updatedOn: DateTime.tryParse(json['updatedOn'] ?? ''),
    );
  }
}

// class ChargingSession {
//   final String? recId;
//   final String? chargingGunId;
//   final String? connectorName;
//   final String? chargingStationId;
//   final String? chargingStationName;
//   final String? chargingHubName;
//   final double? startMeterReading;
//   final double? endMeterReading;
//   final double? energyTransmitted;
//   final DateTime? startTime;
//   final DateTime? endTime;
//   final String? status;
//   final String? duration;
//   final double? chargingTariff;
//   final double? chargingTotalFee;

//   ChargingSession({
//     this.recId,
//     this.chargingGunId,
//     this.connectorName,
//     this.chargingStationId,
//     this.chargingStationName,
//     this.chargingHubName,
//     this.startMeterReading,
//     this.endMeterReading,
//     this.energyTransmitted,
//     this.startTime,
//     this.endTime,
//     this.status,
//     this.duration,
//     this.chargingTariff,
//     this.chargingTotalFee,
//   });

//   factory ChargingSession.fromJson(Map<String, dynamic> json) {
//     return ChargingSession(
//       recId: json['recId'],
//       chargingGunId: json['chargingGunId'],
//       connectorName: json['connectorName'],
//       chargingStationId: json['chargingStationId'],
//       chargingStationName: json['chargingStationName'],
//       chargingHubName: json['chargingHubName'],
//       startMeterReading: _toDouble(json['startMeterReading']),
//       endMeterReading: _toDouble(json['endMeterReading']),
//       energyTransmitted: _toDouble(json['energyTransmitted']),
//       startTime: json['startTime'] != null
//           ? DateTime.tryParse(json['startTime'])
//           : null,
//       endTime: json['endTime'] != null
//           ? DateTime.tryParse(json['endTime'])
//           : null,
//       status: json['status'],
//       duration: json['duration'],
//       chargingTariff: _toDouble(json['chargingTariff']),
//       chargingTotalFee: _toDouble(json['chargingTotalFee']),
//     );
//   }
// }
class BatteryStateOfCharge {
  final double? startSoC;
  final double? endSoC;
  final double? currentSoC;
  final double? soCGain;
  final DateTime? lastUpdate;
  final String? unit;
  final bool? isRealtime;
  final String? dataSource;

  BatteryStateOfCharge({
    this.startSoC,
    this.endSoC,
    this.currentSoC,
    this.soCGain,
    this.lastUpdate,
    this.unit,
    this.isRealtime,
    this.dataSource,
  });

  factory BatteryStateOfCharge.fromJson(Map<String, dynamic> json) {
    return BatteryStateOfCharge(
      startSoC: _toDouble(json['startSoC']),
      endSoC: _toDouble(json['endSoC']),
      currentSoC: _toDouble(json['currentSoC']),
      soCGain: _toDouble(json['soCGain']),
      lastUpdate: json['lastUpdate'] != null
          ? DateTime.tryParse(json['lastUpdate'])
          : null,
      unit: json['unit'],
      isRealtime: json['isRealtime'],
      dataSource: json['dataSource'],
    );
  }
}
double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

// class StartChargingSessionResponse {
//   final bool success;
//   final String message;
//   final StartChargingSessionData? data;

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
//           ? StartChargingSessionData.fromJson(json['data'])
//           : null,
//     );
//   }
// }
// class StartChargingSessionData {
//   final ChargingSession? session;
//   final int? transactionId;
//   final double meterStart;
//   final String meterSource;
//   final String tariff;
//   final DateTime? startTime;
//   final BatteryStateOfCharge? batteryStateOfCharge;
//   final String recommendation;

//   StartChargingSessionData({
//     this.session,
//     this.transactionId,
//     required this.meterStart,
//     required this.meterSource,
//     required this.tariff,
//     this.startTime,
//     this.batteryStateOfCharge,
//     required this.recommendation,
//   });

//   factory StartChargingSessionData.fromJson(Map<String, dynamic> json) {
//     return StartChargingSessionData(
//       session: json['session'] != null
//           ? ChargingSession.fromJson(json['session'])
//           : null,
//       transactionId: json['transactionId'],
//       meterStart: (json['meterStart'] ?? 0).toDouble(),
//       meterSource: json['meterSource'] ?? '',
//       tariff: json['tariff'] ?? '0',
//       startTime: json['startTime'] != null
//           ? DateTime.tryParse(json['startTime'])
//           : null,
//       batteryStateOfCharge: json['batteryStateOfCharge'] != null
//           ? BatteryStateOfCharge.fromJson(json['batteryStateOfCharge'])
//           : null,
//       recommendation: json['recommendation'] ?? '',
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
//   final String? soCLastUpdate;

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
//     this.startTime,
//     this.endTime,
//     required this.chargingSpeed,
//     required this.chargingTariff,
//     required this.chargingTotalFee,
//     required this.status,
//     required this.duration,
//     required this.active,
//     this.createdOn,
//     this.updatedOn,
//     this.soCStart,
//     this.soCEnd,
//     this.soCLastUpdate,
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
//       startTime: json['startTime'] != null
//           ? DateTime.tryParse(json['startTime'])
//           : null,
//       endTime: json['endTime'] != null
//           ? DateTime.tryParse(json['endTime'])
//           : null,
//       chargingSpeed: json['chargingSpeed'] ?? '0',
//       chargingTariff: json['chargingTariff'] ?? '0',
//       chargingTotalFee: json['chargingTotalFee'] ?? '0',
//       status: json['status'] ?? '',
//       duration: json['duration'] ?? '',
//       active: json['active'] ?? 0,
//       createdOn: json['createdOn'] != null
//           ? DateTime.tryParse(json['createdOn'])
//           : null,
//       updatedOn: json['updatedOn'] != null
//           ? DateTime.tryParse(json['updatedOn'])
//           : null,
//       soCStart: json['soCStart'],
//       soCEnd: json['soCEnd'],
//       soCLastUpdate: json['soCLastUpdate'],
//     );
//   }
// }
// class BatteryStateOfCharge {
//   final int? startSoC;
//   final int? endSoC;
//   final int? currentSoC;
//   final int? soCGain;
//   final String? lastUpdate;
//   final String unit;
//   final bool isRealtime;
//   final String dataSource;

//   BatteryStateOfCharge({
//     this.startSoC,
//     this.endSoC,
//     this.currentSoC,
//     this.soCGain,
//     this.lastUpdate,
//     required this.unit,
//     required this.isRealtime,
//     required this.dataSource,
//   });

//   factory BatteryStateOfCharge.fromJson(Map<String, dynamic> json) {
//     return BatteryStateOfCharge(
//       startSoC: json['startSoC'],
//       endSoC: json['endSoC'],
//       currentSoC: json['currentSoC'],
//       soCGain: json['soCGain'],
//       lastUpdate: json['lastUpdate'],
//       unit: json['unit'] ?? '%',
//       isRealtime: json['isRealtime'] ?? false,
//       dataSource: json['dataSource'] ?? 'Not Available',
//     );
//   }
// }


// // class StartChargingSessionResponse {
// //   final bool success;
// //   final String message;
// //   final StartChargingData? data;

// //   StartChargingSessionResponse({
// //     required this.success,
// //     required this.message,
// //     this.data,
// //   });

// //   factory StartChargingSessionResponse.fromJson(Map<String, dynamic> json) {
// //     return StartChargingSessionResponse(
// //       success: json['success'] ?? false,
// //       message: json['message'] ?? '',
// //       data: json['data'] != null
// //           ? StartChargingData.fromJson(json['data'])
// //           : null,
// //     );
// //   }
// // }

// // class StartChargingData {
// //   final ChargingSession? session;
// //   final int? transactionId;
// //   final int? meterStart;
// //   final String? tariff;

// //   StartChargingData({
// //     this.session,
// //     this.transactionId,
// //     this.meterStart,
// //     this.tariff,
// //   });

// //   factory StartChargingData.fromJson(Map<String, dynamic> json) {
// //     return StartChargingData(
// //       session: json['session'] != null
// //           ? ChargingSession.fromJson(json['session'])
// //           : null,
// //       transactionId: json['transactionId'],
// //       meterStart: json['meterStart'],
// //       tariff: json['tariff'],
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
