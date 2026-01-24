import 'package:ev_charging_app/Utils/ShowDialog.dart';
import 'package:ev_charging_app/Utils/ValidationHelper.dart';
import 'package:flutter/material.dart';
import 'package:ev_charging_app/Services/profile_repository.dart';
import 'package:ev_charging_app/model/ProfileResponse.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository _repo = ProfileRepository();

  bool loading = false;
  ProfileResponse? profile;
  String? error;

  Future<void> loadProfile(BuildContext context) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      profile = await _repo.fetchProfile(context);
    } catch (e) {
      print(e.toString());
      error = e.toString();
    }

    loading = false;
    notifyListeners();
  }



  /// ✅ UPDATE PROFILE
 Future<bool> updateProfile(
  BuildContext context, {
  required Map<String, dynamic> body,
}) async {
  // 🔹 Validation
  if (!ValidationHelper.isNotEmpty(body['firstName'])) {
    showToast("Please enter first name");
    return false;
  }

  if (!ValidationHelper.isNotEmpty(body['lastName'])) {
    showToast("Please enter last name");
    return false;
  }

  if (!ValidationHelper.isNotEmpty(body['addressLine1'])) {
    showToast("Please enter address");
    return false;
  }

  if (!ValidationHelper.isNotEmpty(body['phoneNumber'])) {
    showToast("Please enter phone number");
    return false;
  }

  if (!ValidationHelper.isValidPhone(body['phoneNumber'])) {
    showToast("Please enter a valid phone number");
    return false;
  }

  if (!ValidationHelper.isNotEmpty(body['eMailID'])) {
    showToast("Please enter email");
    return false;
  }

  if (!ValidationHelper.isEmailValid(body['eMailID'])) {
    showToast("Please enter a valid email address");
    return false;
  }

  // 🔹 API call
  loading = true;
  error = null;
  notifyListeners();

  try {
    profile = await _repo.updateProfile(context, body: body);
    loading = false;
    notifyListeners();
    return true;
  } catch (e) {
    loading = false;
    error = e.toString();
    notifyListeners();
    return false;
  }
}


  
}
