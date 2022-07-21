import 'package:flutter/material.dart';
import 'package:klump_checkout/klump_checkout.dart';
import 'package:klump_checkout/src/views/web_view.dart';

class KlumpPlugin {
  final String publicKey;

  /// Initialize the KlumpPlugin object.
  ///
  /// [publicKey] - your KlumpPlugin public key. This is mandatory
  ///
  ///

  KlumpPlugin({
    required this.publicKey,
  });

  /// Initial Checkout and pay using KlumpPlugin web payment UI
  ///
  /// [publicKey] - the merchat public key from [KlumpPlugin] object initialization.
  ///
  /// [data] - the purchase data consisting of total amount, meta_data, items, etc.
  ///

  ///
  /// returns [KlumpCheckoutResponse]
  Future<KlumpCheckoutResponse?> checkout({
    required BuildContext context,
    required KlumpCheckoutData data,
  }) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => KlumpWebview(
          pubilcKey: publicKey,
          data: data,
        ),
      ),
    );
  }
}
