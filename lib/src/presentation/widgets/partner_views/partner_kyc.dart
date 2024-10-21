import 'dart:async';
import 'dart:io';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:klump_checkout/src/core/core.dart';
import 'package:klump_checkout/src/presentation/presentation.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class PartnerKYC extends StatefulWidget {
  const PartnerKYC({super.key});

  @override
  State<PartnerKYC> createState() => _PartnerKYCState();
}

class _PartnerKYCState extends State<PartnerKYC> {
  late TextEditingController _ninCtrl;
  late TextEditingController _addressCtrl;
  late TextEditingController _landmarkCtrl;
  late TextEditingController _cityCtrl;
  late TextEditingController _stateCtrl;
  late TextEditingController _companyCtrl;
  late TextEditingController _companyIndustryCtrl;
  late TextEditingController _companyAddressCtrl;
  late TextEditingController _dateMovedInCtrl;
  late TextEditingController _companyStartDateCtrl;
  late TextEditingController _monthlyIncomeCtrl;
  late TextEditingController _nextOfkinNameCtrl;
  late TextEditingController _nextOfkinPhoneCtrl;

  String? _maritalStatus;
  String? _residentialStatus;
  DateTime? _dateMovedIn;
  String? _employmentStatus;
  DateTime? _companyStartDate;
  String? _educationStatus;
  String? _nextOfkinRelationship;

  bool _validateDateMovedIn = false;
  bool _validateCompanyStartdate = false;

  late StreamController<String> ninStreamCtrl;
  late StreamController<String> addressStreamCtrl;
  late StreamController<String> landmarkStreamCtrl;
  late StreamController<String> cityStreamCtrl;
  late StreamController<String> stateStreamCtrl;
  late StreamController<String> companyStreamCtrl;
  late StreamController<String> companyIndustryStreamCtrl;
  late StreamController<String> companyAddressStreamCtrl;
  late StreamController<String> dateMovedInStreamCtrl;
  late StreamController<String> companyStartDateStreamCtrl;
  late StreamController<String> monthlyIncomeStreamCtrl;
  late StreamController<String> nextOfkinNameStreamCtrl;
  late StreamController<String> nextOfkinPhoneStreamCtrl;

  final ValueNotifier<bool> _enabled = ValueNotifier(false);

