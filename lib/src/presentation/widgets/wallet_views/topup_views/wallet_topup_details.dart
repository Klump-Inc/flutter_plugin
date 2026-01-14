import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

class WalletTopupDetails extends StatefulWidget {
  const WalletTopupDetails({super.key, required this.initiateResponse});
  final InitiateResponseModel initiateResponse;

  @override
  State<WalletTopupDetails> createState() => _WalletTopupDetailsState();
}

class _WalletTopupDetailsState extends State<WalletTopupDetails> {
  // These values should ideally come from the API/state management
  String get amount => 'NGN 100,000';
  String get accountNumber => '0123456789';
  String get bankName => 'VFD Microfinance Bank';
  String get accountName => 'Klump Wallet';

  @override
  Widget build(BuildContext context) {
    final topupNotifier = Provider.of<KCTopupNotifier>(context);

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
                          onTap: () => topupNotifier.prevPage(),
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
                            if (widget.initiateResponse.merchant != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text.rich(
                                  TextSpan(children: [
                                    const TextSpan(text: 'Proud partner of '),
                                    TextSpan(
                                        text: widget.initiateResponse.merchant
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
                        'You can complete this purchase with the money in your Klump refund wallet.',
                      ),
                    ),
                    const YSpace(24),
                    // Amount field
                    KCPaymentItemTile(label: 'Amount', value: amount),
                    const YSpace(12),
                    // Account Number field with copy icon
                    KCPaymentItemTile(
                      label: 'Account Number',
                      value: accountNumber,
                      trailing: InkWell(
                        onTap: () {
                          FlutterClipboard.copy(accountNumber).then(
                            (value) => showToast(
                              'Copied to clipboard',
                              position: ToastPosition.center,
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: SvgPicture.asset(
                            KCAssets.copy2,
                            package: 'klump_checkout',
                          ),
                        ),
                      ),
                    ),
                    const YSpace(12),
                    // Bank Name field
                    KCPaymentItemTile(label: 'Bank Name', value: bankName),
                    const YSpace(12),
                    // Account Name field
                    KCPaymentItemTile(
                        label: 'Account Name', value: accountName),
                    const YSpace(25),
                    const Spacer(),
                    KCPrimaryButton(
                      title: 'I have completed the transfer',
                      disabled: topupNotifier.isBusy,
                      loading: topupNotifier.isBusy,
                      onTap: () {
                        FocusScope.of(context).unfocus();

                        topupNotifier.nextPage();
                        // Handle transfer completion
                      },
                    ),
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

class KCPaymentItemTile extends StatelessWidget {
  const KCPaymentItemTile({
    super.key,
    required this.label,
    required this.value,
    this.trailing,
  });

  final String label;
  final String value;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.42),
        color: KCColors.white,
        border: Border.all(color: KCColors.grey1, width: 0.88),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          KCHeadline5(
            label,
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: KCColors.black4,
          ),
          if (trailing != null)
            Row(
              children: [
                KCBodyText1(
                  value,
                  fontSize: 15,
                  color: KCColors.black4,
                ),
                const XSpace(8),
                trailing!
              ],
            )
          else
            KCBodyText1(
              value,
              fontSize: 15,
              color: KCColors.black4,
            ),
        ],
      ),
    );
  }
}
