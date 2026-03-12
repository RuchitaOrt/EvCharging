import 'package:HyCharge/model/ChargingcomprehensiveHubResponse.dart';

class ChargerDetailsResponse {
  final bool? success;
  final String? message;
  final Charger? charger;

  ChargerDetailsResponse({this.success, this.message, this.charger});

  factory ChargerDetailsResponse.fromJson(Map<String, dynamic> json) {
    return ChargerDetailsResponse(
      success: json['success'],
      message: json['message'],
      charger:
          json['charger'] != null ? Charger.fromJson(json['charger']) : null,
    );
  }
}

// class Charger {
//   final String? recId;
//   final String? chargingStationId;
//   final String? chargingHubId;
//   final String? chargePointId;
//   final String? connectorId;
//   final String? chargerTypeId;
//   final String? chargerTypeName;
//   final String? chargerTariff;
//   final String? powerOutput;
//   final String? chargerStatus;
//   final String? connectorName;
//   final String? chargePointName;
//   final String? chargingHubName;

//   Charger({
//     this.recId,
//     this.chargingStationId,
//     this.chargingHubId,
//     this.chargePointId,
//     this.connectorId,
//     this.chargerTypeId,
//     this.chargerTypeName,
//     this.chargerTariff,
//     this.powerOutput,
//     this.chargerStatus,
//     this.connectorName,
//     this.chargePointName,
//     this.chargingHubName,
//   });

//   factory Charger.fromJson(Map<String, dynamic> json) {
//     return Charger(
//       recId: json['recId'],
//       chargingStationId: json['chargingStationId'],
//       chargingHubId: json['chargingHubId'],
//       chargePointId: json['chargePointId'],
//       connectorId: json['connectorId'],
//       chargerTypeId: json['chargerTypeId'],
//       chargerTypeName: json['chargerTypeName'],
//       chargerTariff: json['chargerTariff'],
//       powerOutput: json['powerOutput'],
//       chargerStatus: json['chargerStatus'],
//       connectorName: json['connectorName'],
//       chargePointName: json['chargePointName'],
//       chargingHubName: json['chargingHubName'],
//     );
//   }
// }