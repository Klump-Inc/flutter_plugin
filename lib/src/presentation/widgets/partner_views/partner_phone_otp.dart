import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class PartnerPhoneOTP extends StatefulWidget {
  const PartnerPhoneOTP({super.key});

  @override
  State<PartnerPhoneOTP> createState() => _PartnerPhoneOTPState();
}

class _PartnerPhoneOTPState extends State<PartnerPhoneOTP> {
  late TextEditingController _otpCtrl;
  late StreamController<String> otpStreamCtrl;
  final ValueNotifier<bool> _enabled = ValueNotifier(false);

  final ValueNotifier<bool> _accepted = ValueNotifier(false);

  Timer? _timer;
  final ValueNotifier<int> _timeLeft =
      ValueNotifier(kC_OTP_RESEND_WAIT_TIME_IN_SECONDS);

  void _startCounter() {
    _timeLeft.value = kC_OTP_RESEND_WAIT_TIME_IN_SECONDS;
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer t) {
        _timeLeft.value--;
        if (_timeLeft.value == 0) {
          t.cancel();
        }
      },
    );
  }

  void validateInputs() {
    final checkoutNotifier =
        Provider.of<KCChangeNotifier>(context, listen: false);
    final formFields = checkoutNotifier
        .verifyPhoneOTPStepData!.nextStep.formFields!
        .map((e) => e.name);
    final otpLength = checkoutNotifier.selectedBankFlow?.slug == 'stanbic'
        ? 6
        : checkoutNotifier.selectedBankFlow?.slug == 'polaris'
            ? 4
            : 5;

    final otpError =
        KCFormValidator.errorOTP(_otpCtrl.text.trim(), 'Required', otpLength);
    if ((otpError?.isEmpty != true && formFields.contains('otp'))) {
      _enabled.value = false;
    } else {
      _enabled.value = true;
    }
  }

  @override
  void initState() {
    super.initState();
    _otpCtrl = TextEditingController();
    otpStreamCtrl = StreamController<String>.broadcast();
    validateInputs();
    _otpCtrl.addListener(() {
      otpStreamCtrl.sink.add(_otpCtrl.text.trim());
      validateInputs();
    });

    _startCounter();
    final changeNotifier =
        Provider.of<KCChangeNotifier>(context, listen: false);
    MixPanelService.logEvent(
      '7 - VERIFY PHONE NUMBER OTP MODAL',
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
    _otpCtrl.dispose();
    _timer?.cancel();
    otpStreamCtrl.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final checkoutNotfier = Provider.of<KCChangeNotifier>(context);
    final stepData = checkoutNotfier.verifyPhoneOTPStepData?.nextStep;
    final formMap = stepData?.formFields;
    final formFields = formMap?.map((e) => e.name).toList();
    final checkBoxFields =
        stepData?.formFields?.where((e) => e.type == 'checkbox').toList();
    Logger().d(formFields);
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
                    const YSpace(24),
                    LogoHeaderWidget(
                      onTap: checkoutNotfier.prevPage,
                      logo: Image.network(
                        checkoutNotfier.selectedBankFlow!.logo ?? '',
                        height: 55,
                        width: 120,
                      ),
                    ),
                    if (checkoutNotfier.initiateResponse?.merchant != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Align(
                          child: KCHeadline4(
                            checkoutNotfier.initiateResponse!.merchant
                                .toString(),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    const YSpace(22),
                    if (stepData?.displayData?.title != null)
                      KCHeadline3(
                        stepData?.displayData?.title ?? '',
                        fontSize: 20,
                      ),
                    if (stepData?.displayData?.subTitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child:
                            KCHeadline5(stepData?.displayData?.subTitle ?? ''),
                      ),
                    const YSpace(24),
                    if (formFields?.contains('otp') == true)
                      Builder(builder: (context) {
                        final form = formMap!
                            .where((e) => e.name == 'otp')
                            .toList()
                            .first;
                        Logger().d(form);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: StreamBuilder<String>(
                            stream: otpStreamCtrl.stream,
                            builder: (context, snapshot) {
                              return KCInputField(
                                controller: _otpCtrl,
                                hint: form.placeholder ??
                                    'Enter the 5-digit code here',
                                validationMessage: KCFormValidator.errorOTP(
                                  snapshot.data,
                                  '${form.name ?? 'OTP'}  is required',
                                  5,
                                ),
                                textInputType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                  LengthLimitingTextInputFormatter(6),
                                ],
                                textInputAction: TextInputAction.done,
                              );
                            },
                          ),
                        );
                      }),
                    if (formFields?.contains('otp') == true)
                      ValueListenableBuilder<int>(
                        valueListenable: _timeLeft,
                        builder: (_, timeLeft, __) {
                          return Row(
                            children: [
                              InkWell(
                                onTap: timeLeft != 0 || checkoutNotfier.isBusy
                                    ? null
                                    : () {
                                        checkoutNotfier
                                            .resendPhoneOTP()
                                            .then((value) {
                                          _startCounter();
                                        });
                                      },
                                child: KCBodyText1(
                                  timeLeft == 0
                                      ? 'Resend code'
                                      : 'Resend code in ${timeLeft ~/ 60}:${timeLeft >= 60 ? '00' : timeLeft}',
                                  fontSize: 14,
                                  color: KCColors.lightBlue,
                                  style: timeLeft == 0
                                      ? const TextStyle(
                                          decoration: TextDecoration.underline,
                                        )
                                      : null,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    if (checkBoxFields?.isNotEmpty == true)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
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
                              child: KCBodyText1(
                                  checkBoxFields?.first.label ?? ''),
                            ),
                          ],
                        ),
                      ),
                    const YSpace(25),
                    const Spacer(),
                    ValueListenableBuilder<bool>(
                      valueListenable: _enabled,
                      builder: (_, enabled, __) {
                        return ValueListenableBuilder<bool>(
                          valueListenable: _accepted,
                          builder: (_, accepted, __) {
                            return KCPrimaryButton(
                              title: 'Continue',
                              disabled: !enabled ||
                                  checkoutNotfier.isBusy ||
                                  (!accepted &&
                                      checkBoxFields?.isNotEmpty == true),
                              loading: checkoutNotfier.isBusy,
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                checkoutNotfier.verifyPhoneOTP(
                                  otp: _otpCtrl.text.trim(),
                                );
                              },
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
    );
  }
}
