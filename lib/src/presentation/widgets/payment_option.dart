import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klump_checkout/klump_checkout.dart';
import 'package:provider/provider.dart';

class PaymentOptionView extends StatefulWidget {
  const PaymentOptionView({super.key, required this.data});
  final KlumpCheckoutData data;

  @override
  State<PaymentOptionView> createState() => _PaymentOptionViewState();
}

class _PaymentOptionViewState extends State<PaymentOptionView> {
  @override
  void initState() {
    Future.delayed(Duration.zero, _initiatTranx);
    super.initState();
  }

  void _initiatTranx() {
    final checkoutNotifier = context.read<KCChangeNotifier>();
    Future.delayed(Duration.zero, () async {
      if (widget.data.email != null && widget.data.phone != null) {
        checkoutNotifier.setTransactionData(
          widget.data,
          email: widget.data.email!,
          phone: widget.data.phone!,
        );
      }
      final refundWallet = await checkoutNotifier.initiateTransaction();
      if (refundWallet == true) {
        checkoutNotifier.getLoanPartners();
      } else if (refundWallet == false) {
        checkoutNotifier.nextPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26),
        child: Consumer<KCChangeNotifier>(
          builder: (context, changeNotifier, child) {
            return changeNotifier.initiateResponse == null
                ? SizedBox(
                    height: 30,
                    width: 30,
                    child: Platform.isIOS
                        ? const CupertinoActivityIndicator(
                            radius: 15.0, color: KCColors.primary)
                        : const Center(
                            child: CircularProgressIndicator(
                              color: KCColors.primary,
                              strokeWidth: 3,
                            ),
                          ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const DraggableBar(),
                      const YSpace(30.82),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () => Navigator.pop(context),
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
                                              .initiateResponse!.merchant
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
                        'Pay through refund wallet',
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: KCHeadline5(
                            'You can complete this purchase with the money in your Klump refund wallet.'),
                      ),
                      const YSpace(24),
                      const YSpace(30.22),
                      const Spacer(),
                      KCPrimaryButton(
                        title: 'Pay through Wallet',
                        onTap: () {
                          changeNotifier
                              .setPaymentOption(PaymentOption.refundWallet);
                        },
                      ),
                      const YSpace(16),
                      KCSecondaryButton(
                        onTap: () {
                          changeNotifier
                              .setPaymentOption(PaymentOption.lenders);
                        },
                        title: 'Pay through Lenders',
                      )
                    ],
                  );
          },
        ),
      ),
    );
  }
}
