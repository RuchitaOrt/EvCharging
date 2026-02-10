class VerifyPaymentResponse {
  final bool success;
  final String message;
  final VerifyPaymentData? data;

  VerifyPaymentResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory VerifyPaymentResponse.fromJson(Map<String, dynamic> json) {
    return VerifyPaymentResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? VerifyPaymentData.fromJson(json['data'])
          : null,
    );
  }
}

class VerifyPaymentData {
  final String status;
  final String? message;

  VerifyPaymentData({
    required this.status,
    this.message,
  });

  factory VerifyPaymentData.fromJson(Map<String, dynamic> json) {
    return VerifyPaymentData(
      status: json['status'] ?? '',
      message: json['message'],
    );
  }
}
