import 'package:flutter/material.dart';
import 'package:klump_checkout/klump_checkout.dart';
import 'package:klump_checkout/src/views/web_view.dart';

class KlumpPlugin {
  final String publicKey;

  KlumpPlugin({
    required this.publicKey,
  });

  Future<KlumpCheckoutHandler?> checkout({
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
