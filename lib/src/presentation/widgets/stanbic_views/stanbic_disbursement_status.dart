import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klump_checkout/klump_checkout.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:provider/provider.dart';

class StanbicDisbursementStatus extends StatefulWidget {
  const StanbicDisbursementStatus({super.key});

  @override
  State<StanbicDisbursementStatus> createState() =>
      _StanbicDisbursementStatusState();
}

class _StanbicDisbursementStatusState extends State<StanbicDisbursementStatus> {
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
                              checkoutNotifier.stanbicStatusResponse
                                          ?.isSuccessful ==
                                      true
                                  ? KCAssets.successIllus
                                  : KCAssets.failureIllus,
                              package: KC_PACKAGE_NAME,
                            ),
                          ),
                          const YSpace(22),
                          KCHeadline3(
                            checkoutNotifier
                                        .stanbicStatusResponse?.isSuccessful ==
                                    true
                                ? 'Successful'
                                : 'Unsuccessful',
                            fontSize: 27,
                            textAlign: TextAlign.center,
                            height: 1.4318,
                          ),
                          const YSpace(8),
                          KCBodyText1(
                            checkoutNotifier
                                        .stanbicStatusResponse?.isSuccessful ==
                                    true
                                ? 'Loan disbursement successful \nYour next pay date is ${checkoutNotifier.repaymentDetails!.repaymentSchedules.first.repaymentDate}'
                                : checkoutNotifier
                                        .stanbicStatusResponse?.message ??
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
                                  .stanbicStatusResponse?.isSuccessful ==
                              true
                          ? 'Continue'
                          : 'Go back',
                      onTap: () {
                        final checkoutResponse = KlumpCheckoutResponse(
                          checkoutNotifier
                                      .stanbicStatusResponse?.isSuccessful ==
                                  true
                              ? CheckoutStatus.success
                              : CheckoutStatus.error,
                          checkoutNotifier.stanbicStatusResponse?.message ?? '',
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
