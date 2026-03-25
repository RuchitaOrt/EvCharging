import 'package:HyCharge/Request/AddWalletRequest.dart';
import 'package:HyCharge/Services/WalletApiService.dart';

import 'package:HyCharge/Utils/AppEror.dart';
import 'package:HyCharge/Utils/RazorpayHelper.dart';
import 'package:HyCharge/enum/enum.dart';
import 'package:HyCharge/model/WalletListResponse.dart';
import 'package:HyCharge/model/WalletResponse.dart' as wallet;
import 'package:flutter/material.dart';
class WalletProvider extends ChangeNotifier {
  final WalletApiService _service = WalletApiService();
 final RazorpayHelper razorpayHelper = RazorpayHelper();
  int _pageNumber = 1;
  final int _pageSize = 100;

  bool hasMore = true;
  bool isInitialLoading = false;
  bool isMoreLoading = false;

  final List<WalletTransaction> _transactions = [];
  List<WalletTransaction> get transactions => _transactions;

  WalletListResponse? walletListResponse;

  double get currentBalance =>
      walletListResponse?.wallet?.currentBalance?.toDouble() ?? 0.0;

  WalletFilterType selectedFilter = WalletFilterType.all;
  // bool isLoadingWallet = false;
  // ---------------- FETCH FIRST PAGE ----------------
  Future<void> fetchWallet(BuildContext context) async {
    try {
      isInitialLoading = true;
      // isLoadingWallet=true;
      notifyListeners();

      _pageNumber = 1;
      hasMore = true;
      _transactions.clear();

      final response = await _service.getWalletDetails(
        context,
        pageNumber: _pageNumber,
        pageSize: _pageSize,
      );

      walletListResponse = response;

      final newList = response.wallet?.recentTransactions ?? [];

      _transactions.addAll(List.from(newList)); // ✅ SAFE COPY

      if (newList.length < _pageSize) {
        hasMore = false;
      }
     isInitialLoading = false;
    } catch (e) {
       isInitialLoading = false;
      debugPrint("Wallet fetch error: $e");
    } finally {
     
     isInitialLoading = false;
      notifyListeners();
    }
  }

  // ---------------- LOAD MORE ----------------
  Future<void> loadMore(BuildContext context) async {
  if (isMoreLoading || !hasMore) return;

  isMoreLoading = true;
  notifyListeners();

  _pageNumber++;

  try {
    final response = await _service.getWalletDetails(
      context,
      pageNumber: _pageNumber,
      pageSize: _pageSize,
    );

    final newList = response.wallet?.recentTransactions ?? [];

    if (newList.isEmpty || newList.length < _pageSize) {
      hasMore = false; // ✅ STOP further calls
    }

    _transactions.addAll(List.from(newList));
  } catch (e) {
    debugPrint("Load more error: $e");
  } finally {
    isMoreLoading = false;
    notifyListeners();
  }
}


  // ---------------- FILTER ----------------
  List<WalletTransaction> get filteredTransactions {
    final list = List<WalletTransaction>.from(_transactions);

    if (selectedFilter == WalletFilterType.all) return list;

    final now = DateTime.now();

    if (selectedFilter == WalletFilterType.last7Days) {
      return list.where((tx) {
        if (tx.createdOn == null) return false;
        return now.difference(tx.createdOn!).inDays <= 7;
      }).toList();
    }

    if (selectedFilter == WalletFilterType.thisMonth) {
      return list.where((tx) {
        if (tx.createdOn == null) return false;
        return tx.createdOn!.month == now.month &&
            tx.createdOn!.year == now.year;
      }).toList();
    }
 // ✅ CREDIT FILTER
  if (selectedFilter == WalletFilterType.Credit) {
    return list.where((tx) {
      return (tx.transactionType ?? "").toLowerCase() == "credit";
    }).toList();
  }

  // ✅ DEBIT FILTER
  if (selectedFilter == WalletFilterType.Debit) {
    return list.where((tx) {
      return (tx.transactionType ?? "").toLowerCase() == "debit";
    }).toList();
  }

    return list;
  }

  void changeFilter(WalletFilterType filter) {
    selectedFilter = filter;
    notifyListeners();
  }

  String get filterLabel {
    switch (selectedFilter) {
      case WalletFilterType.thisMonth:
        return "This Month";
      case WalletFilterType.last7Days:
        return "Last 7 Days";
    
      case WalletFilterType.Credit:
      return "Credit";
    case WalletFilterType.Debit:
      return "Debit";
        case WalletFilterType.all:
      default:
        return "All";
    }
  }
  
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
}

