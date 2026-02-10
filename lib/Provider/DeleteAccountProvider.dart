import 'package:ev_charging_app/Screens/MainTab.dart';
import 'package:ev_charging_app/Services/DeleteAccountService.dart';
import 'package:ev_charging_app/Utils/APIManager.dart';
import 'package:ev_charging_app/widget/GlobalLists.dart';
import 'package:flutter/material.dart';
import 'package:ev_charging_app/model/DeleteAccountResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DeleteAccountProvider extends ChangeNotifier {
  bool isLoading = false;
  DeleteAccountResponse? response;
  String? error;

  Future<bool> deleteAccount(BuildContext context) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      response = await DeleteAccountService.deleteAccount(context);

      isLoading = false;
      notifyListeners();
       if (response!.success) {
        await APIManager.clearCookies();

        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();

        GlobalLists.islLogin = false;

        await Future.delayed(const Duration(milliseconds: 100));

        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => MainTab(isLoggedIn: false),
            ),
            (_) => false,
          );
        }
      }
      return response?.success == true;
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
