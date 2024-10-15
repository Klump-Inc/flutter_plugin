import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:klump_checkout/src/core/core.dart';
import 'package:klump_checkout/src/presentation/presentation.dart';
import 'package:provider/provider.dart';

class PartnerBioData extends StatefulWidget {
  const PartnerBioData({super.key});

  @override
  State<PartnerBioData> createState() => _PartnerBioDataState();
}

class _PartnerBioDataState extends State<PartnerBioData> {
  late TextEditingController _lastNameCtrl;
  late TextEditingController _phoneNoCtrl;
  late TextEditingController _firstNameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _passwordCtrl;
  late TextEditingController _dobCtrl;
  DateTime? _dob;
  bool _validateDate = false;

  late StreamController<String> lastNameStreamCtrl;
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
    final lastNameError =
        KCFormValidator.errorGeneric(_lastNameCtrl.text.trim(), 'Required');
    final phoneNoError =
        KCFormValidator.errorPhoneNumber(_phoneNoCtrl.text.trim(), 'Required');
    final firstNameError =
        KCFormValidator.errorGeneric(_firstNameCtrl.text.trim(), 'Required');
    final emailError =
        KCFormValidator.errorEmail(_emailCtrl.text.trim(), 'Required');
    final passwordError =
        KCFormValidator.errorPassword(_passwordCtrl.text.trim(), 'Required');
    final dobError = KCFormValidator.errorDOB(_dob, 'Required', _validateDate);
    if ((lastNameError?.isEmpty == true ||
            formFields?.contains('lastname') != true) &&
        (phoneNoError?.isEmpty == true ||
            formFields?.contains('phoneNumber') != true) &&
        (firstNameError?.isEmpty == true ||
            formFields?.contains('firstName') != true) &&
        (emailError?.isEmpty == true ||
            formFields?.contains('email') != true) &&
        (passwordError?.isEmpty == true ||
            formFields?.contains('password') != true) &&
        (dobError?.isEmpty == true ||
            formFields?.contains('date_of_birth') != true)) {
      _enabled.value = true;
    } else {
      _enabled.value = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _lastNameCtrl = TextEditingController();
    _phoneNoCtrl = TextEditingController();
    _firstNameCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _passwordCtrl = TextEditingController();
    _dobCtrl = TextEditingController();
    final checkoutNotfier = context.read<KCChangeNotifier>();
    _emailCtrl.text = checkoutNotfier.email ?? '';
    _phoneNoCtrl.text = checkoutNotfier.phoneNumber ?? '';
    validateInputs();
    lastNameStreamCtrl = StreamController<String>.broadcast();
    phoneNoStreamCtrl = StreamController<String>.broadcast();
    firstNameStreamCtrl = StreamController<String>.broadcast();
    emailStreamCtrl = StreamController<String>.broadcast();
    passwordStreamCtrl = StreamController<String>.broadcast();
    _lastNameCtrl.addListener(() {
      lastNameStreamCtrl.sink.add(_lastNameCtrl.text.trim());
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
    _dobCtrl.addListener(() {
      validateInputs();
    });
    final changeNotifier =
        Provider.of<KCChangeNotifier>(context, listen: false);
    MixPanelService.logEvent(
      '10 - BIO DATA MODAL',
      properties: {
        'environment': changeNotifier.isLive ? 'production' : 'staging',
        'partner': changeNotifier.selectedBankFlow?.slug,
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _lastNameCtrl.dispose();
    _phoneNoCtrl.dispose();
    _firstNameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _dobCtrl.dispose();
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
                    Align(
                      child: Image.network(
                        checkoutNotfier.selectedBankFlow?.logo ?? '',
                        height: 55,
                        width: 120,
                      ),
                    ),
                    if (checkoutNotfier.initiateResponse?.merchant != null)
                      Align(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: KCHeadline4(
                            checkoutNotfier.initiateResponse!.merchant
                                .toString(),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    const YSpace(16),
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
                    if (formFields?.contains('accountNumber') == true)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: StreamBuilder<String>(
                          stream: lastNameStreamCtrl.stream,
                          builder: (context, snapshot) {
                            return KCInputField(
                              controller: _lastNameCtrl,
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
                    if (formFields?.contains('firstname') == true)
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
                    if (formFields?.contains('lastname') == true)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: StreamBuilder<String>(
                          stream: lastNameStreamCtrl.stream,
                          builder: (context, snapshot) {
                            return KCInputField(
                              controller: _lastNameCtrl,
                              hint: 'Last Name',
                              textInputType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              validationMessage: KCFormValidator.errorGeneric(
                                snapshot.data,
                                'Last Name is required',
                              ),
                            );
                          },
                        ),
                      ),
                    if (formFields?.contains('date_of_birth') == true)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
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
                    if (stepData?.displayData?.smallText != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: KCBodyText1(
                          (stepData?.displayData?.smallText ?? '')
                              .replaceAll('<strong>', '')
                              .replaceAll('</strong>', ''),
                          fontSize: 12,
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
                            checkoutNotfier.bioData(
                              email: _emailCtrl.text.trim(),
                              firstname: _firstNameCtrl.text.trim(),
                              lastname: _lastNameCtrl.text.trim(),
                              dob: _dob,
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
