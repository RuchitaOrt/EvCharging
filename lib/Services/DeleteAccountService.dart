import 'package:flutter/material.dart';
import 'package:ev_charging_app/Utils/APIManager.dart';
import 'package:ev_charging_app/model/DeleteAccountResponse.dart';

class DeleteAccountService {
  static Future<DeleteAccountResponse> deleteAccount(
    BuildContext context,
  ) async {
    final response = await APIManager().apiRequest(
      context,
      API.deleteAccount,
    );

    return response as DeleteAccountResponse;
  }
}
