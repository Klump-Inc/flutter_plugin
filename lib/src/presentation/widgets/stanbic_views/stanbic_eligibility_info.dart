import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:provider/provider.dart';

class StanbicEligibilityInfo extends StatefulWidget {
  const StanbicEligibilityInfo({super.key});

  @override
  State<StanbicEligibilityInfo> createState() => _StanbicEligibilityInfoState();
}

class _StanbicEligibilityInfoState extends State<StanbicEligibilityInfo> {
  @override
  Widget build(BuildContext context) {
    final checkoutNotifier = Provider.of<KCChangeNotifier>(context);
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
                  children: [
                    const YSpace(32.59),
                    Image.asset(
                      KCAssets.stanbicLogo,
                      height: 55,
                      width: 47,
                      package: KC_PACKAGE_NAME,
                    ),
                    const YSpace(24),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 187.1,
                            width: 187.1,
                            child: SvgPicture.asset(
                              checkoutNotifier.stanbicUser?.maxLoanLimit != null
                                  ? KCAssets.successIllus
                                  : KCAssets.failureIllus,
                              package: KC_PACKAGE_NAME,
                            ),
                          ),
                          const YSpace(22),
                          Column(
                            children:
                                checkoutNotifier.stanbicUser?.maxLoanLimit !=
                                        null
                                    ? [
                                        KCBodyText1(
                                          'You are qualified for a spending limit of',
                                          fontSize: 16,
                                          textAlign: TextAlign.center,
                                          height: 1.36625,
                                        ),
                                        const YSpace(8),
                                        KCHeadline3(
                                          'NGN ${KCStringUtil.formatAmount(checkoutNotifier.stanbicUser?.maxLoanLimit ?? 0)}',
                                          fontSize: 27,
                                          textAlign: TextAlign.center,
                                          height: 1.4318,
                                        ),
                                      ]
                                    : [
                                        KCHeadline3(
                                          'Unsuccessful',
                                          fontSize: 27,
                                          textAlign: TextAlign.center,
                                          height: 1.4318,
                                        ),
                                        const YSpace(8),
                                        KCBodyText1(
                                          'We couldn’t get your transaction history at this time, please try again later.',
                                          fontSize: 16,
                                          textAlign: TextAlign.center,
                                          height: 1.36625,
                                        ),
                                      ],
                          ),
                        ],
                      ),
                    ),
                    const YSpace(24),
                    KCPrimaryButton(
                        title:
                            checkoutNotifier.stanbicUser?.maxLoanLimit != null
                                ? 'Continue'
                                : 'Return to store',
                        onTap: () {
                          if (checkoutNotifier.stanbicUser?.maxLoanLimit !=
                              null) {
                            Provider.of<KCChangeNotifier>(context,
                                    listen: false)
                                .nextPage();
                          } else {
                            Navigator.pop(context);
                          }
                        }),
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
