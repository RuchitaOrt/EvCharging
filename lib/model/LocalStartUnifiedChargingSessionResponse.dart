class LocalStartUnifiedChargingSessionResponse {
    bool success;
    String message;
    Data? data;

    LocalStartUnifiedChargingSessionResponse({
        required this.success,
        required this.message,
        required this.data,
    });
 factory LocalStartUnifiedChargingSessionResponse.fromJson(
          Map<String, dynamic> json) =>
      LocalStartUnifiedChargingSessionResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] != null ? Data.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
    String id;
    int providerType;
    String status;
    bool isActive;
    String startTime;
    dynamic endTime;
    double meterStart;
    dynamic meterCurrent;
    int energyDelivered;
    int cost;
    String currency;
    dynamic locationName;
    dynamic partnerName;
    String stationId;
    String connectorId;
    dynamic energyLimit;
    int costLimit;
    dynamic timeLimit;
    dynamic batteryIncreaseLimit;
    dynamic limitProgress;
    BatteryStateOfCharge? batteryStateOfCharge;
    dynamic walletTransaction;
    Raw? raw;

    Data({
        required this.id,
        required this.providerType,
        required this.status,
        required this.isActive,
        required this.startTime,
        required this.endTime,
        required this.meterStart,
        required this.meterCurrent,
        required this.energyDelivered,
        required this.cost,
        required this.currency,
        required this.locationName,
        required this.partnerName,
        required this.stationId,
        required this.connectorId,
        required this.energyLimit,
        required this.costLimit,
        required this.timeLimit,
        required this.batteryIncreaseLimit,
        required this.limitProgress,
        required this.batteryStateOfCharge,
        required this.walletTransaction,
        required this.raw,
    });
factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"] ?? "",
        providerType: json["providerType"] ?? 0,
        status: json["status"] ?? "",
        isActive: json["isActive"] ?? false,
        startTime: json["startTime"] ?? "",
        endTime: json["endTime"],
        meterStart: (json["meterStart"] ?? 0).toDouble(),
        meterCurrent: json["meterCurrent"],
        energyDelivered: json["energyDelivered"] ?? 0,
        cost: json["cost"] ?? 0,
        currency: json["currency"] ?? "",
        locationName: json["locationName"],
        partnerName: json["partnerName"],
        stationId: json["stationId"] ?? "",
        connectorId: json["connectorId"] ?? "",
        energyLimit: json["energyLimit"],
        costLimit: json["costLimit"] ?? 0,
        timeLimit: json["timeLimit"],
        batteryIncreaseLimit: json["batteryIncreaseLimit"],
        limitProgress: json["limitProgress"],
        batteryStateOfCharge: json["batteryStateOfCharge"] != null
            ? BatteryStateOfCharge.fromJson(json["batteryStateOfCharge"])
            : null,
        walletTransaction: json["walletTransaction"],
        raw: json["raw"] != null ? Raw.fromJson(json["raw"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "providerType": providerType,
        "status": status,
        "isActive": isActive,
        "startTime": startTime,
        "endTime": endTime,
        "meterStart": meterStart,
        "meterCurrent": meterCurrent,
        "energyDelivered": energyDelivered,
        "cost": cost,
        "currency": currency,
        "locationName": locationName,
        "partnerName": partnerName,
        "stationId": stationId,
        "connectorId": connectorId,
        "energyLimit": energyLimit,
        "costLimit": costLimit,
        "timeLimit": timeLimit,
        "batteryIncreaseLimit": batteryIncreaseLimit,
        "limitProgress": limitProgress,
        "batteryStateOfCharge": batteryStateOfCharge?.toJson(),
        "walletTransaction": walletTransaction,
        "raw": raw?.toJson(),
      };
}

class BatteryStateOfCharge {
    dynamic startSoC;
    dynamic endSoC;
    dynamic currentSoC;
    dynamic soCGain;
    dynamic lastUpdate;
    String unit;
    bool isRealtime;
    String dataSource;

