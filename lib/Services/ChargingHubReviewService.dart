import 'package:ev_charging_app/Utils/APIManager.dart';
import 'package:ev_charging_app/model/AddReviewResponse.dart';
import 'package:ev_charging_app/model/ChargingHubReviewResponse.dart';
import 'package:ev_charging_app/model/DeleteReviewResponse.dart';
import 'package:flutter/material.dart';

class ChargingHubReviewService {
  Future<ChargingHubReviewResponse> getHubReviews(
    BuildContext context,
    String hubId,
  ) async {
    return await APIManager().apiRequest(
      context,
      API.chargingHubReviewList,
      path: "/$hubId",
    );
  }

   /// 🔥 ADD REVIEW
  Future<AddReviewResponse> addReview(
    BuildContext context, {
    required String chargingHubId,
    required String chargingStationId,
    required int rating,
    required String description,
    String? reviewImage1,
    String? reviewImage2,
    String? reviewImage3,
    String? reviewImage4,
  }) async {
    return await APIManager().apiRequest(
      context,
      API.chargingHubReviewAdd,
      
      jsonval: {
        "chargingHubId": chargingHubId,
        "chargingStationId": chargingStationId,
        "rating": rating,
        "description": description,
        "reviewImage1": reviewImage1 ?? "",
        "reviewImage2": reviewImage2 ?? "",
        "reviewImage3": reviewImage3 ?? "",
        "reviewImage4": reviewImage4 ?? "",
      },
    );
  }


  //update Review
   Future<AddReviewResponse> updateReview(
    BuildContext context, {
    required String chargingHubId,
    required String chargingStationId,
    required int rating,
    required String description,
    required String recId,
    String? reviewImage1,
    String? reviewImage2,
    String? reviewImage3,
    String? reviewImage4,
  }) async {
    return await APIManager().apiRequest(
      context,
      API.charginghubreviewupdate,
      
      jsonval: {
        "chargingHubId": chargingHubId,
        "chargingStationId": chargingStationId,
        "rating": rating,
        "description": description,
        "reviewImage1": reviewImage1 ?? "",
        "reviewImage2": reviewImage2 ?? "",
        "reviewImage3": reviewImage3 ?? "",
        "reviewImage4": reviewImage4 ?? "",
         "recId": recId ?? "",
      },
    );
  }


  // ✅ DELETE REVIEW
  Future<DeleteReviewResponse> deleteReview(
    BuildContext context,
    String reviewId,
  ) async {
    return await APIManager().apiRequest(
      context,
      API.charginghubreviewdelete,
      path: "/$reviewId",
    );
  }
}
