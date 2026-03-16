import 'package:flutter/material.dart';
import 'package:klump_checkout/klump_checkout.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

class WalletTopupContainer extends StatefulWidget {
  const WalletTopupContainer(
      {super.key, required this.initiateResponse, required this.amount});

  final InitiateResponseModel initiateResponse;
  final double amount;

  static dynamic route(BuildContext context,
      InitiateResponseModel initiateResponse, double amount) {
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
      builder: (context) => WalletTopupContainer(
          initiateResponse: initiateResponse, amount: amount),
    );
  }

  @override
  State<WalletTopupContainer> createState() => _WalletTopupContainerState();
}

class _WalletTopupContainerState extends State<WalletTopupContainer> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenHeight(context) - 67.48,
      child: ChangeNotifierProvider<KCTopupNotifier>(
        create: (_) => KCTopupNotifier(),
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
            child: Consumer<KCTopupNotifier>(
              builder: (_, topupNotifier, __) {
                var views = <Widget>[
                  WalletTopupAmount(
                      initiateResponse: widget.initiateResponse,
                      amount: widget.amount),
                  WalletTopupDetails(initiateResponse: widget.initiateResponse),
                  TopupChecking(initiateResponse: widget.initiateResponse),
                  WalletTopupSuccess(initiateResponse: widget.initiateResponse),
                ];
                return PageView(
                  controller: topupNotifier.pageController,
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
