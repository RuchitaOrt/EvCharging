class UploadResponse {
  final bool success;
  final String? fileId;
  final String? message;

  UploadResponse({
    required this.success,
    this.fileId,
    this.message,
  });

  factory UploadResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return UploadResponse(
        success: false,
        fileId: null,
        message: null,
      );
    }

    return UploadResponse(
      success: json['success'] ?? false,
      fileId: json['fileId'],
      message: json['message'],
    );
  }
}
