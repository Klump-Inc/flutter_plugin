import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klump_checkout/klump_checkout.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:provider/provider.dart';

class PartnerDisbursementStatus extends StatefulWidget {
  const PartnerDisbursementStatus({super.key});

  @override
  State<PartnerDisbursementStatus> createState() =>
      _PartnerDisbursementStatusState();
}

class _PartnerDisbursementStatusState extends State<PartnerDisbursementStatus> {
  @override
  Widget build(BuildContext context) {
    var checkoutNotifier =
        Provider.of<KCChangeNotifier>(context, listen: false);
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
                    Image.network(
                      checkoutNotifier.selectedBankFlow?.logo ?? '',
                      height: 55,
                      width: 47,
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
                              checkoutNotifier.disbursementStatusResponse
                                          ?.isSuccessful ==
                                      true
                                  ? KCAssets.successIllus
                                  : KCAssets.failureIllus,
                              package: KC_PACKAGE_NAME,
                            ),
                          ),
                          const YSpace(22),
                          KCHeadline3(
                            checkoutNotifier.disbursementStatusResponse
                                        ?.isSuccessful ==
                                    true
                                ? 'Successful'
                                : 'Unsuccessful',
                            fontSize: 27,
                            textAlign: TextAlign.center,
                            height: 1.4318,
                          ),
                          const YSpace(8),
                          KCBodyText1(
                            checkoutNotifier.disbursementStatusResponse
                                        ?.isSuccessful ==
                                    true
                                ? '${checkoutNotifier.disbursementStatusResponse?.message}${checkoutNotifier.disbursementStatusResponse?.next_repayment_date != null ? ' \nYour next pay date is ${checkoutNotifier.disbursementStatusResponse?.next_repayment_date}' : ''}'
                                : checkoutNotifier
                                        .disbursementStatusResponse?.message ??
                                    '',
                            fontSize: 16,
                            textAlign: TextAlign.center,
                            height: 1.36625,
                          ),
                        ],
                      ),
                    ),
                    const YSpace(24),
                    KCPrimaryButton(
                      title: checkoutNotifier
                                  .disbursementStatusResponse?.isSuccessful ==
                              true
                          ? 'Continue'
                          : 'Go back',
                      onTap: () {
                        final checkoutResponse = KlumpCheckoutResponse(
                          checkoutNotifier.disbursementStatusResponse
                                      ?.isSuccessful ==
                                  true
                              ? CheckoutStatus.success
                              : CheckoutStatus.error,
                          checkoutNotifier
                                  .disbursementStatusResponse?.message ??
                              '',
                          null,
                        );
                        Navigator.pop(context, checkoutResponse);
                      },
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
