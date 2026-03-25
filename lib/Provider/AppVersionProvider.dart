import 'package:HyCharge/model/AppVersionRepository.dart';
import 'package:HyCharge/model/AppVersionResponse.dart';
import 'package:flutter/material.dart';

class AppVersionProvider extends ChangeNotifier {
  final AppVersionRepository _repository = AppVersionRepository();

  AppVersionData? appVersionData;
  bool isLoading = false;

  Future<void> checkAppVersion(BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await _repository.fetchAppVersion(context);

      if (response.status == true) {
        appVersionData = response.data;
      }
    } catch (e) {
      print("❌ App Version Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}