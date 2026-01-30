// class ChargingGunStatusResponse {
//   final bool? success;
//   final String? message;
//   final ChargingGunStatusData? data;

//   ChargingGunStatusResponse({
//     this.success,
//     this.message,
//     this.data,
//   });

//   factory ChargingGunStatusResponse.fromJson(Map<String, dynamic> json) {
//     return ChargingGunStatusResponse(
//       success: json['success'],
//       message: json['message'],
//       data: json['data'] != null
//           ? ChargingGunStatusData.fromJson(json['data'])
//           : null,
//     );
//   }
// }

// class ChargingGunStatusData {
//   final String? chargingGunId;
//   final String? status;
//   final bool? isAvailable;
//   final String? lastStatusUpdate;
//   final String? currentSessionId;

//   ChargingGunStatusData({
//     this.chargingGunId,
//     this.status,
//     this.isAvailable,
//     this.lastStatusUpdate,
//     this.currentSessionId,
//   });

//   factory ChargingGunStatusData.fromJson(Map<String, dynamic> json) {
//     return ChargingGunStatusData(
//       chargingGunId: json['chargingGunId']?.toString(),
//       status: json['status'],
//       isAvailable: json['isAvailable'],
//       lastStatusUpdate: json['lastStatusUpdate'],
//       currentSessionId: json['currentSessionId'],
//     );
//   }
// }
class ChargingGunStatusResponse {
  final bool success;
  final String message;
  final ChargingGunStatusData? data;

  ChargingGunStatusResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ChargingGunStatusResponse.fromJson(Map<String, dynamic> json) {
    return ChargingGunStatusResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? ChargingGunStatusData.fromJson(json['data'])
          : null,
    );
  }
}

class ChargingGunStatusData {
  final String chargingGunId;
  final String? chargingStationId;
  final String? chargingStationName;
  final String status;
  final String? currentSessionId;
  final DateTime lastStatusUpdate;
  final bool isAvailable;

  ChargingGunStatusData({
    required this.chargingGunId,
    this.chargingStationId,
    this.chargingStationName,
    required this.status,
    this.currentSessionId,
    required this.lastStatusUpdate,
    required this.isAvailable,
  });

  factory ChargingGunStatusData.fromJson(Map<String, dynamic> json) {
    return ChargingGunStatusData(
      chargingGunId: json['chargingGunId'],
      chargingStationId: json['chargingStationId'],
      chargingStationName: json['chargingStationName'],
      status: json['status'],
      currentSessionId: json['currentSessionId'],
      lastStatusUpdate: DateTime.parse(json['lastStatusUpdate']),
      isAvailable: json['isAvailable'] ?? false,
    );
  }
}
