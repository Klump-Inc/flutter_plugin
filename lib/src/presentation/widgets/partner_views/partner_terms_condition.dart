import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PartnerTermsCondition extends StatefulWidget {
  const PartnerTermsCondition({super.key});

  @override
  State<PartnerTermsCondition> createState() => _PartnerTermsConditionState();
}

class _PartnerTermsConditionState extends State<PartnerTermsCondition> {
  final ValueNotifier<bool> _accepted = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final checkoutNotifier = Provider.of<KCChangeNotifier>(context);
    final stepData = checkoutNotifier.acceptTermsStepData?.nextStep;
    final formFields = stepData?.formFields?.map((e) => e.name).toList();
    final checkBoxFields =
        stepData?.formFields?.where((e) => e.type == 'checkbox').toList();
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
                    fontSize: 16,
                  ),
                  if (stepData?.displayData?.subTitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: KCHeadline5(stepData?.displayData?.subTitle ?? ''),
                    ),
                  const YSpace(24),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Html(
                        data: stepData?.displayData?.text ?? '',
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
                        onTap: () {
                          final referenceForm = stepData?.formFields
                              ?.where((e) => e.name == 'reference')
                              .toList();

                          checkoutNotifier.acceptTermsAndCondition(
                              reference:
                                  formFields?.contains('reference') == true &&
                                          referenceForm?.isNotEmpty == true
                                      ? referenceForm!.first.value.toString()
                                      : null);
                        },
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