    BatteryStateOfCharge({
        required this.startSoC,
        required this.endSoC,
        required this.currentSoC,
        required this.soCGain,
        required this.lastUpdate,
        required this.unit,
        required this.isRealtime,
        required this.dataSource,
    });
factory BatteryStateOfCharge.fromJson(Map<String, dynamic> json) =>
      BatteryStateOfCharge(
        startSoC: json["startSoC"],
        endSoC: json["endSoC"],
        currentSoC: json["currentSoC"],
        soCGain: json["soCGain"],
        lastUpdate: json["lastUpdate"],
        unit: json["unit"] ?? "",
        isRealtime: json["isRealtime"] ?? false,
        dataSource: json["dataSource"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "startSoC": startSoC,
        "endSoC": endSoC,
        "currentSoC": currentSoC,
        "soCGain": soCGain,
        "lastUpdate": lastUpdate,
        "unit": unit,
        "isRealtime": isRealtime,
        "dataSource": dataSource,
      };
}

class Raw {
    Session? session;
    int transactionId;
    double meterStart;
    String meterSource;
    String tariff;
    String startTime;
    BatteryStateOfCharge? batteryStateOfCharge;
    String recommendation;

    Raw({
        required this.session,
        required this.transactionId,
        required this.meterStart,
        required this.meterSource,
        required this.tariff,
        required this.startTime,
        required this.batteryStateOfCharge,
        required this.recommendation,
    });
factory Raw.fromJson(Map<String, dynamic> json) => Raw(
        session:
            json["session"] != null ? Session.fromJson(json["session"]) : null,
        transactionId: json["transactionId"] ?? 0,
        meterStart: (json["meterStart"] ?? 0).toDouble(),
        meterSource: json["meterSource"] ?? "",
        tariff: json["tariff"] ?? "",
        startTime: json["startTime"] ?? "",
        batteryStateOfCharge: json["batteryStateOfCharge"] != null
            ? BatteryStateOfCharge.fromJson(json["batteryStateOfCharge"])
            : null,
        recommendation: json["recommendation"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "session": session?.toJson(),
        "transactionId": transactionId,
        "meterStart": meterStart,
        "meterSource": meterSource,
        "tariff": tariff,
        "startTime": startTime,
        "batteryStateOfCharge": batteryStateOfCharge?.toJson(),
        "recommendation": recommendation,
      };
}

class Session {
    String recId;
    String chargingGunId;
    String connectorName;
    String chargingStationId;
    String chargingStationName;
    String chargingHubName;
    ChargingHub chargingHub;
    ChargingGun chargingGun;
    String startMeterReading;
    String endMeterReading;
    String energyTransmitted;
    String startTime;
    dynamic endTime;
    String chargingSpeed;
    String chargingTariff;
    String chargingTotalFee;
    String status;
    String duration;
    int active;
    DateTime createdOn;
    DateTime updatedOn;
    dynamic soCStart;
    dynamic soCEnd;
    dynamic soCLastUpdate;
    dynamic energyLimit;
    int costLimit;
    dynamic timeLimit;
    dynamic batteryIncreaseLimit;
    String userId;

