class RazorpayKeyResponse {
  final bool success;
  final String? message;
  final RazorpayKeyData? data;

  RazorpayKeyResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory RazorpayKeyResponse.fromJson(Map<String, dynamic> json) {
    return RazorpayKeyResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'] != null
          ? RazorpayKeyData.fromJson(json['data'])
          : null,
    );
  }
}

class RazorpayKeyData {
  final String? key;

  RazorpayKeyData({this.key});

  factory RazorpayKeyData.fromJson(Map<String, dynamic> json) {
    return RazorpayKeyData(
      key: json['key'],
    );
  }
}
