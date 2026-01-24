import 'package:ev_charging_app/Request/LoginRequest.dart';
import 'package:ev_charging_app/Utils/APIManager.dart';
import 'package:flutter/material.dart';
import 'package:ev_charging_app/Utils/AppEror.dart';
import 'package:ev_charging_app/model/LoginResponse.dart';

class LoginService {
  final APIManager _apiManager = APIManager();
Future<LoginResponse> loginUser(
  BuildContext context,
  LoginRequest request,
) async {
  final response = await _apiManager.apiRequest(
    context,
    API.login,
    jsonval: request.toJson(),
  );

  return response as LoginResponse;
}
}