    Session({
        required this.recId,
        required this.chargingGunId,
        required this.connectorName,
        required this.chargingStationId,
        required this.chargingStationName,
        required this.chargingHubName,
        required this.chargingHub,
        required this.chargingGun,
        required this.startMeterReading,
        required this.endMeterReading,
        required this.energyTransmitted,
        required this.startTime,
        required this.endTime,
        required this.chargingSpeed,
        required this.chargingTariff,
        required this.chargingTotalFee,
        required this.status,
        required this.duration,
        required this.active,
        required this.createdOn,
        required this.updatedOn,
        required this.soCStart,
        required this.soCEnd,
        required this.soCLastUpdate,
        required this.energyLimit,
        required this.costLimit,
        required this.timeLimit,
        required this.batteryIncreaseLimit,
        required this.userId,
    });
 factory Session.fromJson(Map<String, dynamic> json) => Session(
        recId: json["recId"] ?? "",
        chargingGunId: json["chargingGunId"] ?? "",
        connectorName: json["connectorName"] ?? "",
        chargingStationId: json["chargingStationId"] ?? "",
        chargingStationName: json["chargingStationName"] ?? "",
        chargingHubName: json["chargingHubName"] ?? "",
        chargingHub: json["chargingHub"] != null
            ? ChargingHub.fromJson(json["chargingHub"])
            : ChargingHub.empty(),
        chargingGun: json["chargingGun"] != null
            ? ChargingGun.fromJson(json["chargingGun"])
            : ChargingGun.empty(),
        startMeterReading: json["startMeterReading"] ?? "",
        endMeterReading: json["endMeterReading"] ?? "",
        energyTransmitted: json["energyTransmitted"] ?? "",
        startTime: json["startTime"] ?? "",
        endTime: json["endTime"],
        chargingSpeed: json["chargingSpeed"] ?? "",
        chargingTariff: json["chargingTariff"] ?? "",
        chargingTotalFee: json["chargingTotalFee"] ?? "",
        status: json["status"] ?? "",
        duration: json["duration"] ?? "",
        active: json["active"] ?? 0,
        createdOn: DateTime.tryParse(json["createdOn"] ?? "") ?? DateTime.now(),
        updatedOn: DateTime.tryParse(json["updatedOn"] ?? "") ?? DateTime.now(),
        soCStart: json["soCStart"],
        soCEnd: json["soCEnd"],
        soCLastUpdate: json["soCLastUpdate"],
        energyLimit: json["energyLimit"],
        costLimit: json["costLimit"] ?? 0,
        timeLimit: json["timeLimit"],
        batteryIncreaseLimit: json["batteryIncreaseLimit"],
        userId: json["userId"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "recId": recId,
        "chargingGunId": chargingGunId,
        "connectorName": connectorName,
        "chargingStationId": chargingStationId,
        "chargingStationName": chargingStationName,
        "chargingHubName": chargingHubName,
        "chargingHub": chargingHub.toJson(),
        "chargingGun": chargingGun.toJson(),
        "startMeterReading": startMeterReading,
        "endMeterReading": endMeterReading,
        "energyTransmitted": energyTransmitted,
        "startTime": startTime,
        "endTime": endTime,
        "chargingSpeed": chargingSpeed,
        "chargingTariff": chargingTariff,
        "chargingTotalFee": chargingTotalFee,
        "status": status,
        "duration": duration,
        "active": active,
        "createdOn": createdOn.toIso8601String(),
        "updatedOn": updatedOn.toIso8601String(),
        "soCStart": soCStart,
        "soCEnd": soCEnd,
        "soCLastUpdate": soCLastUpdate,
        "energyLimit": energyLimit,
        "costLimit": costLimit,
        "timeLimit": timeLimit,
        "batteryIncreaseLimit": batteryIncreaseLimit,
        "userId": userId,
      };
}

class ChargingGun {
    String recId;
    String chargingStationId;
    String connectorId;
    String chargingHubId;
    String chargerTypeId;
    String chargerTariff;
    String powerOutput;
    String chargerStatus;
    String chargerMeterReading;
    String additionalInfo1;
    String additionalInfo2;
    int active;
    String createdOn;
    String updatedOn;

    ChargingGun({
        required this.recId,
        required this.chargingStationId,
        required this.connectorId,
        required this.chargingHubId,
        required this.chargerTypeId,
        required this.chargerTariff,
        required this.powerOutput,
        required this.chargerStatus,
        required this.chargerMeterReading,
        required this.additionalInfo1,
        required this.additionalInfo2,
        required this.active,
        required this.createdOn,
        required this.updatedOn,
    });
factory ChargingGun.fromJson(Map<String, dynamic> json) => ChargingGun(
      recId: json["recId"] ?? "",
      chargingStationId: json["chargingStationId"] ?? "",
      connectorId: json["connectorId"] ?? "",
      chargingHubId: json["chargingHubId"] ?? "",
      chargerTypeId: json["chargerTypeId"] ?? "",
      chargerTariff: json["chargerTariff"] ?? "",
      powerOutput: json["powerOutput"] ?? "",
      chargerStatus: json["chargerStatus"] ?? "",
      chargerMeterReading: json["chargerMeterReading"] ?? "",
      additionalInfo1: json["additionalInfo1"] ?? "",
      additionalInfo2: json["additionalInfo2"] ?? "",
      active: json["active"] ?? 0,
      createdOn: json["createdOn"] ?? "",
      updatedOn: json["updatedOn"] ?? "",
    );

Map<String, dynamic> toJson() => {
      "recId": recId,
      "chargingStationId": chargingStationId,
      "connectorId": connectorId,
      "chargingHubId": chargingHubId,
      "chargerTypeId": chargerTypeId,
      "chargerTariff": chargerTariff,
      "powerOutput": powerOutput,
      "chargerStatus": chargerStatus,
      "chargerMeterReading": chargerMeterReading,
      "additionalInfo1": additionalInfo1,
      "additionalInfo2": additionalInfo2,
      "active": active,
      "createdOn": createdOn,
      "updatedOn": updatedOn,
    };

factory ChargingGun.empty() => ChargingGun(
      recId: "",
      chargingStationId: "",
      connectorId: "",
      chargingHubId: "",
      chargerTypeId: "",
      chargerTariff: "",
      powerOutput: "",
      chargerStatus: "",
      chargerMeterReading: "",
      additionalInfo1: "",
      additionalInfo2: "",
      active: 0,
      createdOn: "",
      updatedOn: "",
    );
}

class ChargingHub {
    String recId;
    String chargingHubName;
    dynamic addressLine1;
    dynamic addressLine2;
    dynamic addressLine3;
    dynamic chargingHubImage;
    dynamic city;
    dynamic state;
    dynamic pincode;
    String latitude;
    dynamic longitude;
    String openingTime;
    String closingTime;
    dynamic typeATariff;
    dynamic typeBTariff;
    dynamic amenities;
    dynamic additionalInfo1;
    dynamic additionalInfo2;
    dynamic additionalInfo3;
    int active;
    String createdOn;
    String updatedOn;
    dynamic distanceKm;
    int stationCount;
    dynamic averageRating;

