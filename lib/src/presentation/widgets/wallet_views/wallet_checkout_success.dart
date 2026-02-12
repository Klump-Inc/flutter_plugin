import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class WalletCheckoutSuccess extends StatefulWidget {
  const WalletCheckoutSuccess({
    super.key,
  });

  @override
  State<WalletCheckoutSuccess> createState() => _WalletCheckoutSuccessState();
}

class _WalletCheckoutSuccessState extends State<WalletCheckoutSuccess> {
  @override
  Widget build(BuildContext context) {
    final changeNotifier = Provider.of<KCChangeNotifier>(context);
    final stepData = changeNotifier.walletFinalStepData;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: constraints.maxWidth,
            minHeight: constraints.maxHeight,
          ),
          child: IntrinsicHeight(
            child: Padding(
              padding: EdgeInsets.only(
                  left: 26,
                  right: 26,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const DraggableBar(),
                  const YSpace(30.82),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 30),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            KCAssets.klumpLogo,
                            package: 'klump_checkout',
                          ),
                          if (changeNotifier.initiateResponse?.merchant != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text.rich(
                                TextSpan(children: [
                                  const TextSpan(text: 'Proud partner of '),
                                  TextSpan(
                                      text: changeNotifier
                                          .initiateResponse?.merchant
                                          .toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700)),
                                ]),
                                style: const TextStyle(
                                  color: KCColors.black1,
                                  fontSize: 16,
                                  fontFamily: KCFonts.avenir,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          else
                            const YSpace(26),
                        ],
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          KCAssets.successIllus,
                          package: KC_PACKAGE_NAME,
                        ),
                        const YSpace(24),
                        KCHeadline3(
                          'Successful',
                          fontSize: 27,
                          textAlign: TextAlign.center,
                          height: 1.4318,
                        ),
                        const YSpace(8),
                        KCBodyText1(
                          'Your payment is successful',
                          fontSize: 16,
                          textAlign: TextAlign.center,
                          height: 1.36625,
                        ),
                      ],
                    ),
                  ),
                  const YSpace(50),
                  KCPrimaryButton(
                    title: 'Back to merchant',
                    disabled: changeNotifier.isBusy,
                    loading: changeNotifier.isBusy,
                    onTap: () {
                      final checkoutResponse = KlumpCheckoutResponse(
                          CheckoutStatus.success,
                          stepData?.message as String? ??
                              'Payment completed successfully.',
                          stepData?.data);
                      Logger().d(checkoutResponse);
                      Navigator.pop(context, checkoutResponse);
                    },
                  ),
                  const YSpace(16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
