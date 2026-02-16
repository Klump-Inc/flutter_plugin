import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class PartnerLoginOTP extends StatefulWidget {
  const PartnerLoginOTP({super.key});

  @override
  State<PartnerLoginOTP> createState() => _PartnerLoginOTPState();
}

class _PartnerLoginOTPState extends State<PartnerLoginOTP> {
  late TextEditingController _otpCtrl;
  late TextEditingController _passwordCtrl;
  late StreamController<String> otpStreamCtrl;
  late StreamController<String> passwordStreamCtrl;
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
    final formFields = checkoutNotifier.verifyOTPStepData!.nextStep.formFields!
        .map((e) => e.name);

    final otpForms = checkoutNotifier.verifyOTPStepData!.nextStep.formFields!
        .where((e) => e.name == 'otp')
        .toList();
    final otpLength = otpForms.isNotEmpty
        ? (int.tryParse(otpForms.first.length.toString()) ?? 5)
        : 5;
    final passwordError =
        KCFormValidator.errorPassword2(_passwordCtrl.text.trim(), 'Required');
    final otpError =
        KCFormValidator.errorOTP(_otpCtrl.text.trim(), 'Required', otpLength);
    if ((otpError?.isEmpty != true && formFields.contains('otp')) ||
        (passwordError?.isEmpty != true && formFields.contains('password'))) {
      _enabled.value = false;
    } else {
      _enabled.value = true;
    }
  }

  @override
  void initState() {
    super.initState();
    _otpCtrl = TextEditingController();
    _passwordCtrl = TextEditingController();
    otpStreamCtrl = StreamController<String>.broadcast();
    passwordStreamCtrl = StreamController<String>.broadcast();
    validateInputs();
    _otpCtrl.addListener(() {
      otpStreamCtrl.sink.add(_otpCtrl.text.trim());
      validateInputs();
    });
    _passwordCtrl.addListener(() {
      passwordStreamCtrl.sink.add(_passwordCtrl.text.trim());
      validateInputs();
    });
    _startCounter();
    final changeNotifier =
        Provider.of<KCChangeNotifier>(context, listen: false);
    MixPanelService.logEvent(
      '7 - VERIFY OTP MODAL',
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
    _passwordCtrl.dispose();
    _timer?.cancel();
    otpStreamCtrl.close();
    passwordStreamCtrl.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final checkoutNotfier = Provider.of<KCChangeNotifier>(context);
    final stepData = checkoutNotfier.verifyOTPStepData?.nextStep ??
        checkoutNotfier.selectedBankFlow?.nextStep;
    final formFields = stepData?.formFields?.map((e) => e.name).toList();
    final checkBoxFields =
        stepData?.formFields?.where((e) => e.type == 'checkbox').toList();
    final formMap = stepData?.formFields;
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
                      logo: KCNetworkImage(
                        url: checkoutNotfier.selectedBankFlow?.logo,
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
                    if (stepData?.name?.toUpperCase() == 'CONNECT_MONO' &&
                        checkBoxFields?.isEmpty == true)
                      Align(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30, bottom: 10),
                          child: Image.asset(
                            KCAssets.safe,
                            height: 109,
                            width: 106,
                            package: KC_PACKAGE_NAME,
                          ),
                        ),
                      ),
                    const YSpace(22),
                    Align(
                      alignment:
                          stepData?.name?.toUpperCase() == 'CONNECT_MONO' &&
                                  checkBoxFields?.isEmpty == true
                              ? Alignment.center
                              : Alignment.centerLeft,
                      child: KCHeadline3(stepData?.displayData?.title ??
                          (formFields?.contains('otp') == true
                              ? 'Enter the code'
                              : 'Enter password')),
                    ),
                    const YSpace(8),
                    Align(
                      alignment:
                          stepData?.name?.toUpperCase() == 'CONNECT_MONO' &&
                                  checkBoxFields?.isEmpty == true
                              ? Alignment.center
                              : Alignment.centerLeft,
                      child: KCHeadline5(stepData?.displayData?.subTitle ??
                          (formFields?.contains('otp') == true
                              ? 'A code has been sent to your email address and ${checkoutNotfier.phoneNumber}'
                              : checkoutNotfier.verifyOTPStepData?.data
                                      .toString() ??
                                  '')),
                    ),
                    const YSpace(28),
                    if (formFields?.contains('otp') == true)
                      Builder(builder: (context) {
                        final form = formMap!
                            .where((e) => e.name == 'otp')
                            .toList()
                            .first;
                        final otpLength = form.length != null
                            ? (int.tryParse(form.length.toString()) ?? 5)
                            : 5;
                        Logger().d(form);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: StreamBuilder<String>(
                            stream: otpStreamCtrl.stream,
                            builder: (context, snapshot) {
                              return KCInputField(
                                controller: _otpCtrl,
                                hint: form.placeholder ?? 'Enter the code here',
                                validationMessage: KCFormValidator.errorOTP(
                                    snapshot.data,
                                    'OTP is required',
                                    otpLength),
                                textInputType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                  LengthLimitingTextInputFormatter(otpLength),
                                ],
                                textInputAction: TextInputAction.done,
                              );
                            },
                          ),
                        );
                      }),
                    if (formFields?.contains('password') == true)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: StreamBuilder<String>(
                          stream: passwordStreamCtrl.stream,
                          builder: (context, snapshot) {
                            return KCInputField(
                              controller: _passwordCtrl,
                              hint: 'Password',
                              password: true,
                              textInputType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              validationMessage: KCFormValidator.errorPassword2(
                                snapshot.data,
                                'Password is required',
                              ),
                            );
                          },
                        ),
                      ),
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
                                            .resendAccountOTP()
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
                                if (stepData?.name?.toUpperCase() ==
                                        'CONNECT_MONO' &&
                                    accepted) {
                                  final authCodeList = formMap!
                                      .where((e) => e.name == 'mono_auth_code');
                                  final tokenList =
                                      formMap.where((e) => e.name == 'token');
                                  checkoutNotfier.linkExistingMono(
                                    context,
                                    monoAuthCode: authCodeList.isNotEmpty
                                        ? authCodeList.first.value.toString()
                                        : null,
                                    token: tokenList.isNotEmpty
                                        ? tokenList.first.value.toString()
                                        : null,
                                  );
                                } else if (stepData?.name?.toUpperCase() ==
                                    'CONNECT_MONO') {
                                  checkoutNotfier.linkWithMono(context);
                                } else {
                                  checkoutNotfier.verifyOTP(
                                    _otpCtrl.text.trim(),
                                    _passwordCtrl.text.trim(),
                                  );
                                }
                              },
                            );
                          },
                        );
                      },
                    ),
                    if (stepData?.name?.toUpperCase() == 'CONNECT_MONO' &&
                        checkBoxFields?.isNotEmpty == true)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: KCSecondaryButton(
                          title: 'No, I want to select a new bank',
                          onTap: () => checkoutNotfier.linkWithMono(context),
                        ),
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
