import 'package:ev_charging_app/Request/AddWalletRequest.dart';
import 'package:ev_charging_app/Utils/APIManager.dart';
import 'package:ev_charging_app/model/WalletListResponse.dart';
import 'package:ev_charging_app/model/WalletResponse.dart';
import 'package:flutter/material.dart';

class WalletApiService {
  final APIManager _apiManager = APIManager();

  Future<WalletResponse> addWalletCredits(
      BuildContext context, AddWalletRequest request) async {
    try {
      final response = await _apiManager.apiRequest(
        context,
        API.addWalletCredits, // we'll add this enum in APIManager
        jsonval: request.toJson(),
      );
  print("walletResponse  add ${response.toString()}");
      return response as WalletResponse;
    } catch (e) {
      rethrow;
    }
  }



   Future<WalletListResponse> getWalletDetails(
    BuildContext context,
  ) async {
    final response = await _apiManager.apiRequest(
      context,
      API.walletDetails,
    );

    return response as WalletListResponse;
  }
}
