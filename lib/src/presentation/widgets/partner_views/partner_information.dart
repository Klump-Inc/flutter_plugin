import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klump_checkout/klump_checkout.dart';
import 'package:provider/provider.dart';

class PartnerInformation extends StatelessWidget {
  const PartnerInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: constraints.maxWidth,
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const YSpace(32.6),
                    Align(
                      child: SvgPicture.asset(
                        KCAssets.klumpLogo,
                        package: KC_PACKAGE_NAME,
                      ),
                    ),
                    const YSpace(22.15),
                    KCHeadline3('Pay in instalments with Partner'),
                    const YSpace(22),
                    const PartnerItemTile(
                      title: 'Your Bank Verification Number (BVN)',
                    ),
                    const PartnerItemTile(
                      title: 'An active account with Partner',
                    ),
                    const PartnerItemTile(
                      title: 'A valid phone number and email address',
                      lastItem: true,
                    ),
                    const YSpace(25),
                    const Spacer(),
                    KCPrimaryButton(
                      title: 'Continue',
                      onTap: () =>
                          Provider.of<KCChangeNotifier>(context, listen: false)
                              .nextPage(),
                    ),
                    const YSpace(16),
                    KCSecondaryButton(
                      title: 'Go back',
                      onTap: () =>
                          Provider.of<KCChangeNotifier>(context, listen: false)
                              .prevPage(),
                    ),
                    const YSpace(59)
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class PartnerItemTile extends StatelessWidget {
  const PartnerItemTile({
    super.key,
    required this.title,
    this.lastItem = false,
  });

  final String title;
  final bool lastItem;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 41 + 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Container(
                height: 11.34,
                width: 11.34,
                decoration: BoxDecoration(
                  color: KCColors.primary,
                  borderRadius: BorderRadius.circular(30.2483),
                ),
              ),
              if (!lastItem)
                Expanded(
                  child: Container(
                    width: 1.5,
                    color: KCColors.grey1,
                  ),
                )
            ],
          ),
          const XSpace(8.66),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 41,
                  child: KCHeadline4(
                    title,
                    fontSize: 15,
                    height: 1,
                    maxLines: 2,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const YSpace(40),
              ],
            ),
          )
        ],
      ),
    );
  }
}
