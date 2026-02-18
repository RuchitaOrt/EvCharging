class ForgetPasswordResponse {
  final bool? success;
  final String? message;
  final dynamic user; // can be null

  ForgetPasswordResponse({
    this.success,
    this.message,
    this.user,
  });

  factory ForgetPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgetPasswordResponse(
      success: json['success'],
      message: json['message'],
      user: json['user'], // safely handles null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
      "user": user,
    };
  }
}
