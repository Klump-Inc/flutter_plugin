import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klump_checkout/klump_checkout.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:provider/provider.dart';

class KCBottomSheet extends StatefulWidget {
  final KlumpCheckoutData data;

  const KCBottomSheet({super.key, required this.data});

  static dynamic route(BuildContext context, KlumpCheckoutData data) {
    return showModalBottomSheet<void>(
      isDismissible: false,
      context: context,
      backgroundColor: KCColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(9.92367),
          topRight: Radius.circular(9.92367),
        ),
      ),
      isScrollControlled: true,
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
                builder: (_, value, __) {
                  final views = <Widget>[
                    SelectBankFlow(data: widget.data),
                    const StanbicLogin(),
                    const StanbicLoginOTP(),
                    const StanbicTerms(),
                    const StanbicDecision(),
                    const StanbicPaymentSplit(),
                    const StanbicPaymentPreview(),
                    const StanbicDecisionStatus(),
                    const StanbicDisbursementStatus()
                  ];
                  return PageView(
                    controller: value.pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: views,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
