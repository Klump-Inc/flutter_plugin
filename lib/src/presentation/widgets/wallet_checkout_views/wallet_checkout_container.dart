import 'package:flutter/material.dart';
import 'package:klump_checkout/klump_checkout.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

class WalletCheckoutContainer extends StatefulWidget {
  const WalletCheckoutContainer({super.key, required this.params});

  final KCPaymentContainerParams params;

  static dynamic route(BuildContext context, KCPaymentContainerParams params) {
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
      builder: (context) => WalletCheckoutContainer(params: params),
    );
  }

  @override
  State<WalletCheckoutContainer> createState() =>
      _WalletCheckoutContainerState();
}

class _WalletCheckoutContainerState extends State<WalletCheckoutContainer> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenHeight(context) - 67.48,
      child: ChangeNotifierProvider<KCWalletNotifier>(
        create: (_) => KCWalletNotifier(),
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
            child: Consumer<KCWalletNotifier>(
              builder: (_, walletNotifier, __) {
                var views = <Widget>[
                  WalletLogin(
                      params: WalletLoginParams(
                    initiateResponse: widget.params.initiateResponse,
                    email: widget.params.data.email,
                  )),
                  WalletBalance(
                      initiateResponse: widget.params.initiateResponse),
                  WalletTerms(initiateResponse: widget.params.initiateResponse),
                  WalletLoading(
                      initiateResponse: widget.params.initiateResponse),
                  WalletCheckoutSuccess(
                      initiateResponse: widget.params.initiateResponse),
                ];
                return PageView(
                  controller: walletNotifier.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: views,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
