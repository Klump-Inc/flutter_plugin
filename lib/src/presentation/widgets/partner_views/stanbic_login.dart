import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class StanbicLogin extends StatefulWidget {
  const StanbicLogin({super.key});

  @override
  State<StanbicLogin> createState() => _StanbicLoginState();
}

class _StanbicLoginState extends State<StanbicLogin> {
  late TextEditingController _accountNoCtrl;
  late TextEditingController _phoneNoCtrl;
  late TextEditingController _firstNameCtrl;

  late StreamController<String> accountNoStreamCtrl;
  late StreamController<String> phoneNoStreamCtrl;
  late StreamController<String> firstNameStreamCtrl;
  final ValueNotifier<bool> _enabled = ValueNotifier(false);

  void validateInputs() {
    final selectedBankFlow =
        Provider.of<KCChangeNotifier>(context, listen: false).selectedBankFlow!;
    final accountNoError = KCFormValidator.errorAccountNumber(
        _accountNoCtrl.text.trim(), 'Required');
    final phoneNoError =
        KCFormValidator.errorPhoneNumber(_phoneNoCtrl.text.trim(), 'Required');
    final firstNameError =
        KCFormValidator.errorGeneric(_firstNameCtrl.text.trim(), 'Required');
    if (accountNoError?.isEmpty == true &&
        phoneNoError?.isEmpty == true &&
        (firstNameError?.isEmpty == true ||
            selectedBankFlow.slug != 'polaris')) {
      _enabled.value = true;
    } else {
      _enabled.value = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _accountNoCtrl = TextEditingController();
    _phoneNoCtrl = TextEditingController();
    _firstNameCtrl = TextEditingController();
    accountNoStreamCtrl = StreamController<String>.broadcast();
    phoneNoStreamCtrl = StreamController<String>.broadcast();
    firstNameStreamCtrl = StreamController<String>.broadcast();
    _accountNoCtrl.addListener(() {
      accountNoStreamCtrl.sink.add(_accountNoCtrl.text.trim());
      validateInputs();
    });
    _phoneNoCtrl.addListener(() {
      phoneNoStreamCtrl.sink.add(_phoneNoCtrl.text.trim());
      validateInputs();
    });
    _firstNameCtrl.addListener(() {
      firstNameStreamCtrl.sink.add(_firstNameCtrl.text.trim());
      validateInputs();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _accountNoCtrl.dispose();
    _phoneNoCtrl.dispose();
    _firstNameCtrl.dispose();
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
                    Image.network(
                      checkoutNotfier.selectedBankFlow?.logo ?? '',
                      height: 55,
                      width: 47,
                    ),
                    const YSpace(22),
                    if (checkoutNotfier.selectedBankFlow?.slug == 'stanbic')
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: KCHeadline3('Setup your account'),
                      ),
                    KCHeadline5(
                        'Login to your ${checkoutNotfier.selectedBankFlow?.name} account.'),
                    const YSpace(24),
                    StreamBuilder<String>(
                      stream: accountNoStreamCtrl.stream,
                      builder: (context, snapshot) {
                        return KCInputField(
                          controller: _accountNoCtrl,
                          hint: 'Account Number',
                          textInputType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
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
                      stream: phoneNoStreamCtrl.stream,
                      builder: (context, snapshot) {
                        return KCInputField(
                          controller: _phoneNoCtrl,
                          hint: 'Phone Number',
                          textInputType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
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
                    if (checkoutNotfier.selectedBankFlow?.slug == 'polaris')
                      StreamBuilder<String>(
                        stream: firstNameStreamCtrl.stream,
                        builder: (context, snapshot) {
                          return KCInputField(
                            controller: _firstNameCtrl,
                            hint: 'First Name',
                            textInputType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            validationMessage: KCFormValidator.errorGeneric(
                              snapshot.data,
                              'First Name is required',
                            ),
                          );
                        },
                      ),
                    const YSpace(16),
                    GestureDetector(
                      onTap: () async {
                        if (!await launchUrl(
                          Uri.parse(checkoutNotfier.selectedBankFlow?.slug ==
                                  'standbic'
                              ? "https://ienroll.stanbicibtc.com:8444/OnlineAccountOnboarding"
                              : "https://www.polarisbanklimited.com/open-an-account/"),
                          mode: LaunchMode.externalApplication,
                        )) {
                          // ignore: avoid_print
                          print('Could not open link');
                        }
                      },
                      child: KCBodyText1(
                        'Don’t have a ${(checkoutNotfier.selectedBankFlow?.slug ?? checkoutNotfier.selectedBankFlow?.name)?.capitalize()} account? Create one',
                        fontSize: 16,
                        color: KCColors.lightBlue,
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                        ),
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
                              .validateAccount(
                            _accountNoCtrl.text.trim(),
                            _phoneNoCtrl.text.trim(),
                            firstName: _firstNameCtrl.text.trim(),
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
