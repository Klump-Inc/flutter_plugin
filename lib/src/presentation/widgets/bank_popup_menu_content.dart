import 'package:flutter/material.dart';
import 'package:klump_checkout/src/src.dart';

class KCBankPopupMenuItemContent extends StatelessWidget {
  const KCBankPopupMenuItemContent({
    super.key,
    required this.title,
    required this.logo,
    this.withBG = false,
  });

  final String title;
  final String logo;
  final bool withBG;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 49,
      color: withBG ? KCColors.grey3.withOpacity(0.15) : null,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Image.asset(
            logo,
            height: 20,
            width: 17.09,
          ),
          const XSpace(14),
          KCBodyText1(
            title,
          ),
        ],
      ),
    );
  }
}
