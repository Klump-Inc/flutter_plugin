import 'package:flutter/material.dart';
import 'package:klump_checkout/klump_checkout.dart';
import 'package:klump_checkout/src/views/web_view.dart';

class KlumpWidget {
  final String publicKey;
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
    required this.publicKey,
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
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => KlumpWebview(
          pubilcKey: publicKey,
          data: data,
          isLive: isLive,
        ),
      ),
    );
  }
}
