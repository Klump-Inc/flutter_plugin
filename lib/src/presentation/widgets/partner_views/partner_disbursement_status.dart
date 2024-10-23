import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klump_checkout/klump_checkout.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class PartnerDisbursementStatus extends StatelessWidget {
  const PartnerDisbursementStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final checkoutNotfier = Provider.of<KCChangeNotifier>(context);
    final stepData = checkoutNotfier.finalLoanStep;
    Logger().d(stepData?.displayData?.title);
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
                    Align(
                      child: Image.network(
                        checkoutNotfier.selectedBankFlow?.logo ?? '',
                        height: 40,
                        width: 120,
                      ),
                    ),
                    if (checkoutNotfier.initiateResponse?.merchant != null)
                      Align(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: KCHeadline4(
                            checkoutNotfier.initiateResponse!.merchant
                                .toString(),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    const YSpace(16),
                    const YSpace(24),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 187.1,
                            width: 187.1,
                            child: SvgPicture.asset(
                              checkoutNotfier.disbursementStatusResponse
                                          ?.isSuccessful ==
                                      true
                                  ? KCAssets.successIllus
                                  : KCAssets.failureIllus,
                              package: KC_PACKAGE_NAME,
                            ),
                          ),
                          const YSpace(22),
                          KCHeadline3(
                            checkoutNotfier.selectedBankFlow?.slug ==
                                        'renmoney' &&
                                    stepData?.displayData?.title?.isNotEmpty ==
                                        true
                                ? stepData!.displayData!.title!
                                : checkoutNotfier.disbursementStatusResponse
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
                            checkoutNotfier.selectedBankFlow?.slug ==
                                        'renmoney' &&
                                    stepData?.displayData?.subTitle
                                            ?.isNotEmpty ==
                                        true
                                ? stepData!.displayData!.subTitle!
                                : checkoutNotfier.disbursementStatusResponse
                                            ?.isSuccessful ==
                                        true
                                    ? '${checkoutNotfier.disbursementStatusResponse?.message}${checkoutNotfier.disbursementStatusResponse?.next_repayment_date != null ? ' \nYour next pay date is ${checkoutNotfier.disbursementStatusResponse?.next_repayment_date}' : ''}'
                                    : checkoutNotfier.disbursementStatusResponse
                                            ?.message ??
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
                      title:
                          checkoutNotfier.selectedBankFlow?.slug == 'renmoney'
                              ? 'Finish'
                              : checkoutNotfier.disbursementStatusResponse
                                          ?.isSuccessful ==
                                      true
                                  ? 'Continue'
                                  : 'Go back',
                      onTap: () {
                        final checkoutResponse = KlumpCheckoutResponse(
                          checkoutNotfier.disbursementStatusResponse
                                      ?.isSuccessful ==
                                  true
                              ? CheckoutStatus.success
                              : CheckoutStatus.error,
                          checkoutNotfier.disbursementStatusResponse?.message ??
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
