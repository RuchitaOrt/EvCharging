import 'dart:developer';

import 'package:HyCharge/Request/LoginRequest.dart';
import 'package:HyCharge/Utils/APIManager.dart';
import 'package:flutter/material.dart';

import 'package:HyCharge/model/LoginResponse.dart';

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
 log("REsponse ${response}");
  return response as LoginResponse;
}
}
