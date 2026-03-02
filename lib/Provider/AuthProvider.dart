import 'package:HyCharge/Request/RegisterRequest.dart';
import 'package:HyCharge/Screens/MainTab.dart';
import 'package:HyCharge/Services/auth_api_service.dart';
import 'package:HyCharge/Utils/APIManager.dart';
import 'package:HyCharge/Utils/AppEror.dart';
import 'package:HyCharge/Utils/AuthStorage.dart';
import 'package:HyCharge/Utils/ShowDialog.dart';
import 'package:HyCharge/Utils/ValidationHelper.dart';
import 'package:HyCharge/model/LogoutResponse.dart';
import 'package:HyCharge/model/RegistrationResponse.dart';
import 'package:HyCharge/model/ResetPasswordResponse.dart';
import 'package:HyCharge/model/resend_otp_response.dart';
import 'package:HyCharge/model/send_otp_response.dart';
import 'package:HyCharge/model/verify_otp_response.dart';
import 'package:HyCharge/widget/GlobalLists.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final AuthApiService _authApiService = AuthApiService();

  bool isLoading = false;
  RegistrationResponse? registrationResponse;
  AppError? error;
  String? message;
  Future<bool> register(BuildContext context, RegisterRequest request) async {
    // 🔹 Validation
    if (!ValidationHelper.isNotEmpty(request.firstName)) {
      FocusScope.of(context).unfocus();
      showToast("Please enter firstname");
      return false;
    }
    if (!ValidationHelper.isNameValid(request.firstName)) {
      FocusScope.of(context).unfocus();
  showToast("First name should contain only letters");
  return false;
}
    if (!ValidationHelper.isNotEmpty(request.lastName)) {
      FocusScope.of(context).unfocus();
      showToast("Please enter lastname");
      return false;
    }
    if (!ValidationHelper.isNameValid(request.lastName)) {
      FocusScope.of(context).unfocus();
  showToast("Last name should contain only letters");
  return false;
}
    if (!ValidationHelper.isNotEmpty(request.eMailID)) {
      FocusScope.of(context).unfocus();
      showToast("Please enter email");
      return false;
    }
    if (!ValidationHelper.isEmailValid(request.eMailID)) {
      FocusScope.of(context).unfocus();
      showToast("Please enter a valid email address");
      return false;
    }
    if (!ValidationHelper.isValidPhone(request.phoneNumber)) {
      FocusScope.of(context).unfocus();
      showToast("Please enter a valid mobile number");
      return false;
    }
    if (!ValidationHelper.isPasswordValid(request.password)) {
      FocusScope.of(context).unfocus();
      showToast("Password must be at least 6 characters");
      return false;
    }

    if (!ValidationHelper.isPasswordValid(request.confirmPassword)) {
      if (request.password != request.confirmPassword) {
        FocusScope.of(context).unfocus();
        showToast("Password and Confirm Password do not match");
        return false;
      }
    }
    // 🔹 API call
    isLoading = true;
    notifyListeners();
    try {
      registrationResponse =
          await _authApiService.registerUser(context, request);

      if (registrationResponse?.success == true) {
        GlobalLists.islLogin = true;
        message = registrationResponse!.message;
        return true; // ✅ Registration success
      } else {
        message = registrationResponse!.message;
        FocusScope.of(context).unfocus();
        showToast(registrationResponse?.message ?? "Registration failed");
        return false;
      }
    } catch (e) {
      error = AppError(e);
      FocusScope.of(context).unfocus();
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

        await AuthStorage.clearAuthData();

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

  ResetPasswordResponse? response;
  Future<ResetPasswordResponse?> resetPassword(
    BuildContext context, {
    required String emailOrPhone,
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (!ValidationHelper.isPasswordValid(newPassword)) {
      FocusScope.of(context).unfocus();
      showToast("Password must be at least 6 characters");
      return null;
    }

    if (!ValidationHelper.isPasswordValid(confirmPassword)) {
      FocusScope.of(context).unfocus();
      showToast("Confirm Password must be at least 6 characters");
      return null;
    }

    if (newPassword != confirmPassword) {
      FocusScope.of(context).unfocus();
      showToast("Password and Confirm Password do not match");
      return null;
    }

    loading = true;
    error = null;
    notifyListeners();

    try {
      response = await _authApiService.resetPassword(
        context,
        emailOrPhone: emailOrPhone,
        oldPassword: oldPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      loading = false;
      notifyListeners();

      return response; // 👈 return full response
    } catch (e) {
      loading = false;
      error = AppError(e.toString());
      notifyListeners();
      return null;
    }
  }




}
