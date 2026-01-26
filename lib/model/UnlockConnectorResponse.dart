class UnlockConnectorResponse {
  bool success;
  String message;
  UnlockConnectorData? data;

  UnlockConnectorResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory UnlockConnectorResponse.fromJson(Map<String, dynamic> json) {
    return UnlockConnectorResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? UnlockConnectorData.fromJson(json['data'])
          : null,
    );
  }
}

class UnlockConnectorData {
  String? chargingStationId;
  int? connectorId;
  bool? unlocked;
  String? updatedAt;

  UnlockConnectorData({
    this.chargingStationId,
    this.connectorId,
    this.unlocked,
    this.updatedAt,
  });

  factory UnlockConnectorData.fromJson(Map<String, dynamic> json) {
    return UnlockConnectorData(
      chargingStationId: json['chargingStationId'],
      connectorId: json['connectorId'],
      unlocked: json['unlocked'],
      updatedAt: json['updatedAt'],
    );
  }
}
