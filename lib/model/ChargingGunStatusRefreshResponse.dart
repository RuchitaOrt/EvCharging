// class ChargingGunStatusRefreshResponse {
//   final bool? success;
//   final String? message;
//   final ChargingGunStatusData? data;

//   ChargingGunStatusRefreshResponse({
//     this.success,
//     this.message,
//     this.data,
//   });

//   factory ChargingGunStatusRefreshResponse.fromJson(
//       Map<String, dynamic> json) {
//     return ChargingGunStatusRefreshResponse(
//       success: json['success'] as bool?,
//       message: json['message'] as String?,
//       data: json['data'] != null
//           ? ChargingGunStatusData.fromJson(json['data'])
//           : null,
//     );
//   }
// }
// class ChargingGunStatusData {
//   final String? chargingGunId;
//   final String? chargingStationId;
//   final String? chargingStationName;
//   final String? status;
//   final String? currentSessionId;
//   final String? lastStatusUpdate;
//   final bool? isAvailable;

//   ChargingGunStatusData({
//     this.chargingGunId,
//     this.chargingStationId,
//     this.chargingStationName,
//     this.status,
//     this.currentSessionId,
//     this.lastStatusUpdate,
//     this.isAvailable,
//   });

//   factory ChargingGunStatusData.fromJson(Map<String, dynamic> json) {
//     return ChargingGunStatusData(
//       chargingGunId: json['chargingGunId']?.toString(),
//       chargingStationId: json['chargingStationId'],
//       chargingStationName: json['chargingStationName'],
//       status: json['status'],
//       currentSessionId: json['currentSessionId'],
//       lastStatusUpdate: json['lastStatusUpdate'],
//       isAvailable: json['isAvailable'],
//     );
//   }
// }
