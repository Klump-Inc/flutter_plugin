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
      color: withBG ? KCColors.grey3.withOpacity(0.15) : null,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Image.network(
            logo ?? '',
            height: 20,
            width: 17.09,
          ),
          const XSpace(14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KCBodyText1(
                  title,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                if (message != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: KCBodyText1(
                      message!,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          if (!isActive)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Container(
                decoration: BoxDecoration(
                  color: KCColors.grey3.withOpacity(0.15),
                  border: Border.all(color: KCColors.grey3),
                  borderRadius: BorderRadius.circular(4),
                ),
                height: 25,
                width: 85,
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
