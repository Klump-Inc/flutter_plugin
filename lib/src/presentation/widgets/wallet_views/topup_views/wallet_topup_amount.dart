import 'dart:async';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:provider/provider.dart';

class WalletTopupAmount extends StatefulWidget {
  const WalletTopupAmount(
      {super.key, required this.initiateResponse, required this.amount});
  final InitiateResponseModel initiateResponse;

  final double amount;

  @override
  State<WalletTopupAmount> createState() => _WalletTopupAmountState();
}

class _WalletTopupAmountState extends State<WalletTopupAmount> {
  late TextEditingController _amountCtrl;
  late StreamController<String> amountStreamCtrl;
  final ValueNotifier<bool> _enabled = ValueNotifier(false);

  void validateInputs() {
    final amount = _amountCtrl.text.replaceAll(RegExp(r'[^0-9.]'), '');
    if (amount.isNotEmpty && double.tryParse(amount) != null) {
      _enabled.value = true;
    } else {
      _enabled.value = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _amountCtrl = TextEditingController();
    amountStreamCtrl = StreamController<String>.broadcast();

    _amountCtrl.addListener(() {
      amountStreamCtrl.sink.add(_amountCtrl.text.trim());
      validateInputs();
    });
    Future.delayed(Duration.zero, () {
      if (widget.initiateResponse.totalAmountToBePaid != null) {
        final totalAmount = double.tryParse(
            widget.initiateResponse.totalAmountToBePaid!.toString());
        if (totalAmount != null) {
          _amountCtrl.text = 'NGN ${KCStringUtil.formatAmount(widget.amount)}';
          amountStreamCtrl.sink.add(_amountCtrl.text.trim());
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _amountCtrl.dispose();
    amountStreamCtrl.close();
  }

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
                      'Enter an amount',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: KCHeadline5(
                        'How much do you want to add to the wallet?',
                      ),
                    ),
                    const YSpace(24),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.42),
                        color: KCColors.white,
                        border: Border.all(color: KCColors.grey1, width: 0.88),
                      ),
                      child: StreamBuilder<String>(
                        stream: amountStreamCtrl.stream,
                        builder: (context, snapshot) {
                          return TextField(
                            controller: _amountCtrl,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9.,]')),
                              CurrencyTextInputFormatter.currency(
                                locale: 'en_NG',
                                decimalDigits: 2,
                                symbol: 'NGN ',
                              ),
                            ],
                            style: const TextStyle(
                              color: KCColors.black3,
                              fontSize: 15,
                              fontFamily: KCFonts.avenir,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'NGN 0.00',
                              hintStyle: TextStyle(
                                color: KCColors.grey2,
                                fontSize: 15,
                                fontFamily: KCFonts.avenir,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                          );
                        },
                      ),
                    ),
                    const YSpace(25),
                    const Spacer(),
                    ValueListenableBuilder<bool>(
                      valueListenable: _enabled,
                      builder: (_, enabled, __) {
                        return KCPrimaryButton(
                          title: 'Continue',
                          disabled: !enabled || topupNotifier.isBusy,
                          loading: topupNotifier.isBusy,
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            topupNotifier.nextPage();
                          },
                        );
                      },
                    ),
                    const YSpace(10),
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
