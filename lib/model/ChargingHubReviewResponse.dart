class ChargingHubReviewResponse {
  final bool success;
  final String message;
  final List<ChargingHubReview> reviews;
  final int totalCount;
  final double averageRating;

  ChargingHubReviewResponse({
    required this.success,
    required this.message,
    required this.reviews,
    required this.totalCount,
    required this.averageRating,
  });

  factory ChargingHubReviewResponse.fromJson(Map<String, dynamic> json) {
    return ChargingHubReviewResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      reviews: (json['reviews'] as List<dynamic>?)
              ?.map((e) => ChargingHubReview.fromJson(e))
              .toList() ??
          [],
      totalCount: json['totalCount'] ?? 0,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
class ChargingHubReview {
  final String recId;
  final String chargingHubId;
  final String chargingStationId;
  final int rating;
  final String description;
  final DateTime? reviewTime;
  final String reviewImage1;
  final String reviewImage2;
  final String reviewImage3;
  final String reviewImage4;
  final DateTime? createdOn;
  final DateTime? updatedOn;
  final String userName;
  final String userProfileImage;

  ChargingHubReview({
    required this.recId,
    required this.chargingHubId,
    required this.chargingStationId,
    required this.rating,
    required this.description,
    required this.reviewTime,
    required this.reviewImage1,
    required this.reviewImage2,
    required this.reviewImage3,
    required this.reviewImage4,
    required this.createdOn,
    required this.updatedOn,
    required this.userName,
    required this.userProfileImage,
  });

  factory ChargingHubReview.fromJson(Map<String, dynamic> json) {
    return ChargingHubReview(
      recId: json['recId'] ?? '',
      chargingHubId: json['chargingHubId'] ?? '',
      chargingStationId: json['chargingStationId'] ?? '',
      rating: json['rating'] ?? 0,
      description: json['description'] ?? '',
      reviewTime: json['reviewTime'] != null
          ? DateTime.tryParse(json['reviewTime'])
          : null,
      reviewImage1: json['reviewImage1'] ?? '',
      reviewImage2: json['reviewImage2'] ?? '',
      reviewImage3: json['reviewImage3'] ?? '',
      reviewImage4: json['reviewImage4'] ?? '',
      createdOn: json['createdOn'] != null
          ? DateTime.tryParse(json['createdOn'])
          : null,
      updatedOn: json['updatedOn'] != null
          ? DateTime.tryParse(json['updatedOn'])
          : null,
      userName: json['userName'] ?? 'Anonymous',
      userProfileImage: json['userProfileImage'] ?? '',
    );
  }
}
