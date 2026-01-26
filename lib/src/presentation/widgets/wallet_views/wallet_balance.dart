import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class WalletBalance extends StatefulWidget {
  const WalletBalance({super.key});

  @override
  State<WalletBalance> createState() => _WalletBalanceState();
}

class _WalletBalanceState extends State<WalletBalance> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final changeNotifier = Provider.of<KCChangeNotifier>(context);
    final stepData = changeNotifier.balancePageWithTopupData?.nextStep;
    Logger().d(stepData?.displayData?.subText);
    final insufficientBalance =
        stepData?.displayData?.subText?.contains('balance is insufficient') ==
            true;
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
                padding: EdgeInsets.only(
                    left: 26,
                    right: 26,
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const DraggableBar(),
                    const YSpace(30.82),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => changeNotifier.prevPage(),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: SvgPicture.asset(
                              KCAssets.arrowBack,
                              package: 'klump_checkout',
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              KCAssets.klumpLogo,
                              package: 'klump_checkout',
                            ),
                            if (changeNotifier.initiateResponse?.merchant !=
                                null)
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
                    const YSpace(24),
                    KCHeadline3(
                      stepData?.displayData?.title ??
                          'Pay through refund wallet',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: KCHeadline5(
                        stepData?.displayData?.subTitle ??
                            'You can complete this purchase with the money in your Klump refund wallet.',
                      ),
                    ),
                    const YSpace(24),
                    if (stepData?.displayData?.smallText != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.42),
                          color: KCColors.white,
                          border:
                              Border.all(color: KCColors.grey1, width: 0.88),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: KCBodyText1(
                                stepData?.displayData?.smallText ?? '',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const XSpace(20),
                            Container(
                              width: 16.67,
                              height: 16.67,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: KCColors.primary),
                              ),
                              child: Center(
                                child: Container(
                                  width: 8.33,
                                  height: 8.33,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: KCColors.primary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const YSpace(12),
                    if (stepData?.displayData?.subText != null)
                      KCBodyText1(
                        stepData?.displayData?.subText ?? '',
                        fontSize: 12,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      )
                    else
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          changeNotifier
                              .setPaymentOption(PaymentOption.lenders);
                          changeNotifier.pageTo(0);
                        },
                        child: KCBodyText1(
                          'Change your mind? Pay through Klump Lenders',
                          decoration: TextDecoration.underline,
                          color: KCColors.lightBlue,
                          decorationColor: KCColors.lightBlue,
                        ),
                      ),
                    const YSpace(25),
                    const Spacer(),
                    if (insufficientBalance)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          KCPrimaryButton(
                            title: 'Top up Wallet',
                            disabled: changeNotifier.isBusy,
                            loading: changeNotifier.isBusy,
                            onTap: () {
                              WalletTopupContainer.route(
                                  context, changeNotifier.initiateResponse!);
                            },
                          ),
                          const YSpace(16),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              changeNotifier
                                  .setPaymentOption(PaymentOption.lenders);
                              changeNotifier.pageTo(0);
                            },
                            child: KCBodyText1(
                              'Change your mind? Pay through Klump Lenders',
                              decoration: TextDecoration.underline,
                              color: KCColors.lightBlue,
                              decorationColor: KCColors.lightBlue,
                            ),
                          ),
                          const YSpace(16),
                        ],
                      )
                    else
                      Column(
                        children: [
                          KCPrimaryButton(
                            title:
                                'Yes, Pay NGN ${KCStringUtil.formatAmount(changeNotifier.totalAmount)}',
                            disabled: changeNotifier.isBusy,
                            loading: changeNotifier.isBusy,
                            onTap: () {
                              changeNotifier.nextPage();
                            },
                          ),
                          const YSpace(16),
                          KCSecondaryButton(
                            title: 'Not enough? Top up wallet',
                            onTap: () {},
                          ),
                        ],
                      )
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
