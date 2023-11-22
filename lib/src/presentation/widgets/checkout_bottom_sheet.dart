import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klump_checkout/klump_checkout.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

class KCBottomSheet extends StatefulWidget {
  final bool isLive;
  final KlumpCheckoutData data;

  const KCBottomSheet({super.key, required this.data, required this.isLive});

  static dynamic route(
      BuildContext context, KlumpCheckoutData data, bool isLive) {
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
      builder: (context) => KCBottomSheet(data: data, isLive: isLive),
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
    MixPanelService.initMixpanel(widget.isLive
            ? KC_MIX_PANEL_TOKEN_PROD
            : KC_MIX_PANEL_TOKEN_STAGING)
        .then(
      (value) => MixPanelService.logEvent(
        ' Checkout Widget Initiated',
        properties: {'environment': widget.isLive ? 'production' : 'staging'},
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: SizedBox(
        height: screenHeight(context) - 67.48,
        child: ChangeNotifierProvider<KCChangeNotifier>(
          create: (_) => KCChangeNotifier(),
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
            child: Column(
              children: [
                const YSpace(4.6),
                Container(
                  height: 4.96,
                  width: 35.73,
                  decoration: BoxDecoration(
                    color: KCColors.black2.withOpacity(0.24),
                    borderRadius: BorderRadius.circular(9.92367),
                  ),
                ),
                Expanded(
                  child: Consumer<KCChangeNotifier>(
                    builder: (_, checkoutNotifier, __) {
                      var views = <Widget>[
                        SelectBankFlow(
                          data: widget.data,
                          isLive: widget.isLive,
                        ),
                        if (checkoutNotifier.selectedBankFlow?.slug ==
                                'polaris' ||
                            checkoutNotifier.selectedBankFlow?.slug == 'specta')
                          const PartnerMobileExperience(),
                        if (checkoutNotifier.selectedBankFlow?.slug ==
                            'polaris')
                          const PartnerInformation(),
                        const PartnerLogin(),
                        const PartnerLoginOTP(),
                        if (checkoutNotifier.selectedBankFlow?.slug ==
                            'stanbic')
                          const PartnerTerms(),
                        if (checkoutNotifier.selectedBankFlow?.slug != 'specta')
                          const PartnerPaymentSplit(),
                        if (checkoutNotifier.selectedBankFlow?.slug != 'specta')
                          const PartnerPaymentPreview(),
                        if (checkoutNotifier
                                .klumpUser?.requiresUserCredential ==
                            true)
                          const PartnerAccountCredentials(),
                        if (checkoutNotifier.selectedBankFlow?.slug !=
                            'stanbic')
                          const PartnerInvoice(),
                        if (checkoutNotifier.selectedBankFlow?.slug ==
                            'stanbic')
                          const PartnerConfirmation(),
                        const PartnerDecision(),
                        const PartnerDisbursementStatus(),
                      ];
                      return PageView(
                        controller: checkoutNotifier.pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: views,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
