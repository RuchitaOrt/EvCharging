import 'package:HyCharge/model/StartChargingSessionResponse.dart';

class EndChargingSessionResponse {
  final bool success;
  final String? message;
  final EndChargingSessionData? data;

  EndChargingSessionResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory EndChargingSessionResponse.fromJson(Map<String, dynamic> json) {
    return EndChargingSessionResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'] != null
          ? EndChargingSessionData.fromJson(json['data'])
          : null,
    );
  }
}
class EndChargingSessionData {
  final ChargingSession? session;
  final int? transactionId;

  final double? energyConsumed;
  final double? cost;
  final double? meterStart;
  final double? meterStop;
  final double? duration;
  final double? chargingSpeed;

  final BatteryStateOfCharge? batteryStateOfCharge;
  final DataSource? dataSource;
  final WalletTransaction? walletTransaction;

  EndChargingSessionData({
    this.session,
    this.transactionId,
    this.energyConsumed,
    this.cost,
    this.meterStart,
    this.meterStop,
    this.duration,
    this.chargingSpeed,
    this.batteryStateOfCharge,
    this.dataSource,
    this.walletTransaction,
  });

  factory EndChargingSessionData.fromJson(Map<String, dynamic> json) {
    return EndChargingSessionData(
      session: json['session'] != null
          ? ChargingSession.fromJson(json['session'])
          : null,
      transactionId: json['transactionId'],
      energyConsumed: _toDouble(json['energyConsumed']),
      cost: _toDouble(json['cost']),
      meterStart: _toDouble(json['meterStart']),
      meterStop: _toDouble(json['meterStop']),
      duration: _toDouble(json['duration']),
      chargingSpeed: _toDouble(json['chargingSpeed']),
      batteryStateOfCharge: json['batteryStateOfCharge'] != null
          ? BatteryStateOfCharge.fromJson(json['batteryStateOfCharge'])
          : null,
      dataSource: json['dataSource'] != null
          ? DataSource.fromJson(json['dataSource'])
          : null,
      walletTransaction: json['walletTransaction'] != null
          ? WalletTransaction.fromJson(json['walletTransaction'])
          : null,
    );
  }
}
class DataSource {
  final bool? transactionUsed;
  final bool? connectorMeterUsed;
  final bool? manualMeterUsed;
  final String? connectorMeterValue;
  final DateTime? connectorMeterTime;

  DataSource({
    this.transactionUsed,
    this.connectorMeterUsed,
    this.manualMeterUsed,
    this.connectorMeterValue,
    this.connectorMeterTime,
  });

  factory DataSource.fromJson(Map<String, dynamic> json) {
    return DataSource(
      transactionUsed: json['transactionUsed'],
      connectorMeterUsed: json['connectorMeterUsed'],
      manualMeterUsed: json['manualMeterUsed'],
      connectorMeterValue: json['connectorMeterValue'],
      connectorMeterTime:
          DateTime.tryParse(json['connectorMeterTime'] ?? ''),
    );
  }
}
class WalletTransaction {
  final String? transactionId;
  final double? previousBalance;
  final double? amountDebited;
  final double? newBalance;

  WalletTransaction({
    this.transactionId,
    this.previousBalance,
    this.amountDebited,
    this.newBalance,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      transactionId: json['transactionId'],
      previousBalance: _toDouble(json['previousBalance']),
      amountDebited: _toDouble(json['amountDebited']),
      newBalance: _toDouble(json['newBalance']),
    );
  }
}
double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

// class EndChargingSessionResponse {
//   final bool success;
//   final String message;
//   final EndChargingSessionData? data;

//   EndChargingSessionResponse({
//     required this.success,
//     required this.message,
//     this.data,
//   });

