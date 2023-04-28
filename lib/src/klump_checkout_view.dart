import 'package:flutter/material.dart';
import 'package:klump_checkout/klump_checkout.dart';

class KlumpCheckout {
  /// Initial Checkout and pay using KlumpCheckout payment UI
  ///
  /// [isLive] - default is true, pass true for test environment
  ///
  /// [context] - the app BuildContext
  ///
  /// [data] - the purchase data consisting of total amount, meta_data, items, etc.
  ///

  ///
  /// returns [KlumpCheckoutResponse]
  Future<KlumpCheckoutResponse?> pay({
    bool isLive = true,
    required BuildContext context,
    required KlumpCheckoutData data,
  }) async {
    return await KCBottomSheet.route(context, data, isLive);
  }
}
