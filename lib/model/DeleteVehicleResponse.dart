class DeleteVehicleResponse {
  final bool success;
  final String message;

  DeleteVehicleResponse({
    required this.success,
    required this.message,
  });

  factory DeleteVehicleResponse.fromJson(Map<String, dynamic> json) {
    return DeleteVehicleResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
