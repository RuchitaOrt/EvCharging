class UnlockResponse {
  final bool success;
  final String? message;
  final UnlockData? data;

  UnlockResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory UnlockResponse.fromJson(Map<String, dynamic> json) {
    return UnlockResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'] != null
          ? UnlockData.fromJson(json['data'])
          : null,
    );
  }
}

class UnlockData {
  final String? chargingStationId;
  final int? connectorId;
  final String? chargePointId;
  final String? status;
  final List<String> cleanedSessions;
  final int? sessionsCleared;
  final List<String> warnings;

  UnlockData({
    this.chargingStationId,
    this.connectorId,
    this.chargePointId,
    this.status,
    required this.cleanedSessions,
    this.sessionsCleared,
    required this.warnings,
  });

  factory UnlockData.fromJson(Map<String, dynamic> json) {
    return UnlockData(
      chargingStationId: json['chargingStationId'],
      connectorId: json['connectorId'],
      chargePointId: json['chargePointId'],
      status: json['status'],
      cleanedSessions:
          List<String>.from(json['cleanedSessions'] ?? []),
      sessionsCleared: json['sessionsCleared'],
      warnings: List<String>.from(json['warnings'] ?? []),
    );
  }
}
