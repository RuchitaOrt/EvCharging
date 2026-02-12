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

  // ---------------- FETCH FIRST PAGE ----------------
  Future<void> fetchWallet(BuildContext context) async {
    try {
      isInitialLoading = true;
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
    } catch (e) {
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

// class WalletProvider extends ChangeNotifier {
//   final WalletApiService _service = WalletApiService();
// int _pageNumber = 1;
// final int _pageSize = 10;

// bool hasMore = true;
// bool isInitialLoading = false;
// bool isMoreLoading = false;

// final List<WalletTransaction> _transactions = [];
// List<WalletTransaction> get transactions => _transactions;

//   bool isLoading = false;
//   wallet.WalletResponse? walletResponse;
//   AppError? error;
  
//   final RazorpayHelper razorpayHelper = RazorpayHelper();

//   // Call this to clean up Razorpay when provider is disposed
//   @override
//   void dispose() {
  
//     super.dispose();
//   }
//   Future<void> addCredits(
//     BuildContext context,
//     AddWalletRequest request,
//   ) async {
//     isLoading = true;
//     notifyListeners();
//     try {
//       final response = await _service.addWalletCredits(context, request);
//       walletResponse = response;
//       print("walletResponse add ${response.message}");
//       error = null;
//     } catch (e) {
//       error = FetchDataError(e.toString());
//     }
//     fetchWallet(context);
//     isLoading = false;
//     notifyListeners();
//   }

//   bool isWalletLoading = false;

//   WalletListResponse? walletListResponse;

//   double get currentBalance =>
//       walletListResponse?.wallet?.currentBalance?.toDouble() ?? 0.0;

//   WalletFilterType selectedFilter = WalletFilterType.all;

//   void changeFilter(WalletFilterType filter) {
//     selectedFilter = filter;
//     notifyListeners();
//   }
//   Future<void> fetchWallet(BuildContext context) async {
//   try {
//     isInitialLoading = true;
//     notifyListeners();

//     _pageNumber = 1;
//     hasMore = true;
//     _transactions.clear();

//     final response = await _service.getWalletDetails(
//       context,
//       pageNumber: _pageNumber,
//       pageSize: _pageSize,
//     );

//     walletListResponse = response;

//     final newList = response.wallet?.recentTransactions ?? [];
//     _transactions.addAll(newList);

//     if (newList.length < _pageSize) {
//       hasMore = false;
//     }
//   } catch (e) {
//     debugPrint("Wallet fetch error: $e");
//   } finally {
//     isInitialLoading = false;
//     notifyListeners();
//   }
// }

// bool hasMoreData = true;
// int _page = 1;

// Future<void> loadMore(BuildContext context) async {
//   if (isMoreLoading || !hasMoreData) return;

//   isMoreLoading = true;
//   notifyListeners();

//   _page++;

//   final response = await _service.getWalletDetails(
//     context,
//     pageNumber: _page,
//     pageSize: 10,
//   );

//   final newList = response.wallet?.recentTransactions ?? [];

//   if (newList.isEmpty) {
//     hasMoreData = false;
//   } else {
//     newList.addAll(newList);
//   }

//   isMoreLoading = false;
//   notifyListeners();
// }


// // Future<void> fetchWallet(BuildContext context) async {
// //   try {
// //     isLoading = true;
// //     notifyListeners();

// //     walletListResponse = await _service.getWalletDetails(
// //       context,
// //       pageNumber: 1,
// //       pageSize: 100,
// //     );

// //     debugPrint(
// //       "Wallet current Balance ${walletListResponse!.wallet!.currentBalance}");
// //   } catch (e) {
// //     debugPrint("Wallet fetch error: $e");
// //   } finally {
// //     isLoading = false;
// //     notifyListeners();
// //   }
// // }


// List<WalletTransaction> get filteredTransactions {
//   final list = _transactions;

//   if (selectedFilter == WalletFilterType.all) return list;

//   final now = DateTime.now();

//   if (selectedFilter == WalletFilterType.last7Days) {
//     return list.where((tx) {
//       if (tx.createdOn == null) return false;
//       return now.difference(tx.createdOn!).inDays <= 7;
//     }).toList();
//   }

//   if (selectedFilter == WalletFilterType.thisMonth) {
//     return list.where((tx) {
//       if (tx.createdOn == null) return false;
//       return tx.createdOn!.month == now.month &&
//           tx.createdOn!.year == now.year;
//     }).toList();
//   }

//   return list;
// }

//   // List<WalletTransaction> get filteredTransactions {
//   //   final transactions = walletListResponse?.wallet?.recentTransactions ?? [];

//   //   if (selectedFilter == WalletFilterType.all) return transactions;

//   //   final now = DateTime.now();

//   //   if (selectedFilter == WalletFilterType.last7Days) {
//   //     return transactions.where((tx) {
//   //       if (tx.createdOn == null) return false;
//   //       final date = tx.createdOn!;
//   //       return now.difference(date).inDays <= 7;
//   //     }).toList();
//   //   }

//   //   if (selectedFilter == WalletFilterType.thisMonth) {
//   //     return transactions.where((tx) {
//   //       if (tx.createdOn == null) return false;
//   //       final date = tx.createdOn!;
//   //       return date.month == now.month && date.year == now.year;
//   //     }).toList();
//   //   }

//   //   return transactions;
//   // }

//   String get filterLabel {
//     switch (selectedFilter) {
//       case WalletFilterType.thisMonth:
//         return "This Month";
//       case WalletFilterType.last7Days:
//         return "Last 7 Days";
//       case WalletFilterType.all:
//       default:
//         return "All";
//     }
//   }
// }