    ChargingHub({
        required this.recId,
        required this.chargingHubName,
        required this.addressLine1,
        required this.addressLine2,
        required this.addressLine3,
        required this.chargingHubImage,
        required this.city,
        required this.state,
        required this.pincode,
        required this.latitude,
        required this.longitude,
        required this.openingTime,
        required this.closingTime,
        required this.typeATariff,
        required this.typeBTariff,
        required this.amenities,
        required this.additionalInfo1,
        required this.additionalInfo2,
        required this.additionalInfo3,
        required this.active,
        required this.createdOn,
        required this.updatedOn,
        required this.distanceKm,
        required this.stationCount,
        required this.averageRating,
    });
factory ChargingHub.fromJson(Map<String, dynamic> json) => ChargingHub(
      recId: json["recId"] ?? "",
      chargingHubName: json["chargingHubName"] ?? "",
      addressLine1: json["addressLine1"],
      addressLine2: json["addressLine2"],
      addressLine3: json["addressLine3"],
      chargingHubImage: json["chargingHubImage"],
      city: json["city"],
      state: json["state"],
      pincode: json["pincode"],
      latitude: json["latitude"] ?? "",
      longitude: json["longitude"],
      openingTime: json["openingTime"] ?? "",
      closingTime: json["closingTime"] ?? "",
      typeATariff: json["typeATariff"],
      typeBTariff: json["typeBTariff"],
      amenities: json["amenities"],
      additionalInfo1: json["additionalInfo1"],
      additionalInfo2: json["additionalInfo2"],
      additionalInfo3: json["additionalInfo3"],
      active: json["active"] ?? 0,
      createdOn: json["createdOn"] ?? "",
      updatedOn: json["updatedOn"] ?? "",
      distanceKm: json["distanceKm"],
      stationCount: json["stationCount"] ?? 0,
      averageRating: json["averageRating"],
    );

Map<String, dynamic> toJson() => {
      "recId": recId,
      "chargingHubName": chargingHubName,
      "addressLine1": addressLine1,
      "addressLine2": addressLine2,
      "addressLine3": addressLine3,
      "chargingHubImage": chargingHubImage,
      "city": city,
      "state": state,
      "pincode": pincode,
      "latitude": latitude,
      "longitude": longitude,
      "openingTime": openingTime,
      "closingTime": closingTime,
      "typeATariff": typeATariff,
      "typeBTariff": typeBTariff,
      "amenities": amenities,
      "additionalInfo1": additionalInfo1,
      "additionalInfo2": additionalInfo2,
      "additionalInfo3": additionalInfo3,
      "active": active,
      "createdOn": createdOn,
      "updatedOn": updatedOn,
      "distanceKm": distanceKm,
      "stationCount": stationCount,
      "averageRating": averageRating,
    };

factory ChargingHub.empty() => ChargingHub(
      recId: "",
      chargingHubName: "",
      addressLine1: null,
      addressLine2: null,
      addressLine3: null,
      chargingHubImage: null,
      city: null,
      state: null,
      pincode: null,
      latitude: "",
      longitude: null,
      openingTime: "",
      closingTime: "",
      typeATariff: null,
      typeBTariff: null,
      amenities: null,
      additionalInfo1: null,
      additionalInfo2: null,
      additionalInfo3: null,
      active: 0,
      createdOn: "",
      updatedOn: "",
      distanceKm: null,
      stationCount: 0,
      averageRating: null,
    );
}
