import 'package:ev_charging_app/Services/PaymentService.dart';
import 'package:ev_charging_app/model/CreateOrderResponse.dart';
import 'package:ev_charging_app/model/verify_payment_response.dart';
import 'package:flutter/material.dart';
import 'package:ev_charging_app/model/RazorpayKeyResponse.dart';


class PaymentProvider extends ChangeNotifier {
  final PaymentService _service = PaymentService();

  bool _loading = false;
  String? _razorpayKey;

  bool get loading => _loading;
  String? get razorpayKey => _razorpayKey;

  Future<void> loadRazorpayKey(BuildContext context) async {
    _loading = true;
    notifyListeners();

    try {
      final response = await _service.fetchRazorpayKey(context);
     print("RAZOR KEY ${response}");
      if (response?.success == true) {
        _razorpayKey = response?.data?.key;
         print("RAZOR KEY ${_razorpayKey}");
      }
    } catch (e) {
      debugPrint("Razorpay key error: $e");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }


   
  RazorpayOrderData? _order;

  
  RazorpayOrderData? get order => _order;


 Future<CreateOrderResponse?> createRazorpayOrder(
  BuildContext context, {
  required int amount,
}) async {
  _loading = true;
  notifyListeners();

  try {
     
    final response = await _service.createOrder(
      context,
      amount: amount,
      receipt: "receipt_${DateTime.now().millisecondsSinceEpoch}",
    );

    if (response?.success == true) {
        _loading = false;
      _order = response?.data;
    }

    // 🔥 RETURN RESPONSE
    return response;
  } catch (e) {
    debugPrint("Create order error: $e");
    return null;
  } finally {
    _loading = false;
    notifyListeners();
  }
}

Future<VerifyPaymentResponse?> verifyRazorpayPayment(
    BuildContext context, {
    required String orderId,
    required String paymentId,
    required String signature,
  }) async {
    _loading = true;
    notifyListeners();

    try {
      final response = await _service.verifyPayment(
        context,
        razorpayOrderId: orderId,
        razorpayPaymentId: paymentId,
        razorpaySignature: signature,
      );

      return response;
    } catch (e) {
      debugPrint("Verify payment error: $e");
      return null;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
  void clearOrder() {
    _order = null;
    notifyListeners();
  }
}
