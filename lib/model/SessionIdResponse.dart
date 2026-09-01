class SessionIdResponse {
  bool success;
  SessionIdData? data;

  SessionIdResponse({
    required this.success,
    this.data,
  });

  factory SessionIdResponse.fromJson(Map<String, dynamic> json) {
    return SessionIdResponse(
      success: json["success"] ?? false,
      data: json["data"] != null
          ? SessionIdData.fromJson(json["data"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "data": data?.toJson(),
    };
  }
}

class SessionIdData {
  String authorizationReference;
  String? sessionId;
  String status;
  bool resolved;

  SessionIdData({
    required this.authorizationReference,
    this.sessionId,
    required this.status,
    required this.resolved,
  });

  factory SessionIdData.fromJson(Map<String, dynamic> json) {
    return SessionIdData(
      authorizationReference: json["authorizationReference"] ?? "",
      sessionId: json["sessionId"],
      status: json["status"] ?? "",
      resolved: json["resolved"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "authorizationReference": authorizationReference,
      "sessionId": sessionId,
      "status": status,
      "resolved": resolved,
    };
  }
}

// class SessionIdResponse {
//   final bool? success;
//   final SessionIdData? data;

//   SessionIdResponse({
//     this.success,
//     this.data,
//   });

//   factory SessionIdResponse.fromJson(Map<String, dynamic> json) {
//     return SessionIdResponse(
//       success: json['success'] as bool?,
//       data: json['data'] != null
//           ? SessionIdData.fromJson(json['data'] as Map<String, dynamic>)
//           : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'success': success,
//       'data': data?.toJson(),
//     };
//   }
// }

// class SessionIdData {
//   final String? authorizationReference;
//   final String? sessionId;
//   final String? status;
//   final bool? resolved;

//   SessionIdData({
//     this.authorizationReference,
//     this.sessionId,
//     this.status,
//     this.resolved,
//   });

//   factory SessionIdData.fromJson(Map<String, dynamic> json) {
//     return SessionIdData(
//       authorizationReference: json['authorizationReference'] as String?,
//       sessionId: json['sessionId'] as String?,
//       status: json['status'] as String?,
//       resolved: json['resolved'] as bool?,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'authorizationReference': authorizationReference,
//       'sessionId': sessionId,
//       'status': status,
//       'resolved': resolved,
//     };
//   }
// }