  void validateInputs() {
    final checkoutNotfier = context.read<KCChangeNotifier>();
    final formFields = (checkoutNotfier.nextStepData?.nextStep ??
            checkoutNotfier.selectedBankFlow?.nextStep)
        ?.formFields
        ?.map((e) => e.name)
        .toList();
    final ninError = KCFormValidator.errorNIN(_ninCtrl.text.trim(), 'Required');
    final addressError =
        KCFormValidator.errorGeneric(_addressCtrl.text.trim(), 'Required');
    final landmarkError =
        KCFormValidator.errorGeneric(_landmarkCtrl.text.trim(), 'Required');
    final cityError =
        KCFormValidator.errorGeneric(_cityCtrl.text.trim(), 'Required');
    final stateError =
        KCFormValidator.errorGeneric(_stateCtrl.text.trim(), 'Required');
    final dateMovedInError =
        KCFormValidator.errorDate(_dateMovedIn, 'Required', true);
    final companyNameError =
        KCFormValidator.errorGeneric(_companyCtrl.text.trim(), 'Required');
    final companyIndustryError = KCFormValidator.errorGeneric(
        _companyIndustryCtrl.text.trim(), 'Required');
    final companyAddressError = KCFormValidator.errorGeneric(
        _companyAddressCtrl.text.trim(), 'Required');
    final companyStartDateError =
        KCFormValidator.errorDate(_companyStartDate, 'Required', true);
    final monthlyIncomeError =
        KCFormValidator.errorAmount(_monthlyIncomeCtrl.text.trim(), 'Required');
    final nextOfKinNameError = KCFormValidator.errorGeneric(
        _nextOfkinNameCtrl.text.trim(), 'Required');
    final nextOfKinPhoneError = KCFormValidator.errorPhoneNumber(
        _nextOfkinPhoneCtrl.text.trim(), 'Required');
    if ((ninError?.isEmpty == true || formFields?.contains('nin') != true) &&
        (_maritalStatus != null ||
            formFields?.contains('marital_status') != true) &&
        (_residentialStatus != null ||
            formFields?.contains('residential_status') != true) &&
        (addressError?.isEmpty == true ||
            formFields?.contains('address') != true) &&
        (landmarkError?.isEmpty == true ||
            formFields?.contains('landmark') != true) &&
        (cityError?.isEmpty == true || formFields?.contains('city') != true) &&
        (stateError?.isEmpty == true ||
            formFields?.contains('state') != true) &&
        (dateMovedInError?.isEmpty == true ||
            formFields?.contains('date_moved_in') != true) &&
        (_employmentStatus != null ||
            formFields?.contains('employment_status') != true) &&
        (companyNameError?.isEmpty == true ||
            formFields?.contains('company_name') != true) &&
        (companyIndustryError?.isEmpty == true ||
            formFields?.contains('company_industry') != true) &&
        (companyAddressError?.isEmpty == true ||
            formFields?.contains('company_address') != true) &&
        (companyStartDateError?.isEmpty == true ||
            formFields?.contains('company_start_date') != true) &&
        (monthlyIncomeError?.isEmpty == true ||
            formFields?.contains('monthly_income') != true) &&
        (_educationStatus != null ||
            formFields?.contains('education') != true) &&
        (nextOfKinNameError?.isEmpty == true ||
            formFields?.contains('next_of_kin_name') != true) &&
        (_nextOfkinRelationship != null ||
            formFields?.contains('next_of_kin_relationship') != true) &&
        (nextOfKinPhoneError?.isEmpty == true ||
            formFields?.contains('next_of_kin_phone') != true)) {
      _enabled.value = true;
    } else {
      _enabled.value = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _ninCtrl = TextEditingController();
    _addressCtrl = TextEditingController();
    _landmarkCtrl = TextEditingController();
    _cityCtrl = TextEditingController();
    _stateCtrl = TextEditingController();
    _companyCtrl = TextEditingController();
    _companyIndustryCtrl = TextEditingController();
    _companyAddressCtrl = TextEditingController();
    _dateMovedInCtrl = TextEditingController();
    _companyStartDateCtrl = TextEditingController();
    _monthlyIncomeCtrl = TextEditingController();
    _nextOfkinNameCtrl = TextEditingController();
    _nextOfkinPhoneCtrl = TextEditingController();

    validateInputs();
    ninStreamCtrl = StreamController<String>.broadcast();
    addressStreamCtrl = StreamController<String>.broadcast();
    landmarkStreamCtrl = StreamController<String>.broadcast();
    cityStreamCtrl = StreamController<String>.broadcast();
    stateStreamCtrl = StreamController<String>.broadcast();
    companyStreamCtrl = StreamController<String>.broadcast();
    companyIndustryStreamCtrl = StreamController<String>.broadcast();
    companyAddressStreamCtrl = StreamController<String>.broadcast();
    dateMovedInStreamCtrl = StreamController<String>.broadcast();
    companyStartDateStreamCtrl = StreamController<String>.broadcast();
    monthlyIncomeStreamCtrl = StreamController<String>.broadcast();
    nextOfkinNameStreamCtrl = StreamController<String>.broadcast();
    nextOfkinPhoneStreamCtrl = StreamController<String>.broadcast();

    _ninCtrl.addListener(() {
      ninStreamCtrl.sink.add(_ninCtrl.text.trim());
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
    _landmarkCtrl.addListener(() {
      landmarkStreamCtrl.sink.add(_landmarkCtrl.text.trim());
      validateInputs();
    });
    _stateCtrl.addListener(() {
      stateStreamCtrl.sink.add(_stateCtrl.text.trim());
      validateInputs();
    });
    _companyCtrl.addListener(() {
      companyStreamCtrl.sink.add(_companyCtrl.text.trim());
      validateInputs();
    });
    _companyIndustryCtrl.addListener(() {
      companyIndustryStreamCtrl.sink.add(_companyIndustryCtrl.text.trim());
      validateInputs();
    });
    _companyAddressCtrl.addListener(() {
      companyAddressStreamCtrl.sink.add(_companyAddressCtrl.text.trim());
      validateInputs();
    });
    _dateMovedInCtrl.addListener(() {
      dateMovedInStreamCtrl.sink.add(_dateMovedInCtrl.text.trim());
      validateInputs();
    });
    _companyStartDateCtrl.addListener(() {
      companyStartDateStreamCtrl.sink.add(_companyStartDateCtrl.text.trim());
      validateInputs();
    });
    _monthlyIncomeCtrl.addListener(() {
      monthlyIncomeStreamCtrl.sink.add(_monthlyIncomeCtrl.text.trim());
      validateInputs();
    });
    _nextOfkinNameCtrl.addListener(() {
      nextOfkinNameStreamCtrl.sink.add(_nextOfkinNameCtrl.text.trim());
      validateInputs();
    });
    _nextOfkinPhoneCtrl.addListener(() {
      nextOfkinPhoneStreamCtrl.sink.add(_nextOfkinPhoneCtrl.text.trim());
      validateInputs();
    });
    final changeNotifier =
        Provider.of<KCChangeNotifier>(context, listen: false);
    MixPanelService.logEvent(
      '10 - KYC MODAL',
      properties: {
        'environment': changeNotifier.isLive ? 'production' : 'staging',
        'partner': changeNotifier.selectedBankFlow?.slug,
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _ninCtrl.dispose();
    _addressCtrl.dispose();
    _landmarkCtrl.dispose();
    _cityCtrl.dispose();

    _stateCtrl.dispose();
    _companyCtrl.dispose();
    _companyIndustryCtrl.dispose();
    _companyAddressCtrl.dispose();
    _dateMovedInCtrl.dispose();
    _companyStartDateCtrl.dispose();
    _monthlyIncomeCtrl.dispose();
    _nextOfkinNameCtrl.dispose();
    _nextOfkinPhoneCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final checkoutNotfier = Provider.of<KCChangeNotifier>(context);
    final stepData = checkoutNotfier.nextStepData?.nextStep ??
        checkoutNotfier.selectedBankFlow?.nextStep;
    final formFields = stepData?.formFields?.map((e) => e.name).toList();
    final formMap = stepData?.formFields;
    Logger().d(formMap);
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
                    if (formFields?.contains('nin') == true)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: StreamBuilder<String>(
                          stream: ninStreamCtrl.stream,
                          builder: (context, snapshot) {
                            return KCInputField(
                              controller: _ninCtrl,
                              hint: 'National Identification Number',
                              textInputType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                                LengthLimitingTextInputFormatter(11),
                              ],
                              validationMessage: KCFormValidator.errorNIN(
                                snapshot.data,
                                'National Identification Number is required',
                              ),
                            );
                          },
                        ),
                      ),
                    if (formFields?.contains('marital_status') == true)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Builder(
                          builder: (context) {
                            final inputData = formMap!
                                .where((e) => e.name == 'marital_status')
                                .first;
                            return KCDropdownInput(
                              label: inputData.label ?? "Please select",
                              items: inputData.options!
                                  .map((e) => e['value'].toString())
                                  .toList(),
                              value: _maritalStatus,
                              onSelected: (value) {
                                setState(() {
                                  _maritalStatus = value;
                                });
                                validateInputs();
                              },
                              minWidth: constraints.maxWidth - 52,
                            );
                          },
                        ),
                      ),
                    if (formFields?.contains('residential_status') == true)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Builder(
                          builder: (context) {
                            final inputData = formMap!
                                .where((e) => e.name == 'residential_status')
                                .first;
                            return KCDropdownInput(
                              label: inputData.label ?? "Please select",
                              items: inputData.options!
                                  .map((e) => e['value'].toString())
                                  .toList(),
                              value: _residentialStatus,
                              onSelected: (value) {
                                setState(() {
                                  _residentialStatus = value;
                                });
                                validateInputs();
                              },
                              minWidth: constraints.maxWidth - 52,
                            );
                          },
                        ),
                      ),
                    if (formFields?.contains('address') == true)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: StreamBuilder<String>(
                          stream: addressStreamCtrl.stream,
                          builder: (context, snapshot) {
                            return KCInputField(
                              controller: _addressCtrl,
                              hint: 'Address',
                              textInputType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              validationMessage: KCFormValidator.errorGeneric(
                                snapshot.data,
                                'Address is required',
                              ),
                            );
                          },
                        ),
                      ),
                    if (formFields?.contains('landmark') == true)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: StreamBuilder<String>(
                          stream: landmarkStreamCtrl.stream,
                          builder: (context, snapshot) {
                            return KCInputField(
                              controller: _landmarkCtrl,
                              hint: 'Landmark',
                              textInputType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              validationMessage: KCFormValidator.errorGeneric(
                                snapshot.data,
                                'Landmark is required',
                              ),
                            );
                          },
                        ),
                      ),
                    if (formFields?.contains('city') == true)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: StreamBuilder<String>(
                          stream: cityStreamCtrl.stream,
                          builder: (context, snapshot) {
                            return KCInputField(
                              controller: _cityCtrl,
                              hint: 'Local Government Area',
                              textInputType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              validationMessage: KCFormValidator.errorGeneric(
                                snapshot.data,
                                'Local Government Area is required',
                              ),
                            );
                          },
                        ),
                      ),
                    if (formFields?.contains('state') == true)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: StreamBuilder<String>(
                          stream: stateStreamCtrl.stream,
                          builder: (context, snapshot) {
                            return KCInputField(
                              controller: _stateCtrl,
                              hint: 'State',
                              textInputType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              validationMessage: KCFormValidator.errorGeneric(
                                snapshot.data,
                                'State is required',
                              ),
                            );
                          },
                        ),
                      ),
                    if (formFields?.contains('date_moved_in') == true)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            KCInputField(
                              controller: _dateMovedInCtrl,
                              hint: 'Date move in?',
                              textInputType: TextInputType.text,
                              validationMessage: KCFormValidator.errorDate(
                                _dateMovedIn,
                                'DOB move in?',
                                _validateDateMovedIn,
                              ),
                              onTap: () {
                                setState(() {
                                  _validateDateMovedIn = true;
                                });
                                if (Platform.isIOS) {
                                  showCupertinoModalPopup<void>(
                                    barrierDismissible: false,
                                    context: context,
                                    barrierColor:
                                        const Color.fromRGBO(0, 0, 0, 0.4),
                                    builder: (BuildContext context) {
                                      return KCIOSDatePickerContainer(
                                        initialDate: _dateMovedIn,
                                        onDateSelected: (value) {
                                          _dateMovedInCtrl.text =
                                              KCStringUtil.formatDate(value!);
                                          setState(() {
                                            _dateMovedIn = value;
                                          });
                                          validateInputs();
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
                                        initialDate: _dateMovedIn,
                                        onDateSelected: (value) {
                                          _dateMovedInCtrl.text =
                                              KCStringUtil.formatDate(value!);
                                          setState(() {
                                            _dateMovedIn = value;
                                          });
                                          validateInputs();
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
                          ],
                        ),
                      ),
                    if (formFields?.contains('employment_status') == true)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Builder(
                          builder: (context) {
                            final inputData = formMap!
                                .where((e) => e.name == 'employment_status')
                                .first;
                            return KCDropdownInput(
                              label: inputData.label ?? "Please select",
                              items: inputData.options!
                                  .map((e) => e['value'].toString())
                                  .toList(),
                              value: _employmentStatus,
                              onSelected: (value) {
                                setState(() {
                                  _employmentStatus = value;
                                });
                              },
                              minWidth: constraints.maxWidth - 52,
                            );
                          },
                        ),
                      ),
                    if (formFields?.contains('company_name') == true)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: StreamBuilder<String>(
                          stream: companyStreamCtrl.stream,
                          builder: (context, snapshot) {
                            return KCInputField(
                              controller: _companyCtrl,
                              hint: _employmentStatus == 'employed'
                                  ? 'What is the name of the company you work for?'
                                  : 'What is the name of your company?',
                              textInputType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              validationMessage: KCFormValidator.errorGeneric(
                                snapshot.data,
                                'Company is required',
                              ),
                            );
                          },
                        ),
                      ),
                    if (formFields?.contains('company_industry') == true)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: StreamBuilder<String>(
                          stream: companyIndustryStreamCtrl.stream,
                          builder: (context, snapshot) {
                            return KCInputField(
                              controller: _companyIndustryCtrl,
                              hint: "What industry is the company in?",
                              textInputType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              validationMessage: KCFormValidator.errorGeneric(
                                snapshot.data,
                                'Company industry is required',
                              ),
                            );
                          },
                        ),
                      ),
                    if (formFields?.contains('company_address') == true)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: StreamBuilder<String>(
                          stream: companyAddressStreamCtrl.stream,
                          builder: (context, snapshot) {
                            return KCInputField(
                              controller: _companyAddressCtrl,
                              hint: "What's your office address?",
                              textInputType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              validationMessage: KCFormValidator.errorGeneric(
                                snapshot.data,
                                'Office address is required',
                              ),
                            );
                          },
                        ),
                      ),
                    if (formFields?.contains('company_start_date') == true)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            KCInputField(
                              controller: _companyStartDateCtrl,
                              hint: 'Start working here?',
                              textInputType: TextInputType.text,
                              validationMessage: KCFormValidator.errorDate(
                                _companyStartDate,
                                'DOB move in?',
                                _validateCompanyStartdate,
                              ),
                              onTap: () {
                                setState(() {
                                  _validateCompanyStartdate = true;
                                });
                                if (Platform.isIOS) {
                                  showCupertinoModalPopup<void>(
                                    barrierDismissible: false,
                                    context: context,
                                    barrierColor:
                                        const Color.fromRGBO(0, 0, 0, 0.4),
                                    builder: (BuildContext context) {
                                      return KCIOSDatePickerContainer(
                                        initialDate: _companyStartDate,
                                        onDateSelected: (value) {
                                          _companyStartDateCtrl.text =
                                              KCStringUtil.formatDate(value!);
                                          setState(() {
                                            _companyStartDate = value;
                                          });
                                          validateInputs();
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
                                        initialDate: _companyStartDate,
                                        onDateSelected: (value) {
                                          _companyStartDateCtrl.text =
                                              KCStringUtil.formatDate(value!);
                                          setState(() {
                                            _companyStartDate = value;
                                          });
                                          validateInputs();
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
                          ],
                        ),
                      ),
                    if (formFields?.contains('monthly_income') == true)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: StreamBuilder<String>(
                          stream: monthlyIncomeStreamCtrl.stream,
                          builder: (context, snapshot) {
                            return KCInputField(
                              controller: _monthlyIncomeCtrl,
                              hint: "What's your monthly income? (Naira)",
                              textInputType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                                CurrencyTextInputFormatter.currency(
                                  locale: 'en_NG',
                                  decimalDigits: 2,
                                  symbol: '₦',
                                ),
                              ],
                              validationMessage: KCFormValidator.errorAmount(
                                snapshot.data,
                                'Income is required',
                              ),
                            );
                          },
                        ),
                      ),
                    if (formFields?.contains('education') == true)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Builder(
                          builder: (context) {
                            final inputData = formMap!
                                .where((e) => e.name == 'education')
                                .first;
                            return KCDropdownInput(
                              label: inputData.label ?? "Please select",
                              items: inputData.options!
                                  .map((e) => e['value'].toString())
                                  .toList(),
                              value: _educationStatus,
                              onSelected: (value) {
                                setState(() {
                                  _educationStatus = value;
                                });
                                validateInputs();
                              },
                              minWidth: constraints.maxWidth - 52,
                            );
                          },
                        ),
                      ),
                    if (formFields?.contains('next_of_kin_name') == true)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: StreamBuilder<String>(
                          stream: nextOfkinNameStreamCtrl.stream,
                          builder: (context, snapshot) {
                            return KCInputField(
                              controller: _nextOfkinNameCtrl,
                              hint: "Name of Next of Kin",
                              textInputType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              validationMessage: KCFormValidator.errorGeneric(
                                snapshot.data,
                                'Name of Next of Kin is required',
                              ),
                            );
                          },
                        ),
                      ),
                    if (formFields?.contains('next_of_kin_relationship') ==
                        true)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Builder(
                          builder: (context) {
                            final inputData = formMap!
                                .where(
                                    (e) => e.name == 'next_of_kin_relationship')
                                .first;
                            return KCDropdownInput(
                              label: inputData.label ?? "Please select",
                              items: inputData.options!
                                  .map((e) => e['value'].toString())
                                  .toList(),
                              value: _nextOfkinRelationship,
                              onSelected: (value) {
                                setState(() {
                                  _nextOfkinRelationship = value;
                                });
                                validateInputs();
                              },
                              minWidth: constraints.maxWidth - 52,
                            );
                          },
                        ),
                      ),
                    if (formFields?.contains('next_of_kin_phone') == true)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: StreamBuilder<String>(
                          stream: nextOfkinPhoneStreamCtrl.stream,
                          builder: (context, snapshot) {
                            return KCInputField(
                              controller: _nextOfkinPhoneCtrl,
                              hint: "Phone Number of Next of Kin",
                              textInputType: TextInputType.phone,
                              textInputAction: TextInputAction.done,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                              validationMessage:
                                  KCFormValidator.errorPhoneNumber(
                                snapshot.data,
                                'Phone Number of Next of Kin is required',
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
                            checkoutNotfier.partnerKYC(
                              nin: _ninCtrl.text.trim(),
                              maritalStatus: _maritalStatus,
                              residentialStatus: _residentialStatus,
                              address: _addressCtrl.text.trim(),
                              landmark: _landmarkCtrl.text.trim(),
                              city: _cityCtrl.text.trim(),
                              state: _stateCtrl.text.trim(),
                              dateMovedIn: _dateMovedIn,
                              employmentStatus: _employmentStatus,
                              companyName: _companyCtrl.text.trim(),
                              companyIndustry: _companyIndustryCtrl.text.trim(),
                              companyAddress: _companyAddressCtrl.text.trim(),
                              companyStartDate: _companyStartDate,
                              monthlyIncome: _monthlyIncomeCtrl.text.trim(),
                              education: _educationStatus,
                              nextOfKinName: _nextOfkinNameCtrl.text.trim(),
                              nextOfKinRetionship: _nextOfkinRelationship,
                              nextOfKinPhone: _nextOfkinPhoneCtrl.text.trim(),
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
