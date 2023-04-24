import 'package:flutter/material.dart';
import 'package:klump_checkout/klump_checkout.dart';
import 'package:klump_checkout/src/src.dart';

class KlumpWidget {
  final bool isLive;

  /// Initialize the KlumpWidget object.
  ///
  /// [publicKey] - your KlumpWidget public key. This is mandatory
  ///
  /// [isLive] - default is true, pass true for test environment
  ///
  ///
  ///

  KlumpWidget({
    this.isLive = true,
  });

  /// Initial Checkout and pay using KlumpWidget web payment UI
  ///
  /// [publicKey] - the merchat public key from [KlumpWidget] object initialization.
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
