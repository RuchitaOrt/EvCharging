class AddWalletRequest {
  final String userId;
  final String orderId;
  final String paymentId;
  final String paymentSignature;
  final double amount;
  final String currency;

  AddWalletRequest({
    required this.userId,
    required this.orderId,
    required this.paymentId,
    required this.paymentSignature,
    required this.amount,
    this.currency = "",
  });

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "orderId": orderId,
      "paymentId": paymentId,
      "paymentSignature": paymentSignature,
      "amount": amount,
      "currency": currency,
    };
  }
}

// class AddWalletRequest {
//   String userId;
//   double amount;
//   String transactionType;
//   String paymentRecId;
//   String? additionalInfo1;
//   String? additionalInfo2;
//   String? additionalInfo3;

//   AddWalletRequest({
//     required this.userId,
//     required this.amount,
//     required this.transactionType,
//     required this.paymentRecId,
//     this.additionalInfo1,
//     this.additionalInfo2,
//     this.additionalInfo3,
//   });

//   Map<String, dynamic> toJson() => {
//         "userId": userId,
//         "amount": amount,
//         "transactionType": transactionType,
//         "paymentRecId": paymentRecId,
//         "additionalInfo1": additionalInfo1 ?? "",
//         "additionalInfo2": additionalInfo2 ?? "",
//         "additionalInfo3": additionalInfo3 ?? "",
//       };
// }
