import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klump_checkout/klump_checkout.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:provider/provider.dart';

class PartnerDisbursementStatus extends StatelessWidget {
  const PartnerDisbursementStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final lendersNotfier = Provider.of<KCLendersNotifier>(context);
    final stepData = lendersNotfier.loanStatusStepData?.nextStep;
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
                    const DraggableBar(),
                    const YSpace(24),
                    Align(
                      child: KCNetworkImage(
                        url: lendersNotfier.selectedBankFlow?.logo,
                        height: 55,
                        width: 120,
                      ),
                    ),
                    if (lendersNotfier.initiateResponse?.merchant != null)
                      Align(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: KCHeadline4(
                            lendersNotfier.initiateResponse!.merchant
                                .toString(),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    const YSpace(24),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: lendersNotfier.disbursementStatusResponse
                                        ?.isSuccessful ==
                                    true
                                ? 187.1
                                : 130,
                            width: 187.1,
                            child: lendersNotfier.selectedBankFlow?.slug ==
                                    'renmoney'
                                ? Image.asset(
                                    KCAssets.loading,
                                    package: KC_PACKAGE_NAME,
                                  )
                                : SvgPicture.asset(
                                    lendersNotfier.disbursementStatusResponse
                                                ?.isSuccessful ==
                                            true
                                        ? KCAssets.successIllus
                                        : KCAssets.failureIllus,
                                    package: KC_PACKAGE_NAME,
                                  ),
                          ),
                          const YSpace(22),
                          KCHeadline3(
                            lendersNotfier.selectedBankFlow?.slug ==
                                        'renmoney' &&
                                    stepData?.displayData?.title?.isNotEmpty ==
                                        true
                                ? stepData!.displayData!.title!
                                : lendersNotfier.disbursementStatusResponse
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
                            lendersNotfier.selectedBankFlow?.slug ==
                                        'renmoney' &&
                                    stepData?.displayData?.subTitle
                                            ?.isNotEmpty ==
                                        true
                                ? stepData!.displayData!.subTitle!
                                : lendersNotfier.disbursementStatusResponse
                                            ?.isSuccessful ==
                                        true
                                    ? '${lendersNotfier.disbursementStatusResponse?.message}${lendersNotfier.disbursementStatusResponse?.next_repayment_date != null ? ' \nYour next pay date is ${lendersNotfier.disbursementStatusResponse?.next_repayment_date}' : ''}'
                                    : lendersNotfier.disbursementStatusResponse
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
                      title: lendersNotfier.selectedBankFlow?.slug == 'renmoney'
                          ? 'Finish'
                          : lendersNotfier.disbursementStatusResponse
                                      ?.isSuccessful ==
                                  true
                              ? 'Continue'
                              : 'Go back',
                      onTap: () {
                        final checkoutResponse = KlumpCheckoutResponse(
                          lendersNotfier.disbursementStatusResponse
                                      ?.isSuccessful ==
                                  true
                              ? lendersNotfier.selectedBankFlow?.slug ==
                                      'renmoney'
                                  ? CheckoutStatus.pending
                                  : CheckoutStatus.success
                              : CheckoutStatus.error,
                          lendersNotfier.disbursementStatusResponse?.message ??
                              '',
                          lendersNotfier
                              .disbursementStatusResponse?.transaction,
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
