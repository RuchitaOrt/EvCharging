class PartnerSessionResponse {
  final bool success;
  final PartnerSessionData? data;

  PartnerSessionResponse({
    required this.success,
    this.data,
  });

  factory PartnerSessionResponse.fromJson(Map<String, dynamic> json) {
    return PartnerSessionResponse(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? PartnerSessionData.fromJson(json['data'])
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


class PartnerSessionData {
  final int totalCount;
  final int page;
  final int pageSize;
  final int totalPages;
  final List<PartnerSession> sessions;

  PartnerSessionData({
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.totalPages,
    required this.sessions,
  });


  factory PartnerSessionData.fromJson(Map<String, dynamic> json) {
    return PartnerSessionData(
      totalCount: json['totalCount'] ?? 0,
      page: json['page'] ?? 0,
      pageSize: json['pageSize'] ?? 0,
      totalPages: json['totalPages'] ?? 0,

      sessions: json['sessions'] != null
          ? List<PartnerSession>.from(
              json['sessions'].map(
                (x) => PartnerSession.fromJson(x),
              ),
            )
          : [],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      "totalCount": totalCount,
      "page": page,
      "pageSize": pageSize,
      "totalPages": totalPages,
      "sessions": sessions.map((e) => e.toJson()).toList(),
    };
  }
}



class PartnerSession {
  final String sessionId;
  final String status;

  final DateTime? startDateTime;
  final DateTime? endDateTime;

  final double? totalEnergyKwh;
  final double? totalCost;
  final double? totalPayable;

  final String currency;

  final int durationMinutes;

  final String? ocpiLocationId;
  final String? locationName;
  final String? locationCity;

  final int? partnerCredentialId;
  final String? partnerName;

  final String? evseUid;
  final String? connectorId;

  final String? userId;
  final String? userName;
  final String? userEmail;
  final String? userPhone;

  final String? invoiceNumber;


  PartnerSession({
    required this.sessionId,
    required this.status,
    this.startDateTime,
    this.endDateTime,
    this.totalEnergyKwh,
    this.totalCost,
    this.totalPayable,
    required this.currency,
    required this.durationMinutes,
    this.ocpiLocationId,
    this.locationName,
    this.locationCity,
    this.partnerCredentialId,
    this.partnerName,
    this.evseUid,
    this.connectorId,
    this.userId,
    this.userName,
    this.userEmail,
    this.userPhone,
    this.invoiceNumber,
  });



  factory PartnerSession.fromJson(Map<String, dynamic> json) {

    return PartnerSession(

      sessionId: json['sessionId'] ?? "",

      status: json['status'] ?? "",


      startDateTime: json['startDateTime'] != null
          ? DateTime.parse(json['startDateTime'])
          : null,


      endDateTime: json['endDateTime'] != null
          ? DateTime.parse(json['endDateTime'])
          : null,


      totalEnergyKwh: json['totalEnergyKwh'] != null
          ? (json['totalEnergyKwh'] as num).toDouble()
          : null,


      totalCost: json['totalCost'] != null
          ? (json['totalCost'] as num).toDouble()
          : null,


      totalPayable: json['totalPayable'] != null
          ? (json['totalPayable'] as num).toDouble()
          : null,


      currency: json['currency'] ?? "INR",


      durationMinutes: json['durationMinutes'] ?? 0,


      ocpiLocationId: json['ocpiLocationId'],

      locationName: json['locationName'],

      locationCity: json['locationCity'],


      partnerCredentialId: json['partnerCredentialId'],

      partnerName: json['partnerName'],


      evseUid: json['evseUid'],

      connectorId: json['connectorId'],


      userId: json['userId'],

      userName: json['userName'],

      userEmail: json['userEmail'],

      userPhone: json['userPhone'],


      invoiceNumber: json['invoiceNumber'],
    );
  }



  Map<String, dynamic> toJson() {

    return {

      "sessionId": sessionId,

      "status": status,


      "startDateTime": startDateTime?.toIso8601String(),

      "endDateTime": endDateTime?.toIso8601String(),


      "totalEnergyKwh": totalEnergyKwh,

      "totalCost": totalCost,

      "totalPayable": totalPayable,


      "currency": currency,

      "durationMinutes": durationMinutes,


      "ocpiLocationId": ocpiLocationId,

      "locationName": locationName,

      "locationCity": locationCity,


      "partnerCredentialId": partnerCredentialId,

      "partnerName": partnerName,


      "evseUid": evseUid,

      "connectorId": connectorId,


      "userId": userId,

      "userName": userName,

      "userEmail": userEmail,

      "userPhone": userPhone,


      "invoiceNumber": invoiceNumber,
    };
  }
}