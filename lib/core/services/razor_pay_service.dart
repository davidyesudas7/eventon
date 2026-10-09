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
    String? key,
    String? currency,
    String? name,
    String? description,
    Map<String, dynamic>? notes,
  }) {
    final razorpayKey = (key != null && key.isNotEmpty)
        ? key
        : dotenv.env['RAZORPAY_KEY'];

    final options = <String, dynamic>{
      'key': razorpayKey,
      'amount': (amount * 100).toInt(),
      'name': name ?? "EventOn",
      'description': description ?? 'Booking Payment',
      'order_id': orderId,
      'currency': currency ?? 'INR',
      'prefill': {
        if (prefillContact != null && prefillContact.isNotEmpty)
          'contact': prefillContact,
        if (prefillEmail != null && prefillEmail.isNotEmpty)
          'email': prefillEmail,
      },
    };
    if (notes != null) {
      options['notes'] = notes;
    }

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
