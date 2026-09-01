class UnifiedGunStatusResponse {
  final bool? success;
  final String? message;
  final GunStatusData? data;

  UnifiedGunStatusResponse({
    this.success,
    this.message,
    this.data,
  });

  factory UnifiedGunStatusResponse.fromJson(Map<String, dynamic> json) {
    return UnifiedGunStatusResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? GunStatusData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class GunStatusData {
  final int? providerType;
  final bool? live;
  final ChargingGunStatus? status;

  GunStatusData({
    this.providerType,
    this.live,
    this.status,
  });

  factory GunStatusData.fromJson(Map<String, dynamic> json) {
    return GunStatusData(
      providerType: json['providerType'] as int?,
      live: json['live'] as bool?,
      status: json['status'] != null
          ? ChargingGunStatus.fromJson(json['status'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'providerType': providerType,
      'live': live,
      'status': status?.toJson(),
    };
  }
}

class ChargingGunStatus {
  final String? chargingGunId;
  final String? chargingStationId;
  final String? chargingStationName;
  final String? connectorId;
  final String? status;
  final String? currentSessionId;
  final DateTime? lastStatusUpdate;
  final bool? isAvailable;
  final bool? isOnline;
  final String? ocppStatus;
  final DateTime? lastOcppStatusTime;
  final double? lastMeter;
  final DateTime? lastMeterTime;

  ChargingGunStatus({
    this.chargingGunId,
    this.chargingStationId,
    this.chargingStationName,
    this.connectorId,
    this.status,
    this.currentSessionId,
    this.lastStatusUpdate,
    this.isAvailable,
    this.isOnline,
    this.ocppStatus,
    this.lastOcppStatusTime,
    this.lastMeter,
    this.lastMeterTime,
  });

  factory ChargingGunStatus.fromJson(Map<String, dynamic> json) {
    return ChargingGunStatus(
      chargingGunId: json['chargingGunId'] as String?,
      chargingStationId: json['chargingStationId'] as String?,
      chargingStationName: json['chargingStationName'] as String?,
      connectorId: json['connectorId']?.toString(),
      status: json['status'] as String?,
      currentSessionId: json['currentSessionId']?.toString(),
      lastStatusUpdate: json['lastStatusUpdate'] != null
          ? DateTime.tryParse(json['lastStatusUpdate'])
          : null,
      isAvailable: json['isAvailable'] as bool?,
      isOnline: json['isOnline'] as bool?,
      ocppStatus: json['ocppStatus'] as String?,
      lastOcppStatusTime: json['lastOcppStatusTime'] != null
          ? DateTime.tryParse(json['lastOcppStatusTime'])
          : null,
      lastMeter: json['lastMeter'] != null
          ? (json['lastMeter'] as num).toDouble()
          : null,
      lastMeterTime: json['lastMeterTime'] != null
          ? DateTime.tryParse(json['lastMeterTime'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chargingGunId': chargingGunId,
      'chargingStationId': chargingStationId,
      'chargingStationName': chargingStationName,
      'connectorId': connectorId,
      'status': status,
      'currentSessionId': currentSessionId,
      'lastStatusUpdate': lastStatusUpdate?.toIso8601String(),
      'isAvailable': isAvailable,
      'isOnline': isOnline,
      'ocppStatus': ocppStatus,
      'lastOcppStatusTime': lastOcppStatusTime?.toIso8601String(),
      'lastMeter': lastMeter,
      'lastMeterTime': lastMeterTime?.toIso8601String(),
    };
  }
}