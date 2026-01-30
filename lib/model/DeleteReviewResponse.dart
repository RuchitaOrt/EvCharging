class DeleteReviewResponse {
  final bool success;
  final String message;
  final dynamic review; // 👈 API returns null

  DeleteReviewResponse({
    required this.success,
    required this.message,
    this.review,
  });

  factory DeleteReviewResponse.fromJson(Map<String, dynamic> json) {
    return DeleteReviewResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      review: json['review'], // null-safe
    );
  }
}