//   factory EndChargingSessionResponse.fromJson(Map<String, dynamic> json) {
//     return EndChargingSessionResponse(
//       success: json['success'] ?? false,
//       message: json['message'] ?? '',
//       data: json['data'] != null
//           ? EndChargingSessionData.fromJson(json['data'])
//           : null,
//     );
//   }
// }
// class EndChargingSessionData {
//   final ChargingSession? session;
//   final dynamic? transactionId;
//   final dynamic energyConsumed;
//   final dynamic cost;
//   final dynamic meterStart;
//   final dynamic meterStop;
//   final dynamic duration;
//   final String chargingSpeed;
//   final BatteryStateOfCharge? batteryStateOfCharge;
//   final DataSource? dataSource;
//   final WalletTransaction? walletTransaction;

//   EndChargingSessionData({
//     this.session,
//     this.transactionId,
//     required this.energyConsumed,
//     required this.cost,
//     required this.meterStart,
//     required this.meterStop,
//     required this.duration,
//     required this.chargingSpeed,
//     this.batteryStateOfCharge,
//     this.dataSource,
//     this.walletTransaction,
//   });

//   factory EndChargingSessionData.fromJson(Map<String, dynamic> json) {
//     return EndChargingSessionData(
//       session: json['session'] != null
//           ? ChargingSession.fromJson(json['session'])
//           : null,
//       transactionId: json['transactionId'],
//       energyConsumed: (json['energyConsumed'] ?? 0).toDouble(),
//       cost: (json['cost'] ?? 0).toDouble(),
//       meterStart: (json['meterStart'] ?? 0).toDouble(),
//       meterStop: (json['meterStop'] ?? 0).toDouble(),
//       duration: json['duration'] ?? 0,
//       chargingSpeed: json['chargingSpeed'] ?? '0.00',
//       batteryStateOfCharge: json['batteryStateOfCharge'] != null
//           ? BatteryStateOfCharge.fromJson(json['batteryStateOfCharge'])
//           : null,
//       dataSource: json['dataSource'] != null
//           ? DataSource.fromJson(json['dataSource'])
//           : null,
//       walletTransaction: json['walletTransaction'] != null
//           ? WalletTransaction.fromJson(json['walletTransaction'])
//           : null,
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
//       chargingSpeed: json['chargingSpeed'] ?? '0.00',
//       chargingTariff: json['chargingTariff'] ?? '0',
//       chargingTotalFee: json['chargingTotalFee'] ?? '0',
//       status: json['status'] ?? '',
//       duration: json['duration'] ?? '',
//     );
//   }
// }

// class BatteryStateOfCharge {
//   final dynamic? startSoC;
//   final dynamic? endSoC;
//   final dynamic? currentSoC;
//   final dynamic? soCGain;
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
// class DataSource {
//   final bool transactionUsed;
//   final bool connectorMeterUsed;
//   final bool manualMeterUsed;
//   final String connectorMeterValue;
//   final String connectorMeterTime;

//   DataSource({
//     required this.transactionUsed,
//     required this.connectorMeterUsed,
//     required this.manualMeterUsed,
//     required this.connectorMeterValue,
//     required this.connectorMeterTime,
//   });

//   factory DataSource.fromJson(Map<String, dynamic> json) {
//     return DataSource(
//       transactionUsed: json['transactionUsed'] ?? false,
//       connectorMeterUsed: json['connectorMeterUsed'] ?? false,
//       manualMeterUsed: json['manualMeterUsed'] ?? false,
//       connectorMeterValue: json['connectorMeterValue'] ?? 'Not available',
//       connectorMeterTime: json['connectorMeterTime'] ?? '',
//     );
//   }
// }
// class WalletTransaction {
//   final String transactionId;
//   final dynamic previousBalance;
//   final dynamic amountDebited;
//   final dynamic newBalance;

//   WalletTransaction({
//     required this.transactionId,
//     required this.previousBalance,
//     required this.amountDebited,
//     required this.newBalance,
//   });

