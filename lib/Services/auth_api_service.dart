import 'package:HyCharge/model/LogoutResponse.dart';
import 'package:HyCharge/model/ResetPasswordResponse.dart';
import 'package:flutter/material.dart';
import 'package:HyCharge/Request/RegisterRequest.dart';
import 'package:HyCharge/Utils/APIManager.dart';
import 'package:HyCharge/Utils/AppEror.dart';
import 'package:HyCharge/model/RegistrationResponse.dart';

// class AuthApiService {
//   final APIManager _apiManager = APIManager();

//   void registerUser(
//     BuildContext context,
//     RegisterRequest request, {
//     required Function(RegistrationResponse response) onSuccess,
//     required Function(AppError error) onError,
//   }) {
//      print(API.registration.name);
//     _apiManager.apiRequest(
//       context,
//       API.registration,
//       (response) {
        
//         print(response);
//         onSuccess(response as RegistrationResponse);
//       },
//       (error) {
//          print(error);
//         onError(error);
//       },
//       jsonval: request.toJson(),
//     );
//   }
// }
class AuthApiService {
  final APIManager _apiManager = APIManager();

  Future<RegistrationResponse> registerUser(
    BuildContext context,
    RegisterRequest request,
  ) async {
    final response = await _apiManager.apiRequest(
      context,
      API.registration,
      jsonval: request.toJson(),
    );

    return response as RegistrationResponse;
  }

 Future<LogoutResponse> logout(BuildContext context) async {
  final response = await _apiManager.apiRequest(
    context,
    API.logout,
  );

  debugPrint("LOGOUT SERVICE");
  debugPrint(response.toString());

  return response as LogoutResponse; // ✅ JUST CAST
}
 Future<ResetPasswordResponse> resetPassword(
    BuildContext context, {
    required String emailOrPhone,
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final response = await APIManager().apiRequest(
      context,
      API.resetPassword,
      jsonval: {
        "emailOrPhone": emailOrPhone,
        "oldPassword": oldPassword,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
      },
    );

    return response as ResetPasswordResponse;
  }
  
}
