class WalletResponse {
  bool success;
  String message;
  WalletData? wallet;

  WalletResponse({
    required this.success,
    required this.message,
    this.wallet,
  });

  factory WalletResponse.fromJson(Map<String, dynamic> json) {
    return WalletResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      wallet: json['wallet'] != null
          ? WalletData.fromJson(json['wallet'])
          : null,
    );
  }
}

class WalletData {
  String userId;
  double currentBalance;
  List<WalletTransaction>? recentTransactions;

  WalletData({
    required this.userId,
    required this.currentBalance,
    this.recentTransactions,
  });

  factory WalletData.fromJson(Map<String, dynamic> json) {
    return WalletData(
      userId: json['userId'] ?? '',
      currentBalance: (json['currentBalance'] != null)
          ? double.tryParse(json['currentBalance'].toString()) ?? 0.0
          : 0.0,
      recentTransactions: json['recentTransactions'] != null
          ? List<WalletTransaction>.from(
              json['recentTransactions'].map(
                (x) => WalletTransaction.fromJson(x),
              ),
            )
          : [],
    );
  }
}

class WalletTransaction {
  String transactionType;
  double amount;
  String? transactionId;
  String? date;

  WalletTransaction({
    required this.transactionType,
    required this.amount,
    this.transactionId,
    this.date,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      transactionType: json['transactionType'] ?? '',
      amount: (json['amount'] != null)
          ? double.tryParse(json['amount'].toString()) ?? 0.0
          : 0.0,
      transactionId: json['transactionId'],
      date: json['date'],
    );
  }
}
