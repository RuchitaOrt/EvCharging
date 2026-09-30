class LocationStatusModel {
  final bool success;
  final String message;
  final LocationModel? location;

  // Kept for backward compatibility with your existing code.
  final List<LocationModel> locations;
  final int totalCount;
  final int page;
  final int pageSize;
  final int totalPages;

  LocationStatusModel({
    this.success = false,
    this.message = '',
    this.location,
    this.locations = const [],
    this.totalCount = 0,
    this.page = 0,
    this.pageSize = 0,
    this.totalPages = 0,
  });

  factory LocationStatusModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return LocationStatusModel();
    }

    /*
      Actual API response:

      {
        "success": true,
        "message": "...",
        "data": {
          "live": true,
          "fetchedAtUtc": "...",
          "location": {
            "id": "...",
            "name": "...",
            "address": "...",
            "city": "...",
            "latitude": "...",
            "longitude": "...",
            "lastUpdated": "...",
            "evses": [
              {
                "uid": "...",
                "evseId": "...",
                "status": "OutOfOrder",
                "physicalReference": "...",
                "connectors": [
                  {
                    "id": "...",
                    "standard": "...",
                    "format": "...",
                    "powerType": "...",
                    "maxVoltage": 400,
                    "maxAmperage": 0,
                    "maxElectricPower": 74
                  }
                ]
              }
            ]
          }
        }
      }
    */

    final Map<String, dynamic> data =
        json['data'] is Map<String, dynamic>
            ? json['data'] as Map<String, dynamic>
            : <String, dynamic>{};

    final Map<String, dynamic>? locationJson =
        data['location'] is Map<String, dynamic>
            ? data['location'] as Map<String, dynamic>
            : null;

    final LocationModel? location = locationJson != null
        ? LocationModel.fromJson(locationJson)
        : null;

    return LocationStatusModel(
      success: json['success'] ?? false,
      message: json['message']?.toString() ?? '',
      location: location,

      // Keep old fields populated so existing code
      // which uses response.locations does not crash.
      locations: location != null ? [location] : [],
      totalCount: location != null ? 1 : 0,
      page: 1,
      pageSize: 1,
      totalPages: location != null ? 1 : 0,
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;

    if (value is int) {
      return value;
    }

    return int.tryParse(value.toString()) ?? 0;
  }
}


// ============================================================
// LOCATION MODEL
// ============================================================

class LocationModel {
  final String id;
  final int providerType;
  final String name;
  final String addressLine1;
  final String city;
  final String state;
  final String pincode;
  final String latitude;
  final String longitude;

  final double? distanceKm;
  final double? averageRating;

  final int totalStations;
  final int availableStations;
  final int totalConnectors;
  final int availableConnectors;

  final String? partnerName;

  // Original station structure.
  // Kept so existing code does not break.
  final List<StationModel> stations;

  // Actual live-status API structure.
  final List<EvseModel> evses;

  LocationModel({
    this.id = '',
    this.providerType = 0,
    this.name = '',
    this.addressLine1 = '',
    this.city = '',
    this.state = '',
    this.pincode = '',
    this.latitude = '',
    this.longitude = '',
    this.distanceKm,
    this.averageRating,
    this.totalStations = 0,
    this.availableStations = 0,
    this.totalConnectors = 0,
    this.availableConnectors = 0,
    this.partnerName,
    this.stations = const [],
    this.evses = const [],
  });

  factory LocationModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return LocationModel();
    }

    return LocationModel(
      id: json['id']?.toString() ?? '',

      providerType: _toInt(json['providerType']),

      name: json['name']?.toString() ?? '',

      // API uses "address".
      // Your old model used "addressLine1".
      addressLine1:
          json['addressLine1']?.toString() ??
          json['address']?.toString() ??
          '',

      city: json['city']?.toString() ?? '',

      state: json['state']?.toString() ?? '',

      pincode: json['pincode']?.toString() ?? '',

      latitude: json['latitude']?.toString() ?? '',

      longitude: json['longitude']?.toString() ?? '',

      distanceKm: _toDouble(json['distanceKm']),

      averageRating: _toDouble(json['averageRating']),

      totalStations: _toInt(json['totalStations']),

      availableStations: _toInt(json['availableStations']),

      totalConnectors: _toInt(json['totalConnectors']),

      availableConnectors: _toInt(json['availableConnectors']),

      partnerName: json['partnerName']?.toString(),

      // Keep support for old response format if it is ever returned.
      stations: (json['stations'] as List?)
              ?.map(
                (e) => StationModel.fromJson(
                  e is Map<String, dynamic>
                      ? e
                      : <String, dynamic>{},
                ),
              )
              .toList() ??
          [],

      // New live-status API.
      evses: (json['evses'] as List?)
              ?.map(
                (e) => EvseModel.fromJson(
                  e is Map<String, dynamic>
                      ? e
                      : <String, dynamic>{},
                ),
              )
              .toList() ??
          [],
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;

    if (value is int) {
      return value;
    }

    return int.tryParse(value.toString()) ?? 0;
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;

    if (value is double) {
      return value;
    }

    if (value is int) {
      return value.toDouble();
    }

    return double.tryParse(value.toString());
  }
}


