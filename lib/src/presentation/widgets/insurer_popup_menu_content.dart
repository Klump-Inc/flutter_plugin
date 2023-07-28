import 'package:flutter/material.dart';
import 'package:klump_checkout/src/src.dart';

class KCInsurerPopupMenuItemContent extends StatelessWidget {
  const KCInsurerPopupMenuItemContent({
    super.key,
    required this.title,
    this.withBG = false,
  });

  final String title;
  final bool withBG;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 49,
      color: withBG ? KCColors.grey3.withOpacity(0.15) : null,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: KCBodyText1(
          title,
        ),
      ),
    );
  }
}
