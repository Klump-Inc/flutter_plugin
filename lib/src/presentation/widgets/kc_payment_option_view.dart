import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klump_checkout/klump_checkout.dart';
import 'package:provider/provider.dart';

class KCPaymentOptionView extends StatefulWidget {
  const KCPaymentOptionView({super.key, required this.data});
  final KlumpCheckoutData data;

  @override
  State<KCPaymentOptionView> createState() => _KCPaymentOptionViewState();
}

class _KCPaymentOptionViewState extends State<KCPaymentOptionView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _initiateTranx);
  }

  Future<void> _initiateTranx() async {
    final rootNotifier = Provider.of<KCRootNotifier>(context, listen: false);
    if (widget.data.email != null && widget.data.phone != null) {
      rootNotifier.setTransactionData(widget.data);
      await rootNotifier.initiateTransaction(
        email: widget.data.email!,
        phone: widget.data.phone!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Consumer<KCRootNotifier>(
        builder: (context, rootNotifier, child) {
          return Column(
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
                      if (rootNotifier.initiateResponse?.merchant != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text.rich(
                            TextSpan(children: [
                              const TextSpan(text: 'Proud partner of '),
                              TextSpan(
                                  text: rootNotifier.initiateResponse!.merchant
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
                  WalletCheckoutContainer.route(
                    context,
                    KCPaymentContainerParams(
                      initiateResponse: rootNotifier.initiateResponse!,
                      data: widget.data,
                    ),
                  );
                },
              ),
              const YSpace(16),
              const KCSecondaryButton(
                title: 'Pay through Lenders',
              )
            ],
          );
        },
      ),
    );
  }
}

class KCPaymentContainerParams {
  final InitiateResponseModel initiateResponse;
  final KlumpCheckoutData data;

  KCPaymentContainerParams({
    required this.initiateResponse,
    required this.data,
  });
}
