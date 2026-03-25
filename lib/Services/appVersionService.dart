import 'package:HyCharge/Utils/APIManager.dart';
import 'package:HyCharge/model/AppVersionResponse.dart';
import 'package:flutter/material.dart';

class AppVersionService {
  final APIManager _apiManager = APIManager();

  Future<AppVersionResponse> getAppVersion(BuildContext context) async {
    final response = await _apiManager.apiRequest(
      context,
      API.appVersionInfo,
    );

    return response as AppVersionResponse;
  }
}