// models/common_response.dart
class CommonResponse<T> {
  final bool success;
  final String message;
  final T? data;

  CommonResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory CommonResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) {
    return CommonResponse<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }
}
