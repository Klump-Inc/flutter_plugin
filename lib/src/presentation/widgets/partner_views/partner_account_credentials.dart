import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:provider/provider.dart';

class PartnerAccountCredentials extends StatefulWidget {
  const PartnerAccountCredentials({super.key});

  @override
  State<PartnerAccountCredentials> createState() =>
      _PartnerAccountCredentialsState();
}

class _PartnerAccountCredentialsState extends State<PartnerAccountCredentials> {
  late TextEditingController _emailCtrl;
  late TextEditingController _passwordCtrl;
  late TextEditingController _dobCtrl;

  late StreamController<String> emailStreamCtrl;
  late StreamController<String> passwordStreamCtrl;

  final ValueNotifier<bool> _enabled = ValueNotifier(false);
  DateTime? _dob;
  bool _validateDate = false;

  void validateInputs() {
    final checkoutNotfier =
        Provider.of<KCChangeNotifier>(context, listen: false);

    final emailError =
        KCFormValidator.errorEmail(_emailCtrl.text.trim(), 'Required');
    final passwordError =
        KCFormValidator.errorPassword(_passwordCtrl.text.trim(), 'Required');
    final dobError = KCFormValidator.errorDOB(_dob, 'Required', _validateDate);
    if (emailError?.isEmpty == true &&
        passwordError?.isEmpty == true &&
        (checkoutNotfier.selectedBankFlow?.slug != 'polaris' ||
            dobError?.isEmpty == true)) {
      _enabled.value = true;
    } else {
      _enabled.value = false;
    }
  }

  @override
  void initState() {
    _emailCtrl = TextEditingController();
    _passwordCtrl = TextEditingController();
    _dobCtrl = TextEditingController();
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
    final changeNotifier =
        Provider.of<KCChangeNotifier>(context, listen: false);
    MixPanelService.logEvent(
      'BIO DATA MODAL',
      properties: {
        'environment': changeNotifier.isLive ? 'production' : 'staging',
        'partner': changeNotifier.selectedBankFlow?.slug,
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _dobCtrl.dispose();
    emailStreamCtrl.close();
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
                    const YSpace(14),
                    KCHeadline3('Complete your account'),
                    const YSpace(8),
                    KCHeadline5(
                        'We’ll only ask you for this information once and you can choose to easily update it in the Klump app later.'),
                    const YSpace(18),
                    // KCInputField(
                    //   controller: TextEditingController(
                    //       text: checkoutNotfier.stanbicUser?.firstname),
                    //   hint: 'First Name',
                    //   textInputType: TextInputType.text,
                    //   readOnly: true,
                    // ),
                    // const YSpace(16),
                    // KCInputField(
                    //   controller: TextEditingController(
                    //       text: checkoutNotfier.stanbicUser?.lastname),
                    //   hint: 'Last Name',
                    //   textInputType: TextInputType.text,
                    //   readOnly: true,
                    // ),
                    // const YSpace(16),
                    StreamBuilder<String>(
                      stream: emailStreamCtrl.stream,
                      builder: (context, snapshot) {
                        return KCInputField(
                          controller: _emailCtrl,
                          hint: 'Email Address',
                          textInputType: TextInputType.emailAddress,
                          validationMessage: KCFormValidator.errorEmail(
                            snapshot.data,
                            'Email Address is required',
                          ),
                        );
                      },
                    ),
                    if (checkoutNotfier.selectedBankFlow?.slug == 'polaris')
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            KCInputField(
                              controller: _dobCtrl,
                              hint: 'Date of Birth',
                              textInputType: TextInputType.text,
                              validationMessage: KCFormValidator.errorDOB(
                                _dob,
                                'DOB is required',
                                _validateDate,
                              ),
                              onTap: () {
                                setState(() {
                                  _validateDate = true;
                                });
                                if (Platform.isIOS) {
                                  showCupertinoModalPopup<void>(
                                    barrierDismissible: false,
                                    context: context,
                                    barrierColor:
                                        const Color.fromRGBO(0, 0, 0, 0.4),
                                    builder: (BuildContext context) {
                                      return KCIOSDatePickerContainer(
                                        initialDate: _dob,
                                        onDateSelected: (value) {
                                          _dobCtrl.text =
                                              KCStringUtil.formatDate(value!);
                                          setState(() {
                                            _dob = value;
                                          });
                                          Navigator.pop(context);
                                        },
                                        onCancel: () {
                                          setState(() {});
                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                  );
                                } else {
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      return KCAndroidDatePickerContainer(
                                        initialDate: _dob,
                                        onDateSelected: (value) {
                                          _dobCtrl.text =
                                              KCStringUtil.formatDate(value!);
                                          setState(() {
                                            _dob = value;
                                          });
                                          Navigator.pop(context);
                                        },
                                        onCancel: () {
                                          setState(() {});
                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                  );
                                }
                              },
                              readOnly: true,
                            ),
                            if (_validateDate &&
                                KCFormValidator.errorDOB(_dob,
                                            'DOB is required', _validateDate)
                                        ?.isNotEmpty ==
                                    true)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: KCBodyText1(
                                  KCFormValidator.errorDOB(
                                      _dob, 'DOB is required', _validateDate)!,
                                  fontSize: 12,
                                  color: Colors.red,
                                ),
                              ),
                          ],
                        ),
                      ),
                    const YSpace(16),
                    StreamBuilder<String>(
                      stream: passwordStreamCtrl.stream,
                      builder: (context, snapshot) {
                        return KCInputField(
                          controller: _passwordCtrl,
                          hint: 'Password',
                          password: true,
                          textInputType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          validationMessage: KCFormValidator.errorPassword(
                            snapshot.data,
                            'Password is required',
                          ),
                        );
                      },
                    ),
                    const YSpace(4),
                    KCBodyText1(
                      'Your password should contain a number, a special character (.!@#%^&), an uppercase and lowercase and must be at least 7 characters long.',
                      fontSize: 12,
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
                                .addAccountCredentials(
                              _emailCtrl.text.trim(),
                              _passwordCtrl.text.trim(),
                              _dob,
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
