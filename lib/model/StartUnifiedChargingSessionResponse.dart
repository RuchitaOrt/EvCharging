class StartUnifiedChargingSessionResponse {
  final bool success;
  final String? message;
  final StartUnifiedChargingSessionData? data;

  StartUnifiedChargingSessionResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory StartUnifiedChargingSessionResponse.fromJson(
      Map<String, dynamic> json) {
    return StartUnifiedChargingSessionResponse(
      success: json['success'] ?? false,
      message: json['message'] as String?,
      data: json['data'] != null
          ? StartUnifiedChargingSessionData.fromJson(
              json['data'] as Map<String, dynamic>,
            )
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

class StartUnifiedChargingSessionData {
  final int? providerType;
  final String? connectorId;
  final PartnerRawResponse? raw;

  StartUnifiedChargingSessionData({
    this.providerType,
    this.connectorId,
    this.raw,
  });

  factory StartUnifiedChargingSessionData.fromJson(
      Map<String, dynamic> json) {
    return StartUnifiedChargingSessionData(
      providerType: json['providerType'] as int?,
      connectorId: json['connectorId'] as String?,
      raw: json['raw'] != null
          ? PartnerRawResponse.fromJson(
              json['raw'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'providerType': providerType,
      'connectorId': connectorId,
      'raw': raw?.toJson(),
    };
  }
}

class PartnerRawResponse {
  final bool? success;
  final String? result;
  final String? authorizationReference;
  final String? status;
  final String? message;

  PartnerRawResponse({
    this.success,
    this.result,
    this.authorizationReference,
    this.status,
    this.message,
  });

  factory PartnerRawResponse.fromJson(
      Map<String, dynamic> json) {
    return PartnerRawResponse(
      success: json['success'] as bool?,
      result: json['result'] as String?,
      authorizationReference:
          json['authorizationReference'] as String?,
      status: json['status'] as String?,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'result': result,
      'authorizationReference': authorizationReference,
      'status': status,
      'message': message,
    };
  }
}