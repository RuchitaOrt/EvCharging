import 'package:ev_charging_app/model/LogoutResponse.dart';
import 'package:flutter/material.dart';
import 'package:ev_charging_app/Request/RegisterRequest.dart';
import 'package:ev_charging_app/Utils/APIManager.dart';
import 'package:ev_charging_app/Utils/AppEror.dart';
import 'package:ev_charging_app/model/RegistrationResponse.dart';

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

  
}
