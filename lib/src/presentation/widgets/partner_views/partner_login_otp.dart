import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klump_checkout/src/src.dart';

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
        .verifyOTPNextStepData!.nextStep.formFields!
        .map((e) => e.name);
    final otpLength = checkoutNotifier.selectedBankFlow?.slug == 'stanbic'
        ? 6
        : checkoutNotifier.selectedBankFlow?.slug == 'polaris'
            ? 4
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
        'environment': changeNotifier.isLive ? 'production' : 'staging',
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
    final formFields = checkoutNotfier
        .verifyOTPNextStepData!.nextStep.formFields!
        .map((e) => e.name);
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
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const YSpace(30.82),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: checkoutNotfier.prevPage,
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: SvgPicture.asset(
                            KCAssets.arrowBack,
                            package: KC_PACKAGE_NAME,
                          ),
                        ),
                      ),
                    ),
                    const YSpace(24.22),
                    Image.network(
                      checkoutNotfier.selectedBankFlow!.logo ?? '',
                      height: 55,
                      width: 47,
                    ),
                    const YSpace(22),
                    KCHeadline3(formFields.contains('otp')
                        ? 'Enter the code'
                        : 'Enter password'),
                    const YSpace(8),
                    KCHeadline5(formFields.contains('otp')
                        ? 'A code has been sent to your email address and ${checkoutNotfier.phoneNumber}'
                        : checkoutNotfier.verifyOTPNextStepData?.data
                                .toString() ??
                            ''),
                    const YSpace(28),
                    if (formFields.contains('otp'))
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: StreamBuilder<String>(
                          stream: otpStreamCtrl.stream,
                          builder: (context, snapshot) {
                            return KCInputField(
                              controller: _otpCtrl,
                              hint: checkoutNotfier.selectedBankFlow?.slug ==
                                      'stanbic'
                                  ? 'Enter the 6-digit code here'
                                  : checkoutNotfier.selectedBankFlow?.slug ==
                                          'polaris'
                                      ? 'Enter the 4-digit code here'
                                      : 'Enter the 5-digit code here',
                              validationMessage: KCFormValidator.errorOTP(
                                snapshot.data,
                                'OTP is required',
                                checkoutNotfier.selectedBankFlow?.slug ==
                                        'stanbic'
                                    ? 6
                                    : checkoutNotfier.selectedBankFlow?.slug ==
                                            'polaris'
                                        ? 4
                                        : 5,
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
                      ),
                    if (formFields.contains('password'))
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
                    if (formFields.contains('otp'))
                      ValueListenableBuilder<int>(
                        valueListenable: _timeLeft,
                        builder: (_, timeLeft, __) {
                          return InkWell(
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
                                  : '${timeLeft ~/ 60}:${timeLeft >= 60 ? '00' : timeLeft} remaining',
                              fontSize: 16,
                              color: KCColors.lightBlue,
                              style: const TextStyle(
                                decoration: TextDecoration.underline,
                              ),
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
                          disabled: !enabled || checkoutNotfier.isBusy,
                          loading: checkoutNotfier.isBusy,
                          onTap: () => checkoutNotfier.verifyOTP(
                            _otpCtrl.text.trim(),
                            _passwordCtrl.text.trim(),
                          ),
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
