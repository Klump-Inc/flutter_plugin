import 'package:klump_checkout/src/models/klump_checkout_item.dart';

class KlumpCheckoutData {
  final double totalAmount;
  final double? shippingFee;
  final String? currency;
  final String? merchantReference;
  final Map<String, dynamic> metaData;
  final List<KlumpCheckoutItem> items;

  KlumpCheckoutData({
    required this.totalAmount,
    this.shippingFee,
    this.currency,
    this.merchantReference,
    required this.metaData,
    required this.items,
  });
}
