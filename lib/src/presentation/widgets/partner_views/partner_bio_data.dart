import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
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
  late TextEditingController _apartmentCtrl;
  late TextEditingController _addressCtrl;
  late TextEditingController _cityCtrl;
  late TextEditingController _stateCtrl;

  DateTime? _dob;
  bool _validateDate = false;

  late StreamController<String> lastNameStreamCtrl;
  late StreamController<String> phoneNoStreamCtrl;
  late StreamController<String> firstNameStreamCtrl;
  late StreamController<String> emailStreamCtrl;
  late StreamController<String> passwordStreamCtrl;
  late StreamController<String> apartmentStreamCtrl;
  late StreamController<String> addressStreamCtrl;
  late StreamController<String> cityStreamCtrl;
  late StreamController<String> stateStreamCtrl;

  final ValueNotifier<bool> _enabled = ValueNotifier(false);

  void validateInputs() {
    final checkoutNotifier = context.read<KCChangeNotifier>();
    final formFields = checkoutNotifier.bioDataStepData?.nextStep.formFields
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
    final dobError = KCFormValidator.errorDate(_dob, 'Required', true);
    final addressError =
        KCFormValidator.errorGeneric(_addressCtrl.text.trim(), 'Required');
    final cityError =
        KCFormValidator.errorGeneric(_cityCtrl.text.trim(), 'Required');
    final stateError =
        KCFormValidator.errorGeneric(_stateCtrl.text.trim(), 'Required');
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
            formFields?.contains('date_of_birth') != true) &&
        (addressError?.isEmpty == true ||
            formFields?.contains('address') != true) &&
        (cityError?.isEmpty == true || formFields?.contains('city') != true) &&
        (stateError?.isEmpty == true ||
            formFields?.contains('state') != true)) {
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
    _apartmentCtrl = TextEditingController();
    _addressCtrl = TextEditingController();
    _cityCtrl = TextEditingController();
    _stateCtrl = TextEditingController();

    lastNameStreamCtrl = StreamController<String>.broadcast();
    phoneNoStreamCtrl = StreamController<String>.broadcast();
    firstNameStreamCtrl = StreamController<String>.broadcast();
    emailStreamCtrl = StreamController<String>.broadcast();
    passwordStreamCtrl = StreamController<String>.broadcast();
    apartmentStreamCtrl = StreamController<String>.broadcast();
    addressStreamCtrl = StreamController<String>.broadcast();
    cityStreamCtrl = StreamController<String>.broadcast();
    stateStreamCtrl = StreamController<String>.broadcast();

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
    _apartmentCtrl.addListener(() {
      apartmentStreamCtrl.sink.add(_apartmentCtrl.text.trim());
      validateInputs();
    });
    _addressCtrl.addListener(() {
      addressStreamCtrl.sink.add(_addressCtrl.text.trim());
      validateInputs();
    });
    _cityCtrl.addListener(() {
      cityStreamCtrl.sink.add(_cityCtrl.text.trim());
      validateInputs();
    });
    _stateCtrl.addListener(() {
      stateStreamCtrl.sink.add(_stateCtrl.text.trim());
      validateInputs();
    });

    final changeNotifier =
        Provider.of<KCChangeNotifier>(context, listen: false);
    MixPanelService.logEvent(
      '10 - BIO DATA MODAL',
      properties: {
        'environment': changeNotifier.initiateResponse?.isLive == true
            ? 'production'
            : 'staging',
        'partner': changeNotifier.selectedBankFlow?.slug,
      },
    );
    Future.delayed(Duration.zero, () {
      final klumpUser = changeNotifier.klumpUser;
      if (changeNotifier.email != null) {
        _emailCtrl.text = changeNotifier.email!;
      }
      if (klumpUser?.firstname != null) {
        _firstNameCtrl.text = klumpUser!.firstname!;
      }
      if (klumpUser?.lastname != null) {
        _lastNameCtrl.text = klumpUser!.lastname!;
      }
      if (klumpUser?.dob != null) {
        setState(() {
          _dob = DateTime.tryParse(klumpUser?.dob);
        });
        if (_dob != null) {
          _dobCtrl.text = KCStringUtil.formatDate(_dob!);
        }
      }
      _emailCtrl.text = changeNotifier.email ?? '';
      _phoneNoCtrl.text = changeNotifier.phoneNumber ?? '';
      final formMap = changeNotifier.bioDataStepData?.nextStep.formFields;
      final formFields = formMap?.map((e) => e.name).toList();
      if (formFields?.contains('phoneNumber') == true) {
        final phoneValue =
            formMap!.where((e) => e.name == 'phoneNumber').toList().first.value;
        if (phoneValue != null) {
          _phoneNoCtrl.text = phoneValue.toString();
        }
      }
      if (formFields?.contains('firstname') == true) {
        final value =
            formMap!.where((e) => e.name == 'firstname').toList().first.value;
        if (value != null) {
          _firstNameCtrl.text = value.toString();
        }
      }
      if (formFields?.contains('lastname') == true) {
        final value =
            formMap!.where((e) => e.name == 'lastname').toList().first.value;
        if (value != null) {
          _lastNameCtrl.text = value.toString();
        }
      }
      if (formFields?.contains('password') == true) {
        final value =
            formMap!.where((e) => e.name == 'password').toList().first.value;
        if (value != null) {
          _passwordCtrl.text = value.toString();
        }
      }
      if (formFields?.contains('date_of_birth') == true) {
        final value = formMap!
            .where((e) => e.name == 'date_of_birth')
            .toList()
            .first
            .value;

        if (value != null) {
          setState(() {
            _dob = DateTime.tryParse(value);
          });
          _dobCtrl.text = KCStringUtil.formatDate(_dob!);
        }
      }
      if (formFields?.contains('apartment') == true) {
        final value =
            formMap!.where((e) => e.name == 'apartment').toList().first.value;
        if (value != null) {
          _apartmentCtrl.text = value.toString();
        }
      }
      if (formFields?.contains('address') == true) {
        final value =
            formMap!.where((e) => e.name == 'address').toList().first.value;
        if (value != null) {
          _addressCtrl.text = value.toString();
        }
      }
      if (formFields?.contains('city') == true) {
        final value =
            formMap!.where((e) => e.name == 'city').toList().first.value;
        if (value != null) {
          _cityCtrl.text = value.toString();
        }
      }
      if (formFields?.contains('state') == true) {
        final value =
            formMap!.where((e) => e.name == 'state').toList().first.value;
        if (value != null) {
          _stateCtrl.text = value.toString();
        }
      }

      validateInputs();
    });
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
    _apartmentCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final checkoutNotifier = Provider.of<KCChangeNotifier>(context);
    final stepData = checkoutNotifier.bioDataStepData?.nextStep;
    final formMap = stepData?.formFields;
    final formFields = formMap?.map((e) => e.name).toList();
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
                      onTap: checkoutNotifier.prevPage,
                      logo: KcNetworkImage(
                        url: checkoutNotifier.selectedBankFlow!.logo,
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
                        child:
                            KCHeadline5(stepData?.displayData?.subTitle ?? ''),
                      ),
                    const YSpace(24),
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
                              validationMessage: KCFormValidator.errorDate(
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
                                  selectDateAndroid(
                                    context,
                                    initialDate: _dob,
                                    onDateSelected: (value) {
                                      _dobCtrl.text =
                                          KCStringUtil.formatDate(value!);
                                      setState(() {
                                        _dob = value;
                                      });
                                    },
                                  );
                                }
                              },
                              readOnly: true,
                            ),
                            if (_validateDate &&
                                KCFormValidator.errorDate(_dob,
                                            'DOB is required', _validateDate)
                                        ?.isNotEmpty ==
                                    true)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: KCBodyText1(
                                  KCFormValidator.errorDate(
                                      _dob, 'DOB is required', _validateDate)!,
                                  fontSize: 12,
                                  color: Colors.red,
                                ),
                              ),
                          ],
                        ),
                      ),
                    if (formFields?.contains('password') == true)
                      Builder(
                        builder: (context) {
                          final form = formMap!
                              .where((e) => e.name == 'password')
                              .toList()
                              .first;
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: StreamBuilder<String>(
                                  stream: passwordStreamCtrl.stream,
                                  builder: (context, snapshot) {
                                    return KCInputField(
                                      controller: _passwordCtrl,
                                      hint: 'Password',
                                      password: true,
                                      textInputType: TextInputType.text,
                                      textInputAction: TextInputAction.done,
                                      validationMessage:
                                          KCFormValidator.errorPassword(
                                        snapshot.data,
                                        'Password is required',
                                      ),
                                    );
                                  },
                                ),
                              ),
                              if (form.smalltext != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 0),
                                  child: Html(
                                    data: form.smalltext,
                                    style: {
                                      "*": Style(
                                        fontSize:
                                            FontSize(12), // Global font size
                                      ),
                                    },
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    if (formFields?.contains('apartment') == true)
                      Builder(
                        builder: (context) {
                          final form = formMap!
                              .where((e) => e.name == 'apartment')
                              .toList()
                              .first;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: StreamBuilder<String>(
                              stream: apartmentStreamCtrl.stream,
                              builder: (context, snapshot) {
                                return KCInputField(
                                  controller: _apartmentCtrl,
                                  hint: form.placeholder ?? form.label ?? '',
                                  textInputType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    if (formFields?.contains('address') == true)
                      Builder(
                        builder: (context) {
                          final form = formMap!
                              .where((e) => e.name == 'address')
                              .toList()
                              .first;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: StreamBuilder<String>(
                              stream: addressStreamCtrl.stream,
                              builder: (context, snapshot) {
                                return KCInputField(
                                  controller: _addressCtrl,
                                  hint: form.placeholder ?? form.label ?? '',
                                  textInputType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  validationMessage:
                                      KCFormValidator.errorGeneric(
                                    snapshot.data,
                                    'Address is required',
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    if (formFields?.contains('city') == true)
                      Builder(
                        builder: (context) {
                          final form = formMap!
                              .where((e) => e.name == 'city')
                              .toList()
                              .first;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: StreamBuilder<String>(
                              stream: cityStreamCtrl.stream,
                              builder: (context, snapshot) {
                                return KCInputField(
                                  controller: _cityCtrl,
                                  hint: form.placeholder ?? form.label ?? '',
                                  textInputType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  validationMessage:
                                      KCFormValidator.errorGeneric(
                                    snapshot.data,
                                    'City is required',
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    if (formFields?.contains('state') == true)
                      Builder(
                        builder: (context) {
                          final form = formMap!
                              .where((e) => e.name == 'state')
                              .toList()
                              .first;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: StreamBuilder<String>(
                              stream: stateStreamCtrl.stream,
                              builder: (context, snapshot) {
                                return KCInputField(
                                  controller: _stateCtrl,
                                  hint: form.placeholder ?? form.label ?? '',
                                  textInputType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  validationMessage:
                                      KCFormValidator.errorGeneric(
                                    snapshot.data,
                                    'State is required',
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
                            checkoutNotifier.bioData(
                              email: formFields?.contains('email') == true
                                  ? _emailCtrl.text.trim()
                                  : null,
                              firstname:
                                  formFields?.contains('firstname') == true
                                      ? _firstNameCtrl.text.trim()
                                      : null,
                              lastname: formFields?.contains('lastname') == true
                                  ? _lastNameCtrl.text.trim()
                                  : null,
                              dob: formFields?.contains('date_of_birth') == true
                                  ? _dob
                                  : null,
                              password: formFields?.contains('password') == true
                                  ? _passwordCtrl.text.trim()
                                  : null,
                              amount: formFields?.contains('amount') == true
                                  ? checkoutNotifier.totalAmount
                                  : null,
                              apartment:
                                  formFields?.contains('apartment') == true
                                      ? _apartmentCtrl.text.trim()
                                      : null,
                              address: formFields?.contains('address') == true
                                  ? _addressCtrl.text.trim()
                                  : null,
                              city: formFields?.contains('city') == true
                                  ? _cityCtrl.text.trim()
                                  : null,
                              state: formFields?.contains('state') == true
                                  ? _stateCtrl.text.trim()
                                  : null,
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
