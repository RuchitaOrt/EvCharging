class ResendOtpResponse {
  final bool success;
  final String message;
  final String? authId;
  final String? maskedPhoneNumber;
  final int? expiresInSeconds;

  ResendOtpResponse({
    required this.success,
    required this.message,
    this.authId,
    this.maskedPhoneNumber,
    this.expiresInSeconds,
  });

  factory ResendOtpResponse.fromJson(Map<String, dynamic>? json) {
    return ResendOtpResponse(
      success: json?['success'] ?? false,
      message: json?['message'] ?? "",
      authId: json?['authId'],
      maskedPhoneNumber: json?['maskedPhoneNumber'],
      expiresInSeconds: json?['expiresInSeconds'],
    );
  }
}
