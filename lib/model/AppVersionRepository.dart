import 'package:HyCharge/Services/appVersionService.dart';
import 'package:HyCharge/model/AppVersionResponse.dart';
import 'package:flutter/material.dart';

class AppVersionRepository {
  final AppVersionService _service = AppVersionService();

  Future<AppVersionResponse> fetchAppVersion(BuildContext context) {
    return _service.getAppVersion(context);
  }
}