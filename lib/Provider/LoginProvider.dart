import 'package:ev_charging_app/Request/LoginRequest.dart';
import 'package:ev_charging_app/Services/login_api_service.dart';
import 'package:flutter/material.dart';
import 'package:ev_charging_app/model/LoginResponse.dart';
import 'package:ev_charging_app/Utils/AppEror.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider extends ChangeNotifier {
  final LoginService _loginService = LoginService();

  bool isLoading = false;
  bool _isLoading = false;
  LoginResponse? loginResponse;
  AppError? error;
  bool get isLoadingSet => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> login(BuildContext context, LoginRequest request) async {
    try {
      isLoading = true;
      notifyListeners();

      loginResponse = await _loginService.loginUser(context, request);
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("userId", loginResponse!.user!.recId!); // or token
    } catch (e) {
      error = AppError(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
