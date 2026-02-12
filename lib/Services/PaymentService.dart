import 'package:HyCharge/Utils/APIManager.dart';
import 'package:HyCharge/model/CreateOrderResponse.dart';
import 'package:HyCharge/model/verify_payment_response.dart';
import 'package:flutter/material.dart';

import 'package:HyCharge/model/RazorpayKeyResponse.dart';

class PaymentService {
  final APIManager _apiManager = APIManager();

  Future<RazorpayKeyResponse?> fetchRazorpayKey(BuildContext context) async {
    final response = await _apiManager.apiRequest(
      context,
      API.razorpayKey,
    );

    if (response is RazorpayKeyResponse) {
      return response;
    }
    return null;
  }

  Future<CreateOrderResponse?> createOrder(
    BuildContext context, {
    required int amount,
    String currency = "INR",
    String receipt = "",
    Map<String, dynamic>? notes,
  }) async {
    final body = {
      "amount": amount,
      "currency": currency,
      "receipt": receipt,
      "notes": notes ??
          {"additionalProp1": "", "additionalProp2": "", "additionalProp3": ""},
    };

    final response = await _apiManager.apiRequest(
      context,
      API.createRazorpayOrder,
      jsonval: body,
    );

    if (response is CreateOrderResponse) {
      return response;
    }
    return null;
  }

  Future<VerifyPaymentResponse?> verifyPayment(
    BuildContext context, {
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) async {
    final response = await _apiManager.apiRequest(
      context,
      API.verifyRazorpayPayment,
      jsonval: {
        "razorpayOrderId": razorpayOrderId,
        "razorpayPaymentId": razorpayPaymentId,
        "razorpaySignature": razorpaySignature,
      },
    );

    return response as VerifyPaymentResponse?;
  }
}
