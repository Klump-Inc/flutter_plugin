import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PartnerLogin extends StatefulWidget {
  const PartnerLogin({super.key});

  @override
  State<PartnerLogin> createState() => _PartnerLoginState();
}

class _PartnerLoginState extends State<PartnerLogin> {
  late TextEditingController _accountNoCtrl;
  late TextEditingController _phoneNoCtrl;
  late TextEditingController _firstNameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _passwordCtrl;

  late StreamController<String> accountNoStreamCtrl;
  late StreamController<String> phoneNoStreamCtrl;
  late StreamController<String> firstNameStreamCtrl;
  late StreamController<String> emailStreamCtrl;
  late StreamController<String> passwordStreamCtrl;

  final ValueNotifier<bool> _enabled = ValueNotifier(false);

  void validateInputs() {
    final checkoutNotfier = context.read<KCChangeNotifier>();
    final formFields = (checkoutNotfier.nextStepData?.nextStep ??
            checkoutNotfier.selectedBankFlow?.nextStep)
        ?.formFields
        ?.map((e) => e.name)
        .toList();
    final accountNoError = KCFormValidator.errorAccountNumber(
        _accountNoCtrl.text.trim(), 'Required');
    final phoneNoError =
        KCFormValidator.errorPhoneNumber(_phoneNoCtrl.text.trim(), 'Required');
    final firstNameError =
        KCFormValidator.errorGeneric(_firstNameCtrl.text.trim(), 'Required');
    final emailError =
        KCFormValidator.errorEmail(_emailCtrl.text.trim(), 'Required');
    final passwordError =
        KCFormValidator.errorPassword(_passwordCtrl.text.trim(), 'Required');
    print(passwordError);
    if ((accountNoError?.isEmpty == true ||
            formFields?.contains('accountNumber') != true) &&
        (phoneNoError?.isEmpty == true ||
            formFields?.contains('phoneNumber') != true) &&
        (firstNameError?.isEmpty == true ||
            formFields?.contains('firstName') != true) &&
        (emailError?.isEmpty == true ||
            formFields?.contains('email') != true) &&
        (passwordError?.isEmpty == true ||
            formFields?.contains('password') != true)) {
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
    _emailCtrl = TextEditingController();
    _passwordCtrl = TextEditingController();
    final checkoutNotfier = context.read<KCChangeNotifier>();
    _emailCtrl.text = checkoutNotfier.email ?? '';
    _phoneNoCtrl.text = checkoutNotfier.phoneNumber ?? '';
    validateInputs();
    accountNoStreamCtrl = StreamController<String>.broadcast();
    phoneNoStreamCtrl = StreamController<String>.broadcast();
    firstNameStreamCtrl = StreamController<String>.broadcast();
    emailStreamCtrl = StreamController<String>.broadcast();
    passwordStreamCtrl = StreamController<String>.broadcast();
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
    _accountNoCtrl.dispose();
    _phoneNoCtrl.dispose();
    _firstNameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final checkoutNotfier = Provider.of<KCChangeNotifier>(context);
    final stepData = checkoutNotfier.nextStepData?.nextStep ??
        checkoutNotfier.selectedBankFlow?.nextStep;
    final formFields = stepData?.formFields?.map((e) => e.name).toList();
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
                    KCHeadline3(
                      stepData?.displayData?.title ??
                          'Login to your ${checkoutNotfier.selectedBankFlow?.name} account.',
                      fontSize: 24,
                    ),
                    if (stepData?.displayData?.subTitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child:
                            KCHeadline5(stepData?.displayData?.subTitle ?? ''),
                      ),
                    const YSpace(24),
                    if (formFields?.contains('accountNumber') == true)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: StreamBuilder<String>(
                          stream: accountNoStreamCtrl.stream,
                          builder: (context, snapshot) {
                            return KCInputField(
                              controller: _accountNoCtrl,
                              hint: 'Account Number',
                              textInputType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                                LengthLimitingTextInputFormatter(10),
                              ],
                              validationMessage:
                                  KCFormValidator.errorAccountNumber(
                                snapshot.data,
                                'Accouunt number is required',
                              ),
                            );
                          },
                        ),
                      ),
                    if (formFields?.contains('phoneNumber') == true)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: StreamBuilder<String>(
                          stream: phoneNoStreamCtrl.stream,
                          builder: (context, snapshot) {
                            return KCInputField(
                              controller: _phoneNoCtrl,
                              hint: 'Phone Number',
                              textInputType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                                LengthLimitingTextInputFormatter(11),
                              ],
                              textInputAction: TextInputAction.next,
                              validationMessage:
                                  KCFormValidator.errorPhoneNumber(
                                snapshot.data,
                                'Phone Number is required',
                              ),
                            );
                          },
                        ),
                      ),
                    if (formFields?.contains('email') == true)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: StreamBuilder<String>(
                          stream: emailStreamCtrl.stream,
                          builder: (context, snapshot) {
                            return KCInputField(
                              controller: _emailCtrl,
                              hint: 'Email',
                              textInputType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validationMessage: KCFormValidator.errorEmail(
                                snapshot.data,
                                'Email is required',
                              ),
                            );
                          },
                        ),
                      ),
                    if (formFields?.contains('firstName') == true)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: StreamBuilder<String>(
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
                      ),
                    if (formFields?.contains('password') == true)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: StreamBuilder<String>(
                          stream: passwordStreamCtrl.stream,
                          builder: (context, snapshot) {
                            return KCInputField(
                              controller: _passwordCtrl,
                              hint: 'Password',
                              textInputType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              validationMessage: KCFormValidator.errorPassword(
                                snapshot.data,
                                'Password is required',
                              ),
                            );
                          },
                        ),
                      ),
                    if (stepData?.displayData?.createPartnerAccountText !=
                            null &&
                        stepData?.displayData?.createPartnerAccountUrl != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: GestureDetector(
                          onTap: () async {
                            if (!await launchUrl(
                              Uri.parse(stepData!
                                  .displayData!.createPartnerAccountUrl!),
                              mode: LaunchMode.externalApplication,
                            )) {
                              showToast('Could not open link');
                            }
                          },
                          child: KCBodyText1(
                            '${stepData?.displayData?.createPartnerAccountText ?? stepData?.displayData!.createPartnerAccountText}',
                            fontSize: 16,
                            color: KCColors.lightBlue,
                            style: const TextStyle(
                              decoration: TextDecoration.underline,
                            ),
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
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            Provider.of<KCChangeNotifier>(context,
                                    listen: false)
                                .validateAccount(
                              accountNumber: _accountNoCtrl.text.trim(),
                              phoneNumber: _phoneNoCtrl.text.trim(),
                              firstName: _firstNameCtrl.text.trim(),
                              email: _emailCtrl.text.trim(),
                              password: _passwordCtrl.text.trim(),
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
