import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:klump_checkout/klump_checkout.dart';
import 'package:provider/provider.dart';

class PartnerMobileExperience extends StatelessWidget {
  const PartnerMobileExperience({super.key});

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const YSpace(30.82),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: checkoutNotifier.prevPage,
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: SvgPicture.asset(
                            KCAssets.arrowBack,
                            package: KC_PACKAGE_NAME,
                          ),
                        ),
                      ),
                    ),
                    const YSpace(14.7),
                    Align(
                      child: Image.network(
                        checkoutNotifier.selectedBankFlow!.logo ?? '',
                        height: 55,
                        width: 47,
                      ),
                    ),
                    const YSpace(24),
                    const Spacer(),
                    Align(
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            KCAssets.computer,
                            package: KC_PACKAGE_NAME,
                          ),
                          const YSpace(25.45),
                          KCBodyText1(
                            'Use a computer for a better \npayment experience',
                            textAlign: TextAlign.center,
                            height: 1.875,
                          )
                        ],
                      ),
                    ),
                    const YSpace(24),
                    const Spacer(),
                    KCPrimaryButton(
                      title: 'Continue anyway',
                      onTap: () =>
                          Provider.of<KCChangeNotifier>(context, listen: false)
                              .nextPage(),
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
