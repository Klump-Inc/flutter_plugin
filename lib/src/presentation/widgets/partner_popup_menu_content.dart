import 'package:flutter/material.dart';
import 'package:klump_checkout/src/src.dart';

class KCPartnerPopupMenuItemContent extends StatelessWidget {
  const KCPartnerPopupMenuItemContent({
    super.key,
    required this.title,
    this.logo,
    this.withBG = false,
    this.isActive = true,
    this.message,
  });

  final String title;
  final String? logo;
  final bool withBG;
  final bool isActive;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: withBG ? KCColors.grey3.withAlpha((0.15 * 255).toInt()) : null,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: KCColors.blue1.withAlpha((0.10 * 255).toInt()),
            ),
            child: Center(
              child: KCNetworkImage(
                url: logo,
                height: 20,
                width: 17.09,
              ),
            ),
          ),
          const XSpace(14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KCBodyText1(
                  title,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (!isActive)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Container(
                decoration: BoxDecoration(
                  color: KCColors.grey3.withAlpha((0.15 * 255).toInt()),
                  border: Border.all(color: KCColors.grey3, width: 0.38),
                  borderRadius: BorderRadius.circular(3),
                ),
                height: 18,
                width: 66,
                child: const Center(
                  child: KCAutoSizedText(
                    'Coming soon',
                    fontSize: 8,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
