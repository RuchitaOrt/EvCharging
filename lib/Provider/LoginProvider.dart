import 'dart:io';

import 'package:HyCharge/Request/LoginRequest.dart';
import 'package:HyCharge/Services/login_api_service.dart';
import 'package:HyCharge/Utils/commonimages.dart';
import 'package:HyCharge/model/resend_otp_response.dart';
import 'package:HyCharge/model/send_otp_response.dart';
import 'package:HyCharge/model/verify_otp_response.dart';

import 'package:flutter/material.dart';
import 'package:HyCharge/model/LoginResponse.dart';
import 'package:HyCharge/Utils/AppEror.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider extends ChangeNotifier {
  final LoginService _loginService = LoginService();

  bool isLoading = false;
  bool _isLoading = false;
  LoginResponse? loginResponse;
  AppError? error;
  User? _user;
   final FirebaseAuth _auth = FirebaseAuth.instance;
  bool get isLoadingSet => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
   String? selectedChip;
final List<Map<String, String>> chipAccountData = [
  Platform.isAndroid?  {'label': 'Google', 'image': CommonImagePath.google}:
    {'label': 'Apple', 'image': CommonImagePath.apple},
  ];
  var getToken = "";
  void onSingleChipSelected(String? label) {
    selectedChip = label; // Update the selected chip
    if (label == "Google") {
       signInWithGoogle();
    }else if (label == "Apple") {
    //  signInWithApple();
    }
    notifyListeners();
  }
 
Future<void> signInWithGoogle() async {
  try {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email'],
    );
 print("RUCHITA ${googleSignIn.clientId}");
    final GoogleSignInAccount? googleUser =
        await googleSignIn.signIn();
 print("RUCHITA ${googleUser!.email}");
    if (googleUser == null) {
      print("User cancelled Google sign-in");
      return;
    }
print("RUCHITA googleAuth");
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
print("RUCHITA ${googleAuth.idToken}");

    final AuthCredential credential =
        GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // 🔥 Firebase sign-in happens HERE
    final UserCredential userCredential =
        await _auth.signInWithCredential(credential);

    final User? user = userCredential.user;

    if (user == null) {
      print("Firebase user is null");
      return;
    }

    // 🔥 NOW this will NOT be null
    final String? firebaseIdToken =
        await user.getIdToken(true);

    print("RUCHITA Firebase ID Token: $firebaseIdToken");
    print("RUCHITA UID: ${user.uid}");
    print("RUCHITA Email: ${user.email}");

  } catch (e) {
    print("Google Sign-In error: $e");
  }
}

  Future<void> login(BuildContext context, LoginRequest request) async {
    try {
      isLoading = true;
      notifyListeners();
print("RUCHI2");
      loginResponse = await _loginService.loginUser(context, request);
      print(loginResponse);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("userId", loginResponse!.user!.recId!); // or token
    } catch (e) {
      print("RUCHI2 ${e.toString()}");
      error = AppError(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  bool _loading = false;
 

  SendOtpResponse? _sendOtpResponse;
  SendOtpResponse? get sendOtpResponse => _sendOtpResponse;

  Future<void> sendOtp({
    required BuildContext context,
    required String phoneNumber,
    required String countryCode,
  }) async {
    try {
      _loading = true;
      notifyListeners();

      _sendOtpResponse = await _loginService.sendOtp(
        context: context,
        phoneNumber: phoneNumber,
        countryCode: countryCode,
      );

      if (_sendOtpResponse?.success == true) {
        print("OTP Sent Successfully");
      }
       _loading = false;
      notifyListeners();

    } catch (e) {
      print("Send OTP Error: $e");
       _loading = false;
      notifyListeners();
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  VerifyOtpResponse? _verifyOtpResponse;
VerifyOtpResponse? get verifyOtpResponse => _verifyOtpResponse;

Future<void> verifyOtp({
  required BuildContext context,
  required String authId,
  required String otpCode,
  required String phoneNumber,
}) async {
  try {
    _loading = true;
    notifyListeners();

    _verifyOtpResponse = await _loginService.verifyOtp(
      context: context,
      authId: authId,
      otpCode: otpCode,
      phoneNumber: phoneNumber,
    );

    if (_verifyOtpResponse?.success == true) {
      await _saveLoginData(_verifyOtpResponse!);
    }

  } catch (e) {
    print("Verify OTP Error: $e");
    rethrow;
  } finally {
    _loading = false;
    notifyListeners();
  }
}
ResendOtpResponse? _resendOtpResponse;
ResendOtpResponse? get resendOtpResponse => _resendOtpResponse;

Future<void> resendOtp({
  required BuildContext context,
  required String phoneNumber,
  required String countryCode,
}) async {
  try {
    _loading = true;
    notifyListeners();

    _resendOtpResponse = await _loginService.resendOtp(
      context: context,
      phoneNumber: phoneNumber,
      countryCode: countryCode,
    );

    if (_resendOtpResponse?.success == true) {
      print("✅ OTP Resent Successfully");
    }

  } catch (e) {
    print("Resend OTP Error: $e");
    rethrow;
  } finally {
    _loading = false;
    notifyListeners();
  }
}

Future<void> _saveLoginData(VerifyOtpResponse response) async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setString("accessToken", response.accessToken ?? "");
  await prefs.setString("refreshToken", response.refreshToken ?? "");
  await prefs.setString("userId", response.user?.userId ?? "");
  
  await prefs.setBool("isLoggedIn", true);

  print("✅ Login Data Saved");
}
}
