import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class WalletTerms extends StatefulWidget {
  const WalletTerms({super.key});

  @override
  State<WalletTerms> createState() => _WalletTermsState();
}

class _WalletTermsState extends State<WalletTerms> {
  final ValueNotifier<bool> _accepted = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final changeNotifier = Provider.of<KCChangeNotifier>(context);
    final stepData = changeNotifier.walletTermsStepData?.nextStep;
    final checkBoxFields =
        stepData?.formFields?.where((e) => e.type == 'checkbox').toList();
    final paymentDetails = stepData?.displayData?.list ?? [];
    final totalAmount = paymentDetails.isNotEmpty
        ? paymentDetails.first['title']['value']
            .toString()
            .replaceAll('NGN', '')
            .replaceAll(',', '')
        : null;

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
                          onTap: () => changeNotifier.prevPage(),
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
                            if (changeNotifier.initiateResponse?.merchant !=
                                null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text.rich(
                                  TextSpan(children: [
                                    const TextSpan(text: 'Proud partner of '),
                                    TextSpan(
                                        text: changeNotifier
                                            .initiateResponse?.merchant
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
                      'Make full payment',
                    ),
                    const YSpace(24),
                    if (paymentDetails.isNotEmpty)
                      ...paymentDetails
                          .map((e) => RepaymentTile(paymentDetail: e)),
                    const YSpace(25),
                    const Spacer(),
                    if (checkBoxFields?.isNotEmpty == true)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 5),
                            child: SizedBox(
                              height: 16,
                              width: 16,
                              child: ValueListenableBuilder<bool>(
                                valueListenable: _accepted,
                                builder: (_, accepted, __) {
                                  return Checkbox(
                                    value: accepted,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.padded,
                                    onChanged: (value) {
                                      _accepted.value = value ?? false;
                                    },
                                    activeColor: KCColors.primary,
                                    side: const BorderSide(
                                        color: KCColors.primary, width: 2),
                                  );
                                },
                              ),
                            ),
                          ),
                          const XSpace(10.5),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text:
                                        'I agree to this according to Klump’s ',
                                  ),
                                  TextSpan(
                                    text: 'Customer Agreement',
                                    style: const TextStyle(
                                      color: KCColors.black3,
                                      fontWeight: FontWeight.w800,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        if (!await launchUrl(
                                          Uri.parse(
                                              "https://useklump.com/legal/terms-of-service-customer"),
                                          mode: LaunchMode.externalApplication,
                                        )) {
                                          // ignore: avoid_print
                                          print('Could not open link');
                                        }
                                      },
                                  ),
                                  const TextSpan(text: ' and'),
                                  TextSpan(
                                    text: ' Terms and Conditions',
                                    style: const TextStyle(
                                      color: KCColors.black3,
                                      fontWeight: FontWeight.w800,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        if (!await launchUrl(
                                          Uri.parse(
                                              "https://useklump.com/legal/terms-of-service"),
                                          mode: LaunchMode.externalApplication,
                                        )) {
                                          // ignore: avoid_print
                                          print('Could not open link');
                                        }
                                      },
                                  )
                                ],
                              ),
                              style: const TextStyle(
                                color: KCColors.grey5,
                                fontSize: 11,
                                height: 1.818,
                                fontFamily: KCFonts.avenir,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    const YSpace(16),
                    ValueListenableBuilder<bool>(
                      valueListenable: _accepted,
                      builder: (context, isChecked, child) {
                        return KCPrimaryButton(
                          title: 'Yes, Pay $totalAmount',
                          disabled: !isChecked || changeNotifier.isBusy,
                          loading: changeNotifier.isBusy,
                          onTap: () => changeNotifier.acceptWalletTerms(),
                        );
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

class RepaymentTile extends StatelessWidget {
  const RepaymentTile({
    super.key,
    required this.paymentDetail,
  });

  final Map<String, dynamic> paymentDetail;

  @override
  Widget build(BuildContext context) {
    final title = paymentDetail['title']['text'];
    final value = paymentDetail['title']['value'];
    final subtitle = paymentDetail['subtitle']['text'];
    final color = paymentDetail['color'];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Container(
            height: 11.34,
            width: 11.34,
            decoration: BoxDecoration(
              color: color == 'green' ? KCColors.green : KCColors.grey5,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const XSpace(8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: KCHeadline3(
                      title,
                      fontSize: 15,
                      color: color == 'green' ? KCColors.green : KCColors.grey5,
                    ),
                  ),
                  const XSpace(20),
                  Expanded(
                    child: KCHeadline3(
                      value,
                      fontSize: 15,
                      color: color == 'green' ? KCColors.green : KCColors.grey5,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
              const YSpace(4),
              KCBodyText1(
                subtitle,
                color: KCColors.grey5,
              )
            ],
          ),
        )
      ],
    );
  }
}
