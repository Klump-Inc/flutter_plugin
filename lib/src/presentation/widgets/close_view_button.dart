import 'package:flutter/material.dart';
import 'package:klump_checkout/klump_checkout.dart';
import 'package:provider/provider.dart';

class CloseViewButton extends StatelessWidget {
  const CloseViewButton({
    super.key,
    this.onTap,
  });
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () {
            final lendersNotifier = Provider.of<KCLendersNotifier>(context);

            showModalBottomSheet<void>(
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
              builder: (context) => FeedbackView(
                params: FeedbackViewArgument(
                  email: lendersNotifier.email ?? '',
                  phoneNumber: lendersNotifier.phoneNumber ?? '',
                  publicKey: lendersNotifier.checkoutData!.merchantPublicKey,
                  merchant: lendersNotifier.initiateResponse?.merchant,
                  isLive: lendersNotifier.initiateResponse?.isLive == true,
                ),
              ),
            );
          },
      behavior: HitTestBehavior.opaque,
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(
          Icons.close,
          color: KCColors.primary,
        ),
      ),
    );
  }
}
