class EndUnifiedChargingSessionResponse {
  final bool? success;
  final String? message;
  final EndSessionData? data;

  EndUnifiedChargingSessionResponse({
    this.success,
    this.message,
    this.data,
  });

  factory EndUnifiedChargingSessionResponse.fromJson(
      Map<String, dynamic>? json) {
    if (json == null) {
      return EndUnifiedChargingSessionResponse();
    }

    return EndUnifiedChargingSessionResponse(
      success: json["success"],
      message: json["message"],
      data: json["data"] != null
          ? EndSessionData.fromJson(json["data"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
      "data": data?.toJson(),
    };
  }
}

class EndSessionData {
  final int? providerType;
  final String? sessionId;
  final EndSessionRaw? raw;

  EndSessionData({
    this.providerType,
    this.sessionId,
    this.raw,
  });

  factory EndSessionData.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return EndSessionData();
    }

    return EndSessionData(
      providerType: json["providerType"],
      sessionId: json["sessionId"],
      raw: json["raw"] != null
          ? EndSessionRaw.fromJson(json["raw"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "providerType": providerType,
      "sessionId": sessionId,
      "raw": raw?.toJson(),
    };
  }
}

class EndSessionRaw {
  final bool? success;
  final String? result;
  final String? sessionId;
  final String? message;

  EndSessionRaw({
    this.success,
    this.result,
    this.sessionId,
    this.message,
  });

  factory EndSessionRaw.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return EndSessionRaw();
    }

    return EndSessionRaw(
      success: json["success"],
      result: json["result"],
      sessionId: json["sessionId"],
      message: json["message"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "result": result,
      "sessionId": sessionId,
      "message": message,
    };
  }
}