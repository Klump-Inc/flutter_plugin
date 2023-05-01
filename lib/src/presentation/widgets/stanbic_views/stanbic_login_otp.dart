import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:provider/provider.dart';

class StanbicLoginOTP extends StatefulWidget {
  const StanbicLoginOTP({super.key});

  @override
  State<StanbicLoginOTP> createState() => _StanbicLoginOTPState();
}

class _StanbicLoginOTPState extends State<StanbicLoginOTP> {
  late TextEditingController _otpCtrl;
  late StreamController<String> otpStreamCtrl;
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
    final otpError = KCFormValidator.errorOTP(_otpCtrl.text.trim(), 'Required');

    if (otpError?.isEmpty == true) {
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
    _startCounter();
  }

  @override
  void dispose() {
    _otpCtrl.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final checkoutNotfier = Provider.of<KCChangeNotifier>(context);
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
                    Image.asset(
                      KCAssets.stanbicLogo,
                      package: KC_PACKAGE_NAME,
                      height: 55,
                      width: 47,
                    ),
                    const YSpace(22),
                    KCHeadline3('Enter the code'),
                    const YSpace(8),
                    KCHeadline5(
                        'A code has been sent to your otp address and ${checkoutNotfier.phoneNumber}'),
                    const YSpace(28),
                    StreamBuilder<String>(
                      stream: otpStreamCtrl.stream,
                      builder: (context, snapshot) {
                        return KCInputField(
                          controller: _otpCtrl,
                          hint: 'Enter the 6-digit code here',
                          validationMessage: KCFormValidator.errorOTP(
                            snapshot.data,
                            'OTP is required',
                          ),
                          textInputType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            // ignore: unnecessary_raw_strings
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            LengthLimitingTextInputFormatter(6),
                          ],
                          textInputAction: TextInputAction.done,
                        );
                      },
                    ),
                    const YSpace(16),
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
                          onTap: () => Provider.of<KCChangeNotifier>(context,
                                  listen: false)
                              .verifyOTP(_otpCtrl.text.trim()),
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
