import 'package:flutter/material.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:provider/provider.dart';

class PartnerConfirmation extends StatefulWidget {
  const PartnerConfirmation({super.key});

  @override
  State<PartnerConfirmation> createState() => _PartnerConfirmationState();
}

class _PartnerConfirmationState extends State<PartnerConfirmation> {
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
                          const YSpace(22),
                          Column(
                            children: [
                              KCHeadline3(
                                'Confirmation',
                                fontSize: 27,
                                textAlign: TextAlign.center,
                                height: 1.4318,
                              ),
                              const YSpace(8),
                              KCBodyText1(
                                'If you click continue, you can no \nlonger cancel your loan',
                                fontSize: 16,
                                textAlign: TextAlign.center,
                                height: 1.875,
                              ),
                              const YSpace(8),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const YSpace(24),
                    KCPrimaryButton(
                      title: 'Continue',
                      disabled: checkoutNotifier.isBusy,
                      loading: checkoutNotifier.isBusy,
                      onTap: () =>
                          Provider.of<KCChangeNotifier>(context, listen: false)
                              .createLoan(),
                    ),
                    const YSpace(16),
                    KCSecondaryButton(
                      title: 'Go back',
                      disabled: checkoutNotifier.isBusy,
                      onTap: () => checkoutNotifier.prevPage(),
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
