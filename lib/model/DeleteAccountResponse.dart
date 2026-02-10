class DeleteAccountResponse {
  final bool success;
  final String message;
  final dynamic user; // always null for delete

  DeleteAccountResponse({
    required this.success,
    required this.message,
    this.user,
  });

  factory DeleteAccountResponse.fromJson(Map<String, dynamic> json) {
    return DeleteAccountResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      user: json['user'], // can be null
    );
  }
}
