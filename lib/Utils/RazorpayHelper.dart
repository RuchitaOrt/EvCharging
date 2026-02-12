// razorpay_helper.dart
import 'package:HyCharge/Provider/PaymentProvider.dart';
import 'package:HyCharge/Provider/WalletProvider.dart';
import 'package:HyCharge/Request/AddWalletRequest.dart';
import 'package:HyCharge/Utils/AuthStorage.dart';
import 'package:HyCharge/main.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/material.dart';

class RazorpayHelper {
  late Razorpay _razorpay;

  RazorpayHelper() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
  String? amountValue;
  void openPaymentGateway(
      {required int amount,
      required String key,
      required String orderID,
      required String currency}) {
    var options = {
      'key': key, // replace with your key
      'amount': amount, // in paise
      'name': 'EV Charging',
      'description': 'Add Credits',
      'order_id': orderID,
      'currency': currency,
      'prefill': {'contact': '', 'email': ''},
    };
    amountValue = amount.toString();
    try {
      // _razorpay.open(options);
      final provider = routeGlobalKey.currentContext!.read<PaymentProvider>();
      final order = provider.order;

      if (order != null) {
        _razorpay.open(options);
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    debugPrint('Payment Success: ${response.paymentId}');
    print("PAYMENT RESPONSE");
    print(response);
    print("Hello Signature: ${response.signature ?? "xyz"}");

    print("PgID: ${response.paymentId ?? "abc"}");
    print("PgID: ${response.orderId ?? "orderid"}");

    final provider = routeGlobalKey.currentContext!.read<PaymentProvider>();

    final verifyResponse = await provider.verifyRazorpayPayment(
      routeGlobalKey.currentContext!,
      orderId: response.orderId!,
      paymentId: response.paymentId!,
      signature: response.signature!,
    );

    if (verifyResponse?.success == true &&
        verifyResponse?.data?.status == "ok") {
      debugPrint("✅ Payment verified");
      final userId = await AuthStorage.getUserId();
      final provider = routeGlobalKey.currentContext!.read<WalletProvider>();
      provider.addCredits(
        routeGlobalKey.currentContext!,
        AddWalletRequest(
          userId: userId!,
          currency: "INR",
          orderId: response.orderId!,
          paymentId: response.paymentId!,
          paymentSignature: response.signature!,
          amount: double.parse(amountValue!),
        ),
      );
    } else {
      debugPrint("❌ Verification failed");
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint('Payment Failed: ${response.code} | ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint('External Wallet: ${response.walletName}');
  }

  void dispose() {
    _razorpay.clear();
  }
}
