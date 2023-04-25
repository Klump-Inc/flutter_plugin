import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:provider/provider.dart';

class StanbicLogin extends StatefulWidget {
  const StanbicLogin({super.key});

  @override
  State<StanbicLogin> createState() => _StanbicLoginState();
}

class _StanbicLoginState extends State<StanbicLogin> {
  late TextEditingController _emailCtrl;
  late TextEditingController _passwordCtrl;

  late StreamController<String> emailStreamCtrl;
  late StreamController<String> passwordStreamCtrl;
  final ValueNotifier<bool> _enabled = ValueNotifier(false);

  void validateInputs() {
    final emailError =
        KCFormValidator.errorAccountNumber(_emailCtrl.text.trim(), 'Required');
    final passwordError =
        KCFormValidator.errorPhoneNumber(_passwordCtrl.text.trim(), 'Required');
    if (emailError?.isEmpty == true && passwordError?.isEmpty == true) {
      _enabled.value = true;
    } else {
      _enabled.value = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _emailCtrl = TextEditingController();
    _passwordCtrl = TextEditingController();
    emailStreamCtrl = StreamController<String>.broadcast();
    passwordStreamCtrl = StreamController<String>.broadcast();
    _emailCtrl.addListener(() {
      emailStreamCtrl.sink.add(_emailCtrl.text.trim());
      validateInputs();
    });
    _passwordCtrl.addListener(() {
      passwordStreamCtrl.sink.add(_passwordCtrl.text.trim());
      validateInputs();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
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
                      height: 55,
                      width: 47,
                      package: KC_PACKAGE_NAME,
                    ),
                    const YSpace(22),
                    KCHeadline3('Setup your account'),
                    const YSpace(8),
                    KCHeadline5('Login to your Stanbic IBTC account.'),
                    const YSpace(24),
                    StreamBuilder<String>(
                      stream: emailStreamCtrl.stream,
                      builder: (context, snapshot) {
                        return KCInputField(
                          controller: _emailCtrl,
                          hint: 'Account Number',
                          textInputType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            // ignore: unnecessary_raw_strings
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            LengthLimitingTextInputFormatter(10),
                          ],
                          validationMessage: KCFormValidator.errorAccountNumber(
                            snapshot.data,
                            'Accouunt number is required',
                          ),
                        );
                      },
                    ),
                    const YSpace(16),
                    StreamBuilder<String>(
                      stream: passwordStreamCtrl.stream,
                      builder: (context, snapshot) {
                        return KCInputField(
                          controller: _passwordCtrl,
                          hint: 'Phone Number',
                          textInputType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            // ignore: unnecessary_raw_strings
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            LengthLimitingTextInputFormatter(11),
                          ],
                          textInputAction: TextInputAction.done,
                          validationMessage: KCFormValidator.errorPhoneNumber(
                            snapshot.data,
                            'Phone Number is required',
                          ),
                        );
                      },
                    ),
                    const YSpace(16),
                    KCBodyText1(
                      'Don’t have a Stanbic account? Create one',
                      fontSize: 16,
                      color: KCColors.lightBlue,
                      style: const TextStyle(
                        decoration: TextDecoration.underline,
                      ),
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
                              .validateAccount(_emailCtrl.text.trim(),
                                  _passwordCtrl.text.trim()),
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
