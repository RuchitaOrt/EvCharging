class ResetPasswordResponse {
  final bool success;
  final String message;
  final dynamic user; // null as per API

  ResetPasswordResponse({
    required this.success,
    required this.message,
    this.user,
  });

  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      user: json['user'],
    );
  }
}
