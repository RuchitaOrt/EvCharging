import 'package:ev_charging_app/Request/AddWalletRequest.dart';
import 'package:ev_charging_app/Services/WalletApiService.dart';

import 'package:ev_charging_app/Utils/AppEror.dart';
import 'package:ev_charging_app/enum/enum.dart';
import 'package:ev_charging_app/model/WalletListResponse.dart';
import 'package:ev_charging_app/model/WalletResponse.dart' as wallet;
import 'package:flutter/material.dart';

class WalletProvider extends ChangeNotifier {
  final WalletApiService _service = WalletApiService();

  bool isLoading = false;
  wallet.WalletResponse? walletResponse;
  AppError? error;

  Future<void> addCredits(
    BuildContext context,
    AddWalletRequest request,
  ) async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await _service.addWalletCredits(context, request);
      walletResponse = response;
      print("walletResponse add ${response.message}");
      error = null;
    } catch (e) {
      error = FetchDataError(e.toString());
    }
    fetchWallet(context);
    isLoading = false;
    notifyListeners();
  }

  bool isWalletLoading = false;

  WalletListResponse? walletListResponse;

  double get currentBalance =>
      walletListResponse?.wallet?.currentBalance?.toDouble() ?? 0.0;

  WalletFilterType selectedFilter = WalletFilterType.all;

  void changeFilter(WalletFilterType filter) {
    selectedFilter = filter;
    notifyListeners();
  }

  Future<void> fetchWallet(BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();

      walletListResponse = await _service.getWalletDetails(context);
      print(
          "Wallet current Balance ${walletListResponse!.wallet!.currentBalance.toString()}");
    } catch (e) {
      debugPrint("Wallet fetch error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<WalletTransaction> get filteredTransactions {
    final transactions = walletListResponse?.wallet?.recentTransactions ?? [];

    if (selectedFilter == WalletFilterType.all) return transactions;

    final now = DateTime.now();

    if (selectedFilter == WalletFilterType.last7Days) {
      return transactions.where((tx) {
        if (tx.createdOn == null) return false;
        final date = tx.createdOn!;
        return now.difference(date).inDays <= 7;
      }).toList();
    }

    if (selectedFilter == WalletFilterType.thisMonth) {
      return transactions.where((tx) {
        if (tx.createdOn == null) return false;
        final date = tx.createdOn!;
        return date.month == now.month && date.year == now.year;
      }).toList();
    }

    return transactions;
  }

  String get filterLabel {
    switch (selectedFilter) {
      case WalletFilterType.thisMonth:
        return "This Month";
      case WalletFilterType.last7Days:
        return "Last 7 Days";
      case WalletFilterType.all:
      default:
        return "All";
    }
  }
}
