import 'package:flutter/material.dart';
import 'package:klump_checkout/src/src.dart';

/// Shown when an inactive OPay partner is selected and the user is steered
/// toward universal lenders (e.g. Credit Direct) on the web for verification.
class OpayBrowserDisclaimer extends StatelessWidget {
  const OpayBrowserDisclaimer({super.key});

  static const message =
      'OPay users selecting Credit Direct, please use a web browser to complete face verification.';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: KCColors.yellow.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(3.52),
        border: Border.all(color: KCColors.yellow, width: 0.59),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: KCBodyText1(
        message,
        fontWeight: FontWeight.w500,
        color: KCColors.orange,
      ),
    );
  }
}
