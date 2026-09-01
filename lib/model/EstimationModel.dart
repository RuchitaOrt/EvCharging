class EstimationModel {
  final bool? success;
  final String? message;
  final EstimationData? data;

  EstimationModel({
    this.success,
    this.message,
    this.data,
  });

  factory EstimationModel.fromJson(Map<String, dynamic> json) {
    return EstimationModel(
      success: json["success"] as bool?,
      message: json["message"] as String?,
      data: json["data"] != null
          ? EstimationData.fromJson(json["data"])
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
class EstimationData {
  final int? providerType;
  final String? connectorId;
  final double? powerOutput;
  final double? estimatedEnergy;
  final double? estimatedTimeMinutes;
  final double? estimatedTimeHours;
  final double? estimatedKilometres;
  final double? estimatedBatteryIncrease;
  final double? estimatedCost;
  final double? estimatedCostWithTax;
  final String? costBasis;
  final String? currency;
  final RawData? raw;

  EstimationData({
    this.providerType,
    this.connectorId,
    this.powerOutput,
    this.estimatedEnergy,
    this.estimatedTimeMinutes,
    this.estimatedTimeHours,
    this.estimatedKilometres,
    this.estimatedBatteryIncrease,
    this.estimatedCost,
    this.estimatedCostWithTax,
    this.costBasis,
    this.currency,
    this.raw,
  });

  factory EstimationData.fromJson(Map<String, dynamic> json) {
    return EstimationData(
      providerType: json["providerType"],
      connectorId: json["connectorId"],
      powerOutput: (json["powerOutput"] as num?)?.toDouble(),
      estimatedEnergy: (json["estimatedEnergy"] as num?)?.toDouble(),
      estimatedTimeMinutes:
          (json["estimatedTimeMinutes"] as num?)?.toDouble(),
      estimatedTimeHours:
          (json["estimatedTimeHours"] as num?)?.toDouble(),
      estimatedKilometres:
          (json["estimatedKilometres"] as num?)?.toDouble(),
      estimatedBatteryIncrease:
          (json["estimatedBatteryIncrease"] as num?)?.toDouble(),
      estimatedCost: (json["estimatedCost"] as num?)?.toDouble(),
      estimatedCostWithTax:
          (json["estimatedCostWithTax"] as num?)?.toDouble(),
      costBasis: json["costBasis"],
      currency: json["currency"],
      raw: json["raw"] != null
          ? RawData.fromJson(json["raw"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "providerType": providerType,
      "connectorId": connectorId,
      "powerOutput": powerOutput,
      "estimatedEnergy": estimatedEnergy,
      "estimatedTimeMinutes": estimatedTimeMinutes,
      "estimatedTimeHours": estimatedTimeHours,
      "estimatedKilometres": estimatedKilometres,
      "estimatedBatteryIncrease": estimatedBatteryIncrease,
      "estimatedCost": estimatedCost,
      "estimatedCostWithTax": estimatedCostWithTax,
      "costBasis": costBasis,
      "currency": currency,
      "raw": raw?.toJson(),
    };
  }
}
class RawData {
  final bool? success;
  final String? message;
  final double? estimatedEnergy;
  final double? estimatedTimeMinutes;
  final double? estimatedTimeHours;
  final double? estimatedKilometres;
  final double? estimatedBatteryIncrease;
  final String? costBasis;
  final double? estimatedPartnerRatePerKwh;
  final double? estimatedPartnerCost;
  final double? estimatedPlatformFee;
  final double? estimatedCost;
  final double? estimatedCostWithTax;

  final Connector? connector;
  final Car? car;
  final CostDetails? costDetails;

  RawData({
    this.success,
    this.message,
    this.estimatedEnergy,
    this.estimatedTimeMinutes,
    this.estimatedTimeHours,
    this.estimatedKilometres,
    this.estimatedBatteryIncrease,
    this.costBasis,
    this.estimatedPartnerRatePerKwh,
    this.estimatedPartnerCost,
    this.estimatedPlatformFee,
    this.estimatedCost,
    this.estimatedCostWithTax,
    this.connector,
    this.car,
    this.costDetails,
  });

  factory RawData.fromJson(Map<String, dynamic> json) {
    return RawData(
      success: json["success"],
      message: json["message"],
      estimatedEnergy:
          (json["estimatedEnergy"] as num?)?.toDouble(),
      estimatedTimeMinutes:
          (json["estimatedTimeMinutes"] as num?)?.toDouble(),
      estimatedTimeHours:
          (json["estimatedTimeHours"] as num?)?.toDouble(),
      estimatedKilometres:
          (json["estimatedKilometres"] as num?)?.toDouble(),
      estimatedBatteryIncrease:
          (json["estimatedBatteryIncrease"] as num?)?.toDouble(),
      costBasis: json["costBasis"],
      estimatedPartnerRatePerKwh:
          (json["estimatedPartnerRatePerKwh"] as num?)?.toDouble(),
      estimatedPartnerCost:
          (json["estimatedPartnerCost"] as num?)?.toDouble(),
      estimatedPlatformFee:
          (json["estimatedPlatformFee"] as num?)?.toDouble(),
      estimatedCost:
          (json["estimatedCost"] as num?)?.toDouble(),
      estimatedCostWithTax:
          (json["estimatedCostWithTax"] as num?)?.toDouble(),
      connector: json["connector"] != null
          ? Connector.fromJson(json["connector"])
          : null,
      car: json["car"] != null
          ? Car.fromJson(json["car"])
          : null,
      costDetails: json["costDetails"] != null
          ? CostDetails.fromJson(json["costDetails"])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {};
}
class Connector {
  final double? powerOutput;
  final String? connectorId;
  final String? standard;
  final String? powerType;

  Connector({
    this.powerOutput,
    this.connectorId,
    this.standard,
    this.powerType,
  });

  factory Connector.fromJson(Map<String, dynamic> json) {
    return Connector(
      powerOutput: (json["powerOutput"] as num?)?.toDouble(),
      connectorId: json["connectorId"],
      standard: json["standard"],
      powerType: json["powerType"],
    );
  }

  Map<String, dynamic> toJson() => {};
}
class Car {
  final double? batteryCapacity;
  final double? efficiency;
  final double? currentBatteryPercentage;
  final double? chargingEfficiency;

  Car({
    this.batteryCapacity,
    this.efficiency,
    this.currentBatteryPercentage,
    this.chargingEfficiency,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      batteryCapacity:
          (json["batteryCapacity"] as num?)?.toDouble(),
      efficiency: (json["efficiency"] as num?)?.toDouble(),
      currentBatteryPercentage:
          (json["currentBatteryPercentage"] as num?)?.toDouble(),
      chargingEfficiency:
          (json["chargingEfficiency"] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {};
}
class CostDetails {
  final double? partnerCost;
  final double? platformFee;
  final double? taxAmount;
  final double? totalCost;
  final double? partnerRatePerKwh;
  final double? platformFeePerKwh;
  final String? currency;
  final double? cgst;
  final double? sgst;
  final String? costBasis;

  CostDetails({
    this.partnerCost,
    this.platformFee,
    this.taxAmount,
    this.totalCost,
    this.partnerRatePerKwh,
    this.platformFeePerKwh,
    this.currency,
    this.cgst,
    this.sgst,
    this.costBasis,
  });

  factory CostDetails.fromJson(Map<String, dynamic> json) {
    return CostDetails(
      partnerCost:
          (json["partnerCost"] as num?)?.toDouble(),
      platformFee:
          (json["platformFee"] as num?)?.toDouble(),
      taxAmount:
          (json["taxAmount"] as num?)?.toDouble(),
      totalCost:
          (json["totalCost"] as num?)?.toDouble(),
      partnerRatePerKwh:
          (json["partnerRatePerKwh"] as num?)?.toDouble(),
      platformFeePerKwh:
          (json["platformFeePerKwh"] as num?)?.toDouble(),
      currency: json["currency"],
      cgst: (json["cgst"] as num?)?.toDouble(),
      sgst: (json["sgst"] as num?)?.toDouble(),
      costBasis: json["costBasis"],
    );
  }

  Map<String, dynamic> toJson() => {};
}