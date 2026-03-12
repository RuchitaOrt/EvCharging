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

  final dynamic? startMeterReading;
  final dynamic? endMeterReading;
  final dynamic? energyTransmitted;
  final dynamic? chargingSpeed;

  final DateTime? startTime;
  final DateTime? endTime;

  final dynamic? chargingTariff;
  final dynamic? chargingTotalFee;

  final String? status;
  final String? duration;

  final dynamic? energyLimit;
  final dynamic? costLimit;
  final dynamic? timeLimit;
  final dynamic? batteryIncreaseLimit;

  final dynamic? active;
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

  final String? addressLine1;
  final String? addressLine2;
  final String? addressLine3;
  final String? city;
  final String? state;
  final String? pincode;
  final String? chargingHubImage;

  final double? latitude;
  final double? longitude;

  final String? openingTime;
  final String? closingTime;

  final double? distanceKm;
  final int? stationCount;
  final double? averageRating;

  final int? active;
  final DateTime? createdOn;
  final DateTime? updatedOn;

  ChargingHub({
    this.recId,
    this.chargingHubName,
    this.addressLine1,
    this.addressLine2,
    this.addressLine3,
    this.city,
    this.state,
    this.pincode,
    this.chargingHubImage,
    this.latitude,
    this.longitude,
    this.openingTime,
    this.closingTime,
    this.distanceKm,
    this.stationCount,
    this.averageRating,
    this.active,
    this.createdOn,
    this.updatedOn,
  });

  factory ChargingHub.fromJson(Map<String, dynamic> json) {
    return ChargingHub(
      recId: json['recId'],
      chargingHubName: json['chargingHubName'],

      addressLine1: json['addressLine1'],
      addressLine2: json['addressLine2'],
      addressLine3: json['addressLine3'],
      city: json['city'],
      state: json['state'],
      pincode: json['pincode'],
      chargingHubImage: json['chargingHubImage'],

      latitude: _toDouble(json['latitude']),
      longitude: _toDouble(json['longitude']),

      openingTime: json['openingTime'],
      closingTime: json['closingTime'],

      distanceKm: _toDouble(json['distanceKm']),
      stationCount: json['stationCount'],
      averageRating: _toDouble(json['averageRating']),

      active: json['active'],
      createdOn: DateTime.tryParse(json['createdOn'] ?? ''),
      updatedOn: DateTime.tryParse(json['updatedOn'] ?? ''),
    );
  }
}

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