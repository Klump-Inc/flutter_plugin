import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klump_checkout/klump_checkout.dart';
import 'package:klump_checkout/src/presentation/widgets/wallet_checkout_views/wallet_checkout_container.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

class KCBottomSheet extends StatefulWidget {
  final KlumpCheckoutData data;

  const KCBottomSheet({super.key, required this.data});

  static dynamic route(BuildContext context, KlumpCheckoutData data) {
    return showModalBottomSheet<void>(
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      context: context,
      backgroundColor: KCColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(9.92367),
          topRight: Radius.circular(9.92367),
        ),
      ),
      builder: (context) => KCBottomSheet(data: data),
    );
  }

  @override
  State<KCBottomSheet> createState() => _KCBottomSheetState();
}

class _KCBottomSheetState extends State<KCBottomSheet> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    MixPanelService.initMixpanel(
            !dev ? KC_MIX_PANEL_TOKEN_PROD : KC_MIX_PANEL_TOKEN_STAGING)
        .then(
      (value) => MixPanelService.logEvent(
        '1 - Checkout Widget Initiated',
        properties: {'environment': !dev ? 'production' : 'staging'},
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  Future<void> _initiatTranx(KCChangeNotifier checkoutNotifier) async {
    Future.delayed(Duration.zero, () async {
      if (widget.data.email != null && widget.data.phone != null) {
        checkoutNotifier.setTransactionData(widget.data);
        await checkoutNotifier.initiateTransaction(
          email: widget.data.email!,
          phone: widget.data.phone!,
        );
      }
      checkoutNotifier.getLoanPartners();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenHeight(context) - 67.48,
      child: ChangeNotifierProvider<KCChangeNotifier>(
        create: (_) => KCChangeNotifier(),
        child: SafeArea(
          child: OKToast(
            animationDuration: const Duration(milliseconds: 300),
            animationCurve: Curves.easeIn,
            backgroundColor: Colors.black87,
            textPadding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 15,
            ),
            textStyle: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Colors.white),
            radius: 30,
            duration: const Duration(seconds: 3),
            position: ToastPosition.center,
            textAlign: TextAlign.center,
            child: Consumer<KCChangeNotifier>(
              builder: (context, checkoutNotifier, child) {
                return FutureBuilder(
                  future: _initiatTranx(
                      Provider.of<KCChangeNotifier>(context, listen: false)),
                  builder: (context, snapshot) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 26),
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
                                  if (checkoutNotifier
                                          .initiateResponse?.merchant !=
                                      null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text.rich(
                                        TextSpan(children: [
                                          const TextSpan(
                                              text: 'Proud partner of '),
                                          TextSpan(
                                              text: checkoutNotifier
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
                              WalletCheckoutContainer.route(
                                  context, checkoutNotifier.initiateResponse!);
                            },
                          ),
                          const YSpace(16),
                          const KCSecondaryButton(
                            title: 'Pay through Lenders',
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
