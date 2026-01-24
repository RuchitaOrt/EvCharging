import 'package:ev_charging_app/Request/RegisterRequest.dart';
import 'package:ev_charging_app/Screens/MainTab.dart';
import 'package:ev_charging_app/Services/auth_api_service.dart';
import 'package:ev_charging_app/Utils/APIManager.dart';
import 'package:ev_charging_app/Utils/AppEror.dart';
import 'package:ev_charging_app/Utils/ShowDialog.dart';
import 'package:ev_charging_app/Utils/ValidationHelper.dart';
import 'package:ev_charging_app/model/LogoutResponse.dart';
import 'package:ev_charging_app/model/RegistrationResponse.dart';
import 'package:ev_charging_app/widget/GlobalLists.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final AuthApiService _authApiService = AuthApiService();

  bool isLoading = false;
  RegistrationResponse? registrationResponse;
  AppError? error;
 Future<bool> register(BuildContext context, RegisterRequest request) async {
  // 🔹 Validation
  if (!ValidationHelper.isNotEmpty(request.firstName)) {
    showToast("Please enter firstname");
    return false;
  }
  if (!ValidationHelper.isNotEmpty(request.lastName)) {
    showToast("Please enter lastname");
    return false;
  }
  if (!ValidationHelper.isNotEmpty(request.eMailID)) {
    showToast("Please enter email");
    return false;
  }
  if (!ValidationHelper.isEmailValid(request.eMailID)) {
    showToast("Please enter a valid email address");
    return false;
  }
  if (!ValidationHelper.isPasswordValid(request.password)) {
    showToast("Please enter password");
    return false;
  }
  if (!ValidationHelper.isPasswordValid(request.confirmPassword)) {
    showToast("Please enter confirm password");
    return false;
  }
  if (request.password != request.confirmPassword) {
    showToast("Password and Confirm Password do not match");
    return false;
  }

  // 🔹 API call
  isLoading = true;
  notifyListeners();
  try {
    registrationResponse =
        await _authApiService.registerUser(context, request);

    if (registrationResponse?.success == true) {
      GlobalLists.islLogin = true;
      return true; // ✅ Registration success
    } else {
      showToast(registrationResponse?.message ?? "Registration failed");
      return false;
    }
  } catch (e) {
    error = AppError(e);
    showToast("Something went wrong");
    return false;
  } finally {
    isLoading = false;
    notifyListeners();
  }
}

  bool loading = false;

  Future<void> logout(BuildContext context) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final response = await _authApiService.logout(context);

      debugPrint("🚪 Logout response => $response");

      if (response.success) {
        await APIManager.clearCookies();

        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();

        GlobalLists.islLogin = false;

        await Future.delayed(const Duration(milliseconds: 100));

        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => MainTab(isLoggedIn: false),
            ),
            (_) => false,
          );
        }
      }
    } catch (e) {
      error = AppError(e);
      debugPrint("❌ Logout error: $e");
    }

    loading = false;
    notifyListeners();
  }
}