// ============================================================
// ORIGINAL STATION MODEL
// ============================================================

class StationModel {
  final String id;
  final int providerType;
  final String name;
  final int totalConnectors;
  final int availableConnectors;
  final List<Connector> connectors;

  StationModel({
    this.id = '',
    this.providerType = 0,
    this.name = '',
    this.totalConnectors = 0,
    this.availableConnectors = 0,
    this.connectors = const [],
  });

  factory StationModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return StationModel();
    }

    return StationModel(
      id: json['id']?.toString() ?? '',

      providerType: _toInt(json['providerType']),

      name: json['name']?.toString() ?? '',

      totalConnectors: _toInt(json['totalConnectors']),

      availableConnectors: _toInt(json['availableConnectors']),

      connectors: (json['connectors'] as List?)
              ?.map(
                (e) => Connector.fromJson(
                  e is Map<String, dynamic>
                      ? e
                      : <String, dynamic>{},
                ),
              )
              .toList() ??
          [],
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;

    if (value is int) {
      return value;
    }

    return int.tryParse(value.toString()) ?? 0;
  }
}


// ============================================================
// EVSE MODEL
// ============================================================

class EvseModel {
  final String uid;
  final String evseId;
  final String status;
  final String physicalReference;

  final List<LiveConnectorModel> connectors;

  EvseModel({
    this.uid = '',
    this.evseId = '',
    this.status = '',
    this.physicalReference = '',
    this.connectors = const [],
  });

  factory EvseModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return EvseModel();
    }

    return EvseModel(
      uid: json['uid']?.toString() ?? '',

      evseId: json['evseId']?.toString() ?? '',

      status: json['status']?.toString() ?? '',

      physicalReference:
          json['physicalReference']?.toString() ?? '',

      connectors: (json['connectors'] as List?)
              ?.map(
                (e) => LiveConnectorModel.fromJson(
                  e is Map<String, dynamic>
                      ? e
                      : <String, dynamic>{},
                ),
              )
              .toList() ??
          [],
    );
  }
}


// ============================================================
// LIVE CONNECTOR MODEL
// ============================================================

class LiveConnectorModel {
  final String id;
  final String standard;
  final String format;
  final String powerType;

  final dynamic maxVoltage;
  final dynamic maxAmperage;
  final dynamic maxElectricPower;

  LiveConnectorModel({
    this.id = '',
    this.standard = '',
    this.format = '',
    this.powerType = '',
    this.maxVoltage,
    this.maxAmperage,
    this.maxElectricPower,
  });

  factory LiveConnectorModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return LiveConnectorModel();
    }

    return LiveConnectorModel(
      id: json['id']?.toString() ?? '',

      standard: json['standard']?.toString() ?? '',

      format: json['format']?.toString() ?? '',

      powerType: json['powerType']?.toString() ?? '',

      maxVoltage: json['maxVoltage'],

      maxAmperage: json['maxAmperage'],

      maxElectricPower: json['maxElectricPower'],
    );
  }
}


// ============================================================
// ORIGINAL CONNECTOR MODEL
// ============================================================

class Connector {
  final String id;
  final int providerType;
  final String connectorId;
  final String chargerTypeName;
  final String powerOutput;
  final String tariff;
  final String status;
  final String lastUpdated;

  Connector({
    this.id = '',
    this.providerType = 0,
    this.connectorId = '',
    this.chargerTypeName = '',
    this.powerOutput = '',
    this.tariff = '',
    this.status = '',
    this.lastUpdated = '',
  });

  factory Connector.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Connector();
    }

    return Connector(
      id: json['id']?.toString() ?? '',

      providerType: _toInt(json['providerType']),

      connectorId:
          json['connectorId']?.toString() ?? '',

      chargerTypeName:
          json['chargerTypeName']?.toString() ?? '',

      powerOutput:
          json['powerOutput']?.toString() ?? '',

      tariff:
          json['tariff']?.toString() ?? '',

      status:
          json['status']?.toString() ?? '',

      lastUpdated:
          json['lastUpdated']?.toString() ?? '',
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;

    if (value is int) {
      return value;
    }

    return int.tryParse(value.toString()) ?? 0;
  }
}