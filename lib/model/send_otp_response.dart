class SendOtpResponse {
  final bool success;
  final String message;
  final String? authId;
  final String? maskedPhoneNumber;
  final int? expiresInSeconds;

  SendOtpResponse({
    required this.success,
    required this.message,
    this.authId,
    this.maskedPhoneNumber,
    this.expiresInSeconds,
  });

  factory SendOtpResponse.fromJson(Map<String, dynamic>? json) {
    return SendOtpResponse(
      success: json?['success'] ?? false,
      message: json?['message'] ?? "",
      authId: json?['authId'],
      maskedPhoneNumber: json?['maskedPhoneNumber'],
      expiresInSeconds: json?['expiresInSeconds'],
    );
  }
}
