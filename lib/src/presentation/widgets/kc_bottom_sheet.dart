import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klump_checkout/klump_checkout.dart';
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
            child: KCPaymentOptionView(data: widget.data),
          ),
        ),
      ),
    );
  }
}
