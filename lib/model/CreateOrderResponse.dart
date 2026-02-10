class CreateOrderResponse {
  final bool success;
  final String? message;
  final RazorpayOrderData? data;

  CreateOrderResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory CreateOrderResponse.fromJson(Map<String, dynamic> json) {
    return CreateOrderResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'] != null
          ? RazorpayOrderData.fromJson(json['data'])
          : null,
    );
  }
}

class RazorpayOrderData {
  final String? id;
  final String? entity;
  final int? amount;
  final int? amountPaid;
  final int? amountDue;
  final String? currency;
  final String? receipt;
  final String? status;
  final int? attempts;
  final Map<String, dynamic>? notes;
  final int? createdAt;

  RazorpayOrderData({
    this.id,
    this.entity,
    this.amount,
    this.amountPaid,
    this.amountDue,
    this.currency,
    this.receipt,
    this.status,
    this.attempts,
    this.notes,
    this.createdAt,
  });

  factory RazorpayOrderData.fromJson(Map<String, dynamic> json) {
    return RazorpayOrderData(
      id: json['id'],
      entity: json['entity'],
      amount: json['amount'],
      amountPaid: json['amountPaid'],
      amountDue: json['amountDue'],
      currency: json['currency'],
      receipt: json['receipt'],
      status: json['status'],
      attempts: json['attempts'],
      notes: json['notes'] != null
          ? Map<String, dynamic>.from(json['notes'])
          : null,
      createdAt: json['createdAt'],
    );
  }
}
