class DeleteVehicleResponse {
  bool? success;
  String? message;
  dynamic user;

  DeleteVehicleResponse({
    this.success,
    this.message,
    this.user,
  });

  DeleteVehicleResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
      "user": user,
    };
  }
}