//   factory WalletTransaction.fromJson(Map<String, dynamic> json) {
//     return WalletTransaction(
//       transactionId: json['transactionId'] ?? '',
//       previousBalance: (json['previousBalance'] ?? 0).toDouble(),
//       amountDebited: (json['amountDebited'] ?? 0).toDouble(),
//       newBalance: (json['newBalance'] ?? 0).toDouble(),
//     );
//   }
// }

// // class EndChargingSessionResponse {
// //   final bool? success;
// //   final String? message;
// //   final EndChargingData? data;

// //   EndChargingSessionResponse({
// //     this.success,
// //     this.message,
// //     this.data,
// //   });

// //   factory EndChargingSessionResponse.fromJson(Map<String, dynamic> json) {
// //     return EndChargingSessionResponse(
// //       success: json['success'] as bool?,
// //       message: json['message'] as String?,
// //       data: json['data'] != null
// //           ? EndChargingData.fromJson(json['data'])
// //           : null,
// //     );
// //   }
// // }
// // class EndChargingData {
// //   final ChargingSession? session;
// //   final int? transactionId;
// //   final num? energyConsumed;
// //   final num? cost;
// //   final num? meterStart;
// //   final num? meterStop;
// //   final num? duration;
// //   final String? chargingSpeed;
// //   final DataSource? dataSource;
// //   final WalletTransaction? walletTransaction;

// //   EndChargingData({
// //     this.session,
// //     this.transactionId,
// //     this.energyConsumed,
// //     this.cost,
// //     this.meterStart,
// //     this.meterStop,
// //     this.duration,
// //     this.chargingSpeed,
// //     this.dataSource,
// //     this.walletTransaction,
// //   });

// //   factory EndChargingData.fromJson(Map<String, dynamic> json) {
// //     return EndChargingData(
// //       session: json['session'] != null
// //           ? ChargingSession.fromJson(json['session'])
// //           : null,
// //       transactionId: json['transactionId'],
// //       energyConsumed: json['energyConsumed'],
// //       cost: json['cost'],
// //       meterStart: json['meterStart'],
// //       meterStop: json['meterStop'],
// //       duration: json['duration'],
// //       chargingSpeed: json['chargingSpeed']?.toString(),
// //       dataSource: json['dataSource'] != null
// //           ? DataSource.fromJson(json['dataSource'])
// //           : null,
// //       walletTransaction: json['walletTransaction'] != null
// //           ? WalletTransaction.fromJson(json['walletTransaction'])
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
// // class DataSource {
// //   final bool? transactionUsed;
// //   final bool? connectorMeterUsed;
// //   final bool? manualMeterUsed;
// //   final String? connectorMeterValue;
// //   final String? connectorMeterTime;

// //   DataSource({
// //     this.transactionUsed,
// //     this.connectorMeterUsed,
// //     this.manualMeterUsed,
// //     this.connectorMeterValue,
// //     this.connectorMeterTime,
// //   });

// //   factory DataSource.fromJson(Map<String, dynamic> json) {
// //     return DataSource(
// //       transactionUsed: json['transactionUsed'],
// //       connectorMeterUsed: json['connectorMeterUsed'],
// //       manualMeterUsed: json['manualMeterUsed'],
// //       connectorMeterValue: json['connectorMeterValue'],
// //       connectorMeterTime: json['connectorMeterTime'],
// //     );
// //   }
// // }
// // class WalletTransaction {
// //   final String? transactionId;
// //   final num? previousBalance;
// //   final num? amountDebited;
// //   final num? newBalance;

// //   WalletTransaction({
// //     this.transactionId,
// //     this.previousBalance,
// //     this.amountDebited,
// //     this.newBalance,
// //   });

// //   factory WalletTransaction.fromJson(Map<String, dynamic> json) {
// //     return WalletTransaction(
// //       transactionId: json['transactionId'],
// //       previousBalance: json['previousBalance'],
// //       amountDebited: json['amountDebited'],
// //       newBalance: json['newBalance'],
// //     );
// //   }
// // }
