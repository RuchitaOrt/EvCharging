class WalletListResponse {
  final bool success;
  final String? message;
  final WalletDetails? wallet;

  WalletListResponse({
    required this.success,
    this.message,
    this.wallet,
  });

  factory WalletListResponse.fromJson(Map<String, dynamic> json) {
    return WalletListResponse(
      success: json['success'] ?? false,
      message: json['message'],
      wallet:
          json['wallet'] != null ? WalletDetails.fromJson(json['wallet']) : null,
    );
  }
}

class WalletDetails {
  final String? userId;
  final num? currentBalance;
  final List<WalletTransaction> recentTransactions;

  WalletDetails({
    this.userId,
    this.currentBalance,
    required this.recentTransactions,
  });

  factory WalletDetails.fromJson(Map<String, dynamic> json) {
    return WalletDetails(
      userId: json['userId'],
      currentBalance: json['currentBalance'],
      recentTransactions: (json['recentTransactions'] as List?)
              ?.map((e) => WalletTransaction.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class WalletTransaction {
  final String? recId;
  final String? previousCreditBalance;
  final String? currentCreditBalance;
  final String? transactionType;
  final String? paymentRecId;
  final num? amount;
  final String? chargingSessionId;
  final String? additionalInfo1;
  final String? additionalInfo2;
  final String? additionalInfo3;
  final DateTime? createdOn;

  WalletTransaction({
    this.recId,
    this.previousCreditBalance,
    this.currentCreditBalance,
    this.transactionType,
    this.amount,
    this.paymentRecId,
    this.chargingSessionId,
    this.additionalInfo1,
    this.additionalInfo2,
    this.additionalInfo3,
    this.createdOn,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      recId: json['recId'],
      previousCreditBalance: json['previousCreditBalance'],
      currentCreditBalance: json['currentCreditBalance'],
       amount: json['amount'],
      transactionType: json['transactionType'],
      paymentRecId: json['paymentRecId'],
      chargingSessionId: json['chargingSessionId'],
      additionalInfo1: json['additionalInfo1'],
      additionalInfo2: json['additionalInfo2'],
      additionalInfo3: json['additionalInfo3'],
      createdOn: json['createdOn'] != null
          ? DateTime.tryParse(json['createdOn'])
          : null,
    );
  }
}
