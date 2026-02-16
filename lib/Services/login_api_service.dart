import 'package:HyCharge/Request/LoginRequest.dart';
import 'package:HyCharge/Utils/APIManager.dart';
import 'package:HyCharge/model/resend_otp_response.dart';
import 'package:HyCharge/model/send_otp_response.dart';
import 'package:HyCharge/model/verify_otp_response.dart';
import 'package:flutter/material.dart';
import 'package:HyCharge/Utils/AppEror.dart';
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
 print("REsponse ${response}");
  return response as LoginResponse;
}


  Future<SendOtpResponse> sendOtp({
    required BuildContext context,
    required String phoneNumber,
    required String countryCode,
    String purpose = "Login",
  }) async {
    final body = {
      "phoneNumber": phoneNumber,
      "countryCode": countryCode,
      "purpose": purpose,
    };

    final response = await _apiManager.apiRequest(
      context,
      API.sendOtp,
      jsonval: body,
    );

    return response as SendOtpResponse;
  }
  Future<VerifyOtpResponse> verifyOtp({
  required BuildContext context,
  required String authId,
  required String otpCode,
  required String phoneNumber,
}) async {
  final body = {
    "authId": authId,
    "otpCode": otpCode,
    "phoneNumber": phoneNumber,
  };

  final response = await _apiManager.apiRequest(
    context,
    API.verifyOtp,
    jsonval: body,
  );

  return response as VerifyOtpResponse;
}
Future<ResendOtpResponse> resendOtp({
  required BuildContext context,
  required String phoneNumber,
  required String countryCode,
  String purpose = "Resend",
}) async {
  final body = {
    "phoneNumber": phoneNumber,
    "countryCode": countryCode,
    "purpose": purpose,
  };

  final response = await _apiManager.apiRequest(
    context,
    API.resendOtp,
    jsonval: body,
  );

  return response as ResendOtpResponse;
}

}
