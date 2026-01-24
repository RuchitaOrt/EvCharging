import 'package:ev_charging_app/Utils/APIManager.dart';
import 'package:flutter/material.dart';
import 'package:ev_charging_app/model/ProfileResponse.dart';

class ProfileRepository {
  final APIManager _apiManager = APIManager();

  Future<ProfileResponse> fetchProfile(BuildContext context) async {
    final response = await _apiManager.apiRequest(
      context,
      API.profile,
    );

    return response as ProfileResponse;
  }


   /// ✅ UPDATE PROFILE (PUT)
  Future<ProfileResponse> updateProfile(
    BuildContext context, {
    required Map<String, dynamic> body,
  }) async {
    final response = await _apiManager.apiRequest(
      context,
      API.profileUpdate,   // PUT
      jsonval: body,
    );

    return response as ProfileResponse;
  }
}
