import 'package:equatable/equatable.dart';
import 'package:klump_checkout/src/models/klump_checkout_item.dart';

class KlumpCheckoutData extends Equatable {
  final double amount;
  final double? shippingFee;
  final String? currency;
  final String merchantReference;
  final Map<String, String> metaData;
  final List<KlumpCheckoutItem> items;

  const KlumpCheckoutData({
    required this.amount,
    this.shippingFee,
    this.currency,
    required this.merchantReference,
    required this.metaData,
    required this.items,
  });

  Map<String, dynamic> toMap() => {
        'amount': amount,
        'shipping_fee': shippingFee ?? 0,
        'currency': "'${currency ?? 'NGN'}'",
        'merchant_reference': "'$merchantReference'",
        'meta_data': metaData.map((key, value) => MapEntry(key, "'$value'")),
        'source': "'mobile'",
        'items': items.map((e) => e.toMap()).toList(),
      };

  @override
  List<Object?> get props =>
      [amount, shippingFee, currency, merchantReference, metaData, items];
}
