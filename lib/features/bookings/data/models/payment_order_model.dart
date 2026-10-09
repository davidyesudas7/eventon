import 'package:json_annotation/json_annotation.dart';

part 'payment_order_model.g.dart';

@JsonSerializable()
class PaymentOrderModel {
  final String paymentOrderId;
  final String razorpayOrderId;
  final String razorpayKeyId;
  final double amount;
  final String currency;

  PaymentOrderModel({
    required this.paymentOrderId,
    required this.razorpayOrderId,
    required this.razorpayKeyId,
    required this.amount,
    required this.currency,
  });

  factory PaymentOrderModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentOrderModelToJson(this);
}
