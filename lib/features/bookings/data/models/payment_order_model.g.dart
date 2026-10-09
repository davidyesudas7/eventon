// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentOrderModel _$PaymentOrderModelFromJson(Map<String, dynamic> json) =>
    PaymentOrderModel(
      paymentOrderId: json['paymentOrderId'] as String,
      razorpayOrderId: json['razorpayOrderId'] as String,
      razorpayKeyId: json['razorpayKeyId'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
    );

Map<String, dynamic> _$PaymentOrderModelToJson(PaymentOrderModel instance) =>
    <String, dynamic>{
      'paymentOrderId': instance.paymentOrderId,
      'razorpayOrderId': instance.razorpayOrderId,
      'razorpayKeyId': instance.razorpayKeyId,
      'amount': instance.amount,
      'currency': instance.currency,
    };
