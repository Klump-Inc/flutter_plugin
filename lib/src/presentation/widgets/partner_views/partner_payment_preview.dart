import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PartnerPaymentPreview extends StatefulWidget {
  const PartnerPaymentPreview({super.key});

  @override
  State<PartnerPaymentPreview> createState() => _PartnerPaymentPreviewState();
}

class _PartnerPaymentPreviewState extends State<PartnerPaymentPreview> {
  final ValueNotifier<bool> _accepted = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final checkoutNotifier = Provider.of<KCChangeNotifier>(context);
    final stepData = checkoutNotifier.repaymentDetailsStepData?.nextStep ??
        checkoutNotifier.selectedBankFlow?.nextStep;
    final checkBoxFields =
        stepData?.formFields?.where((e) => e.type == 'checkbox').toList();
    final repaymentDetails = stepData?.displayData?.list ?? [];
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return ConstrainedBox(
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
                  const YSpace(24),
                  LogoHeaderWidget(
                    onTap: checkoutNotifier.prevPage,
                    logo: Image.network(
                      checkoutNotifier.selectedBankFlow!.logo ?? '',
                      height: 55,
                      width: 120,
                    ),
                  ),
                  if (checkoutNotifier.initiateResponse?.merchant != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Align(
                        child: KCHeadline4(
                          checkoutNotifier.initiateResponse!.merchant
                              .toString(),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  const YSpace(24),
                  KCHeadline3(
                    stepData?.displayData?.title ?? '',
                  ),
                  if (stepData?.displayData?.subTitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: KCHeadline5(stepData?.displayData?.subTitle ?? ''),
                    ),
                  const YSpace(24),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 6.04, bottom: 20.5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                repaymentDetails.length,
                                (index) => KPPaymentItemTile(
                                  title: repaymentDetails[index]['title']
                                          ['text']
                                      .toString(),
                                  amount: repaymentDetails[index]['title']
                                          ['value']
                                      .toString(),
                                  subtitle: repaymentDetails[index]['subtitle']
                                          ['text']
                                      .toString(),
                                  note: repaymentDetails[index]['subtitle']
                                          ['value']
                                      .toString(),
                                  colorValue: repaymentDetails[index]['color']
                                      .toString(),
                                  bodyLines: 2,
                                  lastItem:
                                      index == repaymentDetails.length - 1,
                                ),
                              ),
                            ),
                            const YSpace(18),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const YSpace(10),
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
                                  text: 'I agree to this according to Klump’s ',
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
                  const YSpace(24),
                  ValueListenableBuilder<bool>(
                    valueListenable: _accepted,
                    builder: (_, accepted, __) {
                      return KCPrimaryButton(
                        title: 'Continue',
                        disabled: !accepted || checkoutNotifier.isBusy,
                        loading: checkoutNotifier.isBusy,
                        onTap: () => checkoutNotifier.acceptTerms(),
                      );
                    },
                  ),
                  const YSpace(59)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class KPPaymentItemTile extends StatelessWidget {
  const KPPaymentItemTile({
    super.key,
    required this.title,
    required this.amount,
    required this.subtitle,
    required this.bodyLines,
    required this.note,
    required this.colorValue,
    this.lastItem = false,
  });

  final String title, amount, subtitle, note;
  final int bodyLines;
  final bool lastItem;
  final String colorValue;

  @override
  Widget build(BuildContext context) {
    final color = colorValue == 'green' ? KCColors.green : null;
    return SizedBox(
      height: 20.49 + 4.95 + (bodyLines * 19.12) + (lastItem ? 0 : 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Column(
              children: [
                Container(
                  height: 11.34,
                  width: 11.34,
                  decoration: BoxDecoration(
                    color: color ?? KCColors.grey6,
                    borderRadius: BorderRadius.circular(30.2483),
                  ),
                ),
                if (!lastItem)
                  Expanded(
                    child: Container(
                      width: 1.5,
                      color: KCColors.grey1,
                    ),
                  )
              ],
            ),
          ),
          const XSpace(8.66),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20.49,
                            child: KCAutoSizedText(
                              title,
                              color: color ?? KCColors.primary,
                              fontWeight: FontWeight.w900,
                              height: 1.366,
                            ),
                          ),
                          const YSpace(4.95),
                          SizedBox(
                            height: bodyLines * 19.12,
                            child: KCAutoSizedText(
                              subtitle,
                              fontSize: 14,
                              color: KCColors.grey5,
                              height: 1.3657,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const XSpace(30),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 20.49,
                            child: KCAutoSizedText(
                              amount,
                              color: color ?? KCColors.primary,
                              fontWeight: FontWeight.w900,
                              height: 1.366,
                            ),
                          ),
                          const YSpace(4.95),
                          SizedBox(
                            height: bodyLines * 19.12,
                            child: KCAutoSizedText(
                              note,
                              fontSize: 14,
                              color: KCColors.grey5,
                              height: 1.3657,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                if (!lastItem) const YSpace(16),
              ],
            ),
          )
        ],
      ),
    );
  }
}
