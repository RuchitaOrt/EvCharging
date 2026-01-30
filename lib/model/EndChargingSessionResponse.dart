class EndChargingSessionResponse {
  final bool? success;
  final String? message;
  final EndChargingData? data;

  EndChargingSessionResponse({
    this.success,
    this.message,
    this.data,
  });

  factory EndChargingSessionResponse.fromJson(Map<String, dynamic> json) {
    return EndChargingSessionResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? EndChargingData.fromJson(json['data'])
          : null,
    );
  }
}
class EndChargingData {
  final ChargingSession? session;
  final int? transactionId;
  final num? energyConsumed;
  final num? cost;
  final num? meterStart;
  final num? meterStop;
  final num? duration;
  final String? chargingSpeed;
  final DataSource? dataSource;
  final WalletTransaction? walletTransaction;

  EndChargingData({
    this.session,
    this.transactionId,
    this.energyConsumed,
    this.cost,
    this.meterStart,
    this.meterStop,
    this.duration,
    this.chargingSpeed,
    this.dataSource,
    this.walletTransaction,
  });

  factory EndChargingData.fromJson(Map<String, dynamic> json) {
    return EndChargingData(
      session: json['session'] != null
          ? ChargingSession.fromJson(json['session'])
          : null,
      transactionId: json['transactionId'],
      energyConsumed: json['energyConsumed'],
      cost: json['cost'],
      meterStart: json['meterStart'],
      meterStop: json['meterStop'],
      duration: json['duration'],
      chargingSpeed: json['chargingSpeed']?.toString(),
      dataSource: json['dataSource'] != null
          ? DataSource.fromJson(json['dataSource'])
          : null,
      walletTransaction: json['walletTransaction'] != null
          ? WalletTransaction.fromJson(json['walletTransaction'])
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
class DataSource {
  final bool? transactionUsed;
  final bool? connectorMeterUsed;
  final bool? manualMeterUsed;
  final String? connectorMeterValue;
  final String? connectorMeterTime;

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
      connectorMeterTime: json['connectorMeterTime'],
    );
  }
}
class WalletTransaction {
  final String? transactionId;
  final num? previousBalance;
  final num? amountDebited;
  final num? newBalance;

  WalletTransaction({
    this.transactionId,
    this.previousBalance,
    this.amountDebited,
    this.newBalance,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      transactionId: json['transactionId'],
      previousBalance: json['previousBalance'],
      amountDebited: json['amountDebited'],
      newBalance: json['newBalance'],
    );
  }
}

// class EndChargingSessionResponse {
//   final bool? success;
//   final String? message;
//   final EndChargingSessionData? data;

//   EndChargingSessionResponse({
//     this.success,
//     this.message,
//     this.data,
//   });

//   factory EndChargingSessionResponse.fromJson(Map<String, dynamic> json) {
//     return EndChargingSessionResponse(
//       success: json['success'],
//       message: json['message'],
//       data: json['data'] != null
//           ? EndChargingSessionData.fromJson(json['data'])
//           : null,
//     );
//   }
// }
// class EndChargingSessionData {
//   final ChargingSession? session;
//   final int? transactionId;
//   final num? energyConsumed;
//   final num? cost;
//   final num? meterStart;
//   final num? meterStop;
//   final num? duration;
//   final String? chargingSpeed;
//   final WalletTransaction? walletTransaction;

//   EndChargingSessionData({
//     this.session,
//     this.transactionId,
//     this.energyConsumed,
//     this.cost,
//     this.meterStart,
//     this.meterStop,
//     this.duration,
//     this.chargingSpeed,
//     this.walletTransaction,
//   });

//   factory EndChargingSessionData.fromJson(Map<String, dynamic> json) {
//     return EndChargingSessionData(
//       session: json['session'] != null
//           ? ChargingSession.fromJson(json['session'])
//           : null,
//       transactionId: json['transactionId'],
//       energyConsumed: json['energyConsumed'],
//       cost: json['cost'],
//       meterStart: json['meterStart'],
//       meterStop: json['meterStop'],
//       duration: json['duration'],
//       chargingSpeed: json['chargingSpeed'],
//       walletTransaction: json['walletTransaction'] != null
//           ? WalletTransaction.fromJson(json['walletTransaction'])
//           : null,
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
//     );
//   }
// }
// class WalletTransaction {
//   final String? transactionId;
//   final num? previousBalance;
//   final num? amountDebited;
//   final num? newBalance;

//   WalletTransaction({
//     this.transactionId,
//     this.previousBalance,
//     this.amountDebited,
//     this.newBalance,
//   });

//   factory WalletTransaction.fromJson(Map<String, dynamic> json) {
//     return WalletTransaction(
//       transactionId: json['transactionId'],
//       previousBalance: json['previousBalance'],
//       amountDebited: json['amountDebited'],
//       newBalance: json['newBalance'],
//     );
//   }
// }
