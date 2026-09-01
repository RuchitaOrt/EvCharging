class UnifiedSessionDetailResponse {
  final bool? success;
  final UnifiedSessionDetailData? data;

  UnifiedSessionDetailResponse({
    this.success,
    this.data,
  });

  factory UnifiedSessionDetailResponse.fromJson(Map<String, dynamic> json) {
    return UnifiedSessionDetailResponse(
      success: json["success"],
      data: json["data"] != null
          ? UnifiedSessionDetailData.fromJson(json["data"])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
      };
}

class UnifiedSessionDetailData {
  final String? sessionId;
  final String? status;
  final bool? isActive;
  final DateTime? startDateTime;
  final DateTime? endDateTime;
  final int? durationMinutes;
  final double? totalEnergyKwh;
  final double? totalCost;
  final double? totalPayable;
  final String? currency;
  final int? currentStateOfCharge;
  final DateTime? stateOfChargeLastUpdate;
  final UnifiedLocation? location;
  final UnifiedPartner? partner;
  final String? evseUid;
  final String? connectorId;
  final UnifiedUser? user;
  final double? energyLimit;
  final double? costLimit;
  final int? timeLimit;
  final int? batteryIncreaseLimit;
  final bool? limitViolationHandled;
  final String? invoiceNumber;
  final UnifiedCostDetails? costDetails;
  final UnifiedWalletTransaction? walletTransaction;

  UnifiedSessionDetailData({
    this.sessionId,
    this.status,
    this.isActive,
    this.startDateTime,
    this.endDateTime,
    this.durationMinutes,
    this.totalEnergyKwh,
    this.totalCost,
    this.totalPayable,
    this.currency,
    this.currentStateOfCharge,
    this.stateOfChargeLastUpdate,
    this.location,
    this.partner,
    this.evseUid,
    this.connectorId,
    this.user,
    this.energyLimit,
    this.costLimit,
    this.timeLimit,
    this.batteryIncreaseLimit,
    this.limitViolationHandled,
    this.invoiceNumber,
    this.costDetails,
    this.walletTransaction,
  });

  factory UnifiedSessionDetailData.fromJson(Map<String, dynamic> json) {
    return UnifiedSessionDetailData(
      sessionId: json["sessionId"],
      status: json["status"],
      isActive: json["isActive"],
      startDateTime: json["startDateTime"] != null
          ? DateTime.tryParse(json["startDateTime"])
          : null,
      endDateTime: json["endDateTime"] != null
          ? DateTime.tryParse(json["endDateTime"])
          : null,
      durationMinutes: json["durationMinutes"],
      totalEnergyKwh: (json["totalEnergyKwh"] as num?)?.toDouble(),
      totalCost: (json["totalCost"] as num?)?.toDouble(),
      totalPayable: (json["totalPayable"] as num?)?.toDouble(),
      currency: json["currency"],
      currentStateOfCharge: json["currentStateOfCharge"],
      stateOfChargeLastUpdate: json["stateOfChargeLastUpdate"] != null
          ? DateTime.tryParse(json["stateOfChargeLastUpdate"])
          : null,
      location: json["location"] != null
          ? UnifiedLocation.fromJson(json["location"])
          : null,
      partner: json["partner"] != null
          ? UnifiedPartner.fromJson(json["partner"])
          : null,
      evseUid: json["evseUid"],
      connectorId: json["connectorId"],
      user: json["user"] != null
          ? UnifiedUser.fromJson(json["user"])
          : null,
      energyLimit: (json["energyLimit"] as num?)?.toDouble(),
      costLimit: (json["costLimit"] as num?)?.toDouble(),
      timeLimit: json["timeLimit"],
      batteryIncreaseLimit: json["batteryIncreaseLimit"],
      limitViolationHandled: json["limitViolationHandled"],
      invoiceNumber: json["invoiceNumber"],
      costDetails: json["costDetails"] != null
          ? UnifiedCostDetails.fromJson(json["costDetails"])
          : null,
      walletTransaction: json["walletTransaction"] != null
          ? UnifiedWalletTransaction.fromJson(json["walletTransaction"])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "sessionId": sessionId,
        "status": status,
        "isActive": isActive,
        "startDateTime": startDateTime?.toIso8601String(),
        "endDateTime": endDateTime?.toIso8601String(),
        "durationMinutes": durationMinutes,
        "totalEnergyKwh": totalEnergyKwh,
        "totalCost": totalCost,
        "totalPayable": totalPayable,
        "currency": currency,
        "currentStateOfCharge": currentStateOfCharge,
        "stateOfChargeLastUpdate":
            stateOfChargeLastUpdate?.toIso8601String(),
        "location": location?.toJson(),
        "partner": partner?.toJson(),
        "evseUid": evseUid,
        "connectorId": connectorId,
        "user": user?.toJson(),
        "energyLimit": energyLimit,
        "costLimit": costLimit,
        "timeLimit": timeLimit,
        "batteryIncreaseLimit": batteryIncreaseLimit,
        "limitViolationHandled": limitViolationHandled,
        "invoiceNumber": invoiceNumber,
        "costDetails": costDetails?.toJson(),
        "walletTransaction": walletTransaction?.toJson(),
      };
}

class UnifiedLocation {
  final String? ocpiLocationId;
  final String? name;
  final String? address;
  final String? city;
  final String? country;

  UnifiedLocation({
    this.ocpiLocationId,
    this.name,
    this.address,
    this.city,
    this.country,
  });

  factory UnifiedLocation.fromJson(Map<String, dynamic> json) {
    return UnifiedLocation(
      ocpiLocationId: json["ocpiLocationId"],
      name: json["name"],
      address: json["address"],
      city: json["city"],
      country: json["country"],
    );
  }

  Map<String, dynamic> toJson() => {
        "ocpiLocationId": ocpiLocationId,
        "name": name,
        "address": address,
        "city": city,
        "country": country,
      };
}

class UnifiedPartner {
  final int? partnerCredentialId;
  final String? businessName;
  final String? countryCode;
  final String? partyId;

  UnifiedPartner({
    this.partnerCredentialId,
    this.businessName,
    this.countryCode,
    this.partyId,
  });

  factory UnifiedPartner.fromJson(Map<String, dynamic> json) {
    return UnifiedPartner(
      partnerCredentialId: json["partnerCredentialId"],
      businessName: json["businessName"],
      countryCode: json["countryCode"],
      partyId: json["partyId"],
    );
  }

  Map<String, dynamic> toJson() => {
        "partnerCredentialId": partnerCredentialId,
        "businessName": businessName,
        "countryCode": countryCode,
        "partyId": partyId,
      };
}

class UnifiedUser {
  final String? userId;
  final String? name;
  final String? email;
  final String? phone;

  UnifiedUser({
    this.userId,
    this.name,
    this.email,
    this.phone,
  });

  factory UnifiedUser.fromJson(Map<String, dynamic> json) {
    return UnifiedUser(
      userId: json["userId"],
      name: json["name"],
      email: json["email"],
      phone: json["phone"],
    );
  }

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "name": name,
        "email": email,
        "phone": phone,
      };
}

class UnifiedCostDetails {
  final double? partnerCost;
  final double? platformFeePerKwh;
  final double? taxableValue;
  final double? cgstRate;
  final double? cgstAmount;
  final double? sgstRate;
  final double? sgstAmount;
  final double? grandTotal;
  final double? totalPayable;
  final String? currency;

  UnifiedCostDetails({
    this.partnerCost,
    this.platformFeePerKwh,
    this.taxableValue,
    this.cgstRate,
    this.cgstAmount,
    this.sgstRate,
    this.sgstAmount,
    this.grandTotal,
    this.totalPayable,
    this.currency,
  });

  factory UnifiedCostDetails.fromJson(Map<String, dynamic> json) {
    return UnifiedCostDetails(
      partnerCost: (json["partnerCost"] as num?)?.toDouble(),
      platformFeePerKwh: (json["platformFeePerKwh"] as num?)?.toDouble(),
      taxableValue: (json["taxableValue"] as num?)?.toDouble(),
      cgstRate: (json["cgstRate"] as num?)?.toDouble(),
      cgstAmount: (json["cgstAmount"] as num?)?.toDouble(),
      sgstRate: (json["sgstRate"] as num?)?.toDouble(),
      sgstAmount: (json["sgstAmount"] as num?)?.toDouble(),
      grandTotal: (json["grandTotal"] as num?)?.toDouble(),
      totalPayable: (json["totalPayable"] as num?)?.toDouble(),
      currency: json["currency"],
    );
  }

  Map<String, dynamic> toJson() => {
        "partnerCost": partnerCost,
        "platformFeePerKwh": platformFeePerKwh,
        "taxableValue": taxableValue,
        "cgstRate": cgstRate,
        "cgstAmount": cgstAmount,
        "sgstRate": sgstRate,
        "sgstAmount": sgstAmount,
        "grandTotal": grandTotal,
        "totalPayable": totalPayable,
        "currency": currency,
      };
}

class UnifiedWalletTransaction {
  final String? recId;
  final String? additionalInfo1;
  final String? additionalInfo2;
  final String? additionalInfo3;
  final DateTime? createdOn;

  UnifiedWalletTransaction({
    this.recId,
    this.additionalInfo1,
    this.additionalInfo2,
    this.additionalInfo3,
    this.createdOn,
  });

  factory UnifiedWalletTransaction.fromJson(Map<String, dynamic> json) {
    return UnifiedWalletTransaction(
      recId: json["recId"],
      additionalInfo1: json["additionalInfo1"],
      additionalInfo2: json["additionalInfo2"],
      additionalInfo3: json["additionalInfo3"],
      createdOn: json["createdOn"] != null
          ? DateTime.tryParse(json["createdOn"])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "recId": recId,
        "additionalInfo1": additionalInfo1,
        "additionalInfo2": additionalInfo2,
        "additionalInfo3": additionalInfo3,
        "createdOn": createdOn?.toIso8601String(),
      };
}