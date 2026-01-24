class LogoutResponse {
  final bool success;
  final String message;
  final dynamic user; // always null as per API

  LogoutResponse({
    required this.success,
    required this.message,
    this.user,
  });

  factory LogoutResponse.fromJson(Map<String, dynamic> json) {
    return LogoutResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      user: json['user'], // safely handles null
    );

  }

  @override
  String toString() {
    return 'LogoutResponse(success: $success, message: $message)';
  }
}
