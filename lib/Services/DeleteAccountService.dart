import 'package:flutter/material.dart';
import 'package:HyCharge/Utils/APIManager.dart';
import 'package:HyCharge/model/DeleteAccountResponse.dart';

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
