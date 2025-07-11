import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klump_checkout/src/core/core.dart';
import 'package:klump_checkout/src/presentation/presentation.dart';
import 'package:provider/provider.dart';

class PartnerVerifyBVN extends StatefulWidget {
  const PartnerVerifyBVN({super.key});

  @override
  State<PartnerVerifyBVN> createState() => _PartnerVerifyBVNState();
}

class _PartnerVerifyBVNState extends State<PartnerVerifyBVN> {
  late TextEditingController _otpCtrl;

  late StreamController<String> otpStreamCtrl;
  final ValueNotifier<bool> _enabled = ValueNotifier(false);

  void validateInputs() {
    final checkoutNotifier = context.read<KCChangeNotifier>();
    final formFields = checkoutNotifier.verifyBVNStepData?.nextStep.formFields
        ?.map((e) => e.name)
        .toList();
    final otpError = KCFormValidator.errorOTP(_otpCtrl.text.trim(), 'Required');

    if ((otpError?.isEmpty == true ||
        formFields?.contains('bvn_otp') != true)) {
      _enabled.value = true;
    } else {
      _enabled.value = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _otpCtrl = TextEditingController();
    otpStreamCtrl = StreamController<String>.broadcast();
    _otpCtrl.addListener(() {
      otpStreamCtrl.sink.add(_otpCtrl.text.trim());
      validateInputs();
    });

    final changeNotifier =
        Provider.of<KCChangeNotifier>(context, listen: false);
    MixPanelService.logEvent(
      '10 - VERIFY_BVN_MODAL',
      properties: {
        'environment': changeNotifier.initiateResponse?.isLive == true
            ? 'production'
            : 'staging',
        'partner': changeNotifier.selectedBankFlow?.slug,
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _otpCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final checkoutNotifier = Provider.of<KCChangeNotifier>(context);
    final stepData = checkoutNotifier.verifyBVNStepData?.nextStep;
    final formMap = stepData?.formFields;
    final formFields = formMap?.map((e) => e.name).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: LayoutBuilder(
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
                      if (stepData?.displayData?.title != null)
                        KCHeadline3(
                          stepData?.displayData?.title ?? '',
                        ),
                      if (stepData?.displayData?.subTitle != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: KCHeadline5(
                              stepData?.displayData?.subTitle ?? ''),
                        ),
                      const YSpace(24),
                      if (formFields?.contains('bvn_otp') == true)
                        Builder(
                          builder: (context) {
                            final form = formMap!
                                .where((e) => e.name == 'bvn_otp')
                                .toList()
                                .first;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: StreamBuilder<String>(
                                stream: otpStreamCtrl.stream,
                                builder: (context, snapshot) {
                                  return KCInputField(
                                    controller: _otpCtrl,
                                    hint: form.placeholder ??
                                        'Enter the 6-digit code here',
                                    textInputType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]')),
                                      LengthLimitingTextInputFormatter(6),
                                    ],
                                    textInputAction: TextInputAction.done,
                                    validationMessage: KCFormValidator.errorOTP(
                                      snapshot.data,
                                      'OTP is required',
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      const YSpace(25),
                      const Spacer(),
                      ValueListenableBuilder<bool>(
                        valueListenable: _enabled,
                        builder: (_, enabled, __) {
                          return KCPrimaryButton(
                            title: 'Continue',
                            disabled: !enabled || checkoutNotifier.isBusy,
                            loading: checkoutNotifier.isBusy,
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              checkoutNotifier.verifyBVN(
                                otp: _otpCtrl.text.trim(),
                              );
                            },
                          );
                        },
                      ),
                      const YSpace(59)
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
