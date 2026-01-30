import 'package:ev_charging_app/Services/ChargingHubReviewService.dart';
import 'package:ev_charging_app/Utils/ShowDialog.dart';
import 'package:ev_charging_app/model/AddReviewResponse.dart';
import 'package:ev_charging_app/model/ChargingHubReviewResponse.dart';
import 'package:ev_charging_app/model/DeleteReviewResponse.dart';
import 'package:flutter/material.dart';

class ChargingHubReviewProvider extends ChangeNotifier {
  final ChargingHubReviewService _service = ChargingHubReviewService();

  bool loading = false;
  ChargingHubReviewResponse? response;

  Future<ChargingHubReviewResponse?> fetchReviews({
    required BuildContext context,
    required String hubId,
  }) async {
    loading = true;
    notifyListeners();

    try {
      final res = await _service.getHubReviews(context, hubId);
      response = res;

      if (!res.success) {
        showToast(res.message);
      }

      return res;
    } catch (e) {
      showToast(e.toString());
      return null;
    } finally {
      loading = false;
      notifyListeners();
    }
  }
  /// 🔥 ADD REVIEW PROVIDER METHOD
  Future<AddReviewResponse?> addReview({
    required BuildContext context,
    required String chargingHubId,
    required String chargingStationId,
    required int rating,
    required String description,
    String? reviewImage1,
    String? reviewImage2,
    String? reviewImage3,
    String? reviewImage4,
  }) async {
    loading = true;
    notifyListeners();

    try {
      final res = await _service.addReview(
        context,
        chargingHubId: chargingHubId,
        chargingStationId: chargingStationId,
        rating: rating,
        description: description,
        reviewImage1: reviewImage1,
        reviewImage2: reviewImage2,
        reviewImage3: reviewImage3,
        reviewImage4: reviewImage4,
      );

      if (res.success) {
        showToast(res.message);

        /// 🔁 refresh list after add
        await fetchReviews(
          context: context,
          hubId: chargingHubId,
        );
      } else {
        showToast(res.message);
      }

      return res;
    } catch (e) {
      showToast("Failed to add review");
      return null;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

   Future<AddReviewResponse?> updateReview({
    required BuildContext context,
    required String chargingHubId,
    required String chargingStationId,
    required int rating,
    required String description,
    String? reviewImage1,
    String? reviewImage2,
    String? reviewImage3,
    String? reviewImage4,
    required String recId,
  }) async {
    loading = true;
    notifyListeners();

    try {
      final res = await _service.updateReview(
        context,
        chargingHubId: chargingHubId,
        chargingStationId: chargingStationId,
        rating: rating,
        description: description,
        reviewImage1: reviewImage1,
        reviewImage2: reviewImage2,
        reviewImage3: reviewImage3,
        reviewImage4: reviewImage4,
        recId: recId
      );

      if (res.success) {
        showToast(res.message);

        /// 🔁 refresh list after add
        await fetchReviews(
          context: context,
          hubId: chargingHubId,
        );
      } else {
        showToast(res.message);
      }

      return res;
    } catch (e) {
      showToast("Failed to add review");
      return null;
    } finally {
      loading = false;
      notifyListeners();
    }
  }


   bool deleting = false;
  String? deleteMessage;

 DeleteReviewResponse? deleteResponse;


Future<DeleteReviewResponse?> deleteReview(
  BuildContext context,
  String reviewId,
) async {
  try {
    deleting = true;
    notifyListeners();

    final res = await _service.deleteReview(context, reviewId);
    deleteMessage = res.message;

    if (res.success) {
      // remove deleted review from list
      response?.reviews?.removeWhere((r) => r.recId == reviewId);
    }

    // assign to deleteResponse
    deleteResponse = res;

    return deleteResponse; // now it will not be null
  } catch (e) {
    deleteMessage = 'Failed to delete review';
    return DeleteReviewResponse(
      success: false,
      message: deleteMessage ?? 'Failed to delete review',
      review: null,
    );
  } finally {
    deleting = false;
    notifyListeners();
  }
}

}
