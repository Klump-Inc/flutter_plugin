import 'package:flutter/material.dart';
import 'package:klump_checkout/klump_checkout.dart';

class KlumpCheckoutWidget {
  final bool isLive;

  /// Initialize the KlumpWidget object.
  ///
  ///
  /// [isLive] - default is true, pass true for test environment
  ///
  ///

  KlumpCheckoutWidget({
    this.isLive = true,
  });

  /// Initial Checkout and pay using KlumpWidget web payment UI
  ///
  /// [context] - the app BuildContext
  ///
  /// [data] - the purchase data consisting of total amount, meta_data, items, etc.
  ///

  ///
  /// returns [KlumpCheckoutResponse]
  Future<KlumpCheckoutResponse?> checkout({
    required BuildContext context,
    required KlumpCheckoutData data,
  }) async {
    return await KCBottomSheet.route(context, data);
  }
}
