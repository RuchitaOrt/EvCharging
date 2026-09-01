class UnifiedComprehensiveResponse {
  bool? success;
  String? message;
  List<Location>? locations;
  int? totalCount;
  int? page;
  int? pageSize;
  int? totalPages;

  UnifiedComprehensiveResponse({
    this.success,
    this.message,
    this.locations,
    this.totalCount,
    this.page,
    this.pageSize,
    this.totalPages,
  });

  UnifiedComprehensiveResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    totalCount = json['totalCount'];
    page = json['page'];
    pageSize = json['pageSize'];
    totalPages = json['totalPages'];

    if (json['locations'] != null) {
      locations = <Location>[];
      json['locations'].forEach((v) {
        locations!.add(Location.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    data['message'] = message;
    data['totalCount'] = totalCount;
    data['page'] = page;
    data['pageSize'] = pageSize;
    data['totalPages'] = totalPages;

    if (locations != null) {
      data['locations'] = locations!.map((e) => e.toJson()).toList();
    }

    return data;
  }
}

class Location {
  String? id;
  int? providerType;
  String? name;
  String? addressLine1;
  String? city;
  String? state;
  String? pincode;
  String? latitude;
  String? longitude;
  double? distanceKm;
  double? averageRating;
  int? totalStations;
  int? availableStations;
  int? totalConnectors;
  int? availableConnectors;
  String? partnerName;
  List<Station>? stations;

  Location({
    this.id,
    this.providerType,
    this.name,
    this.addressLine1,
    this.city,
    this.state,
    this.pincode,
    this.latitude,
    this.longitude,
    this.distanceKm,
    this.averageRating,
    this.totalStations,
    this.availableStations,
    this.totalConnectors,
    this.availableConnectors,
    this.partnerName,
    this.stations,
  });

  Location.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    providerType = json['providerType'];
    name = json['name'];
    addressLine1 = json['addressLine1'];
    city = json['city'];
    state = json['state'];
    pincode = json['pincode'];
    latitude = json['latitude']?.toString();
    longitude = json['longitude']?.toString();

    distanceKm = json['distanceKm'] == null
        ? null
        : (json['distanceKm'] as num).toDouble();

    averageRating = json['averageRating'] == null
        ? null
        : (json['averageRating'] as num).toDouble();

    totalStations = json['totalStations'];
    availableStations = json['availableStations'];
    totalConnectors = json['totalConnectors'];
    availableConnectors = json['availableConnectors'];
    partnerName = json['partnerName'];

    if (json['stations'] != null) {
      stations = <Station>[];
      json['stations'].forEach((v) {
        stations!.add(Station.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['providerType'] = providerType;
    data['name'] = name;
    data['addressLine1'] = addressLine1;
    data['city'] = city;
    data['state'] = state;
    data['pincode'] = pincode;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['distanceKm'] = distanceKm;
    data['averageRating'] = averageRating;
    data['totalStations'] = totalStations;
    data['availableStations'] = availableStations;
    data['totalConnectors'] = totalConnectors;
    data['availableConnectors'] = availableConnectors;
    data['partnerName'] = partnerName;

    if (stations != null) {
      data['stations'] = stations!.map((e) => e.toJson()).toList();
    }

    return data;
  }
}

class Station {
  String? id;
  int? providerType;
  String? name;
  int? totalConnectors;
  int? availableConnectors;
  List<Connector>? connectors;

  Station({
    this.id,
    this.providerType,
    this.name,
    this.totalConnectors,
    this.availableConnectors,
    this.connectors,
  });

  Station.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    providerType = json['providerType'];
    name = json['name'];
    totalConnectors = json['totalConnectors'];
    availableConnectors = json['availableConnectors'];

    if (json['connectors'] != null) {
      connectors = <Connector>[];
      json['connectors'].forEach((v) {
        connectors!.add(Connector.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['id'] = id;
    data['providerType'] = providerType;
    data['name'] = name;
    data['totalConnectors'] = totalConnectors;
    data['availableConnectors'] = availableConnectors;

    if (connectors != null) {
      data['connectors'] = connectors!.map((e) => e.toJson()).toList();
    }

    return data;
  }
}

class Connector {
  String? id;
  int? providerType;
  String? connectorId;
  String? chargerTypeName;
  String? powerOutput;
  String? tariff;
  String? status;
  String? lastUpdated;

  Connector({
    this.id,
    this.providerType,
    this.connectorId,
    this.chargerTypeName,
    this.powerOutput,
    this.tariff,
    this.status,
    this.lastUpdated,
  });

  Connector.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    providerType = json['providerType'];
    connectorId = json['connectorId'];
    chargerTypeName = json['chargerTypeName'];
    powerOutput = json['powerOutput']?.toString();
    tariff = json['tariff']?.toString();
    status = json['status'];
    lastUpdated = json['lastUpdated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['id'] = id;
    data['providerType'] = providerType;
    data['connectorId'] = connectorId;
    data['chargerTypeName'] = chargerTypeName;
    data['powerOutput'] = powerOutput;
    data['tariff'] = tariff;
    data['status'] = status;
    data['lastUpdated'] = lastUpdated;

    return data;
  }
}