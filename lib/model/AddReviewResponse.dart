class AddReviewResponse {
  final bool success;
  final String message;
  final Review? review;

  AddReviewResponse({
    required this.success,
    required this.message,
    this.review,
  });

  factory AddReviewResponse.fromJson(Map<String, dynamic> json) {
    return AddReviewResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      review:
          json['review'] != null ? Review.fromJson(json['review']) : null,
    );
  }
}

class Review {
  final String? recId;
  final String? chargingHubId;
  final String? chargingStationId;
  final int? rating;
  final String? description;
  final String? reviewTime;
  final String? reviewImage1;
  final String? reviewImage2;
  final String? reviewImage3;
  final String? reviewImage4;
  final String? createdOn;
  final String? updatedOn;
  final String? userName;
  final String? userProfileImage;

  Review({
    this.recId,
    this.chargingHubId,
    this.chargingStationId,
    this.rating,
    this.description,
    this.reviewTime,
    this.reviewImage1,
    this.reviewImage2,
    this.reviewImage3,
    this.reviewImage4,
    this.createdOn,
    this.updatedOn,
    this.userName,
    this.userProfileImage,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      recId: json['recId'],
      chargingHubId: json['chargingHubId'],
      chargingStationId: json['chargingStationId'],
      rating: json['rating'],
      description: json['description'],
      reviewTime: json['reviewTime'],
      reviewImage1: json['reviewImage1'],
      reviewImage2: json['reviewImage2'],
      reviewImage3: json['reviewImage3'],
      reviewImage4: json['reviewImage4'],
      createdOn: json['createdOn'],
      updatedOn: json['updatedOn'],
      userName: json['userName'],
      userProfileImage: json['userProfileImage'],
    );
  }
}
