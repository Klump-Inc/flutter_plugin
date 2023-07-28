import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:klump_checkout/klump_checkout.dart';

class KlumpCheckoutData extends Equatable {
  final double amount;
  final double? shippingFee;
  final String? currency;
  final String merchantReference;
  final Map<String, String> metaData;
  final List<KlumpCheckoutItem> items;
  final String merchantPublicKey;
  final Map<String, dynamic>? shippingData;

  const KlumpCheckoutData({
    required this.amount,
    this.shippingFee,
    this.currency,
    required this.merchantReference,
    required this.metaData,
    required this.items,
    required this.merchantPublicKey,
    this.shippingData,
  });

  Map<String, dynamic> toMap() => {
        'amount': amount,
        'shipping_fee': shippingFee ?? 0,
        'currency': "'${currency ?? 'NGN'}'",
        'merchant_reference': "'$merchantReference'",
        'meta_data': metaData.map((key, value) => MapEntry(key, "'$value'")),
        'source': "'mobile'",
        'items': items.map((e) => e.toMap()).toList(),
        'shipping_data': shippingData,
      };

  @override
  List<Object?> get props => [
        amount,
        shippingFee,
        currency,
        merchantReference,
        metaData,
        items,
        required,
        merchantPublicKey,
        shippingData,
      ];
}
