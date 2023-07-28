import 'package:flutter/material.dart';
import 'package:klump_checkout/klump_checkout.dart';

class KlumpCheckout {
  /// Initiate KlumpCheckout and pay using the payment UI
  ///
  /// [isLive] - default is true, pass false for test/staging environment
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
