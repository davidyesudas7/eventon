// razorpay_service.dart
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  late Razorpay _razorpay;
  final Function(PaymentSuccessResponse) onSuccess;
  final Function(String) onError;
  final Function(ExternalWalletResponse) onExternalWallet;

  RazorpayService({
    required this.onExternalWallet,
    required this.onSuccess,
    required this.onError,
  }) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (
      PaymentSuccessResponse response,
    ) {
      onSuccess(response);
    });

    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (
      PaymentFailureResponse response,
    ) {
      onError("${response.code} - ${response.message}");
    });

    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (
      ExternalWalletResponse response,
    ) {
      onExternalWallet(response);
    });
  }

  void openCheckout({
    required double amount,
    String? prefillEmail,
    String? prefillContact,
    required String orderId,
  }) {
    log(prefillEmail.toString());
    final options = {
      'key': dotenv.env['RAZORPAY_KEY'],
      'amount': (amount * 100).toString(),
      'name': "Style Story",
      'description': 'Product Payment',
      // "order_id": orderId,
      'prefill': {'contact': prefillContact, 'email': prefillEmail},
      'notes': {'merchant_order_id': orderId},
    };

    log(options.toString());
    try {
      _razorpay.open(options);
    } catch (e) {
      onError(e.toString());
    }
  }

  void dispose() {
    _razorpay.clear();
  }
}
