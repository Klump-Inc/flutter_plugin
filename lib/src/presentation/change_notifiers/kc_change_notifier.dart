import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:klump_checkout/src/domain/usecases/account_credentials.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:logger/logger.dart';
import 'package:mono_flutter/mono_flutter.dart';
import 'package:oktoast/oktoast.dart';

class KCChangeNotifier extends ChangeNotifier {
  KCChangeNotifier() {
    initiateTransactionUsecase =
        InitiateTransactionUsecase(partnerRepository: PartnerRepository());
    accountValidationUsecase =
        AccountValidationUsecase(partnerRepository: PartnerRepository());
    verifyOTPUsecase = VerifyOTPUsecase(partnerRepository: PartnerRepository());
    getBankTCUsecase = GetBankTCUsecase(partnerRepository: PartnerRepository());
    getRepaymentDetailsUsecase =
        GetRepaymentDetailsUsecase(partnerRepository: PartnerRepository());
    getLoanStatusUsecase =
        GetLoanStatusUsecase(partnerRepository: PartnerRepository());
    getPartnerInsurersUsecase =
        GetPartnerInsurersUsecase(partnerRepository: PartnerRepository());
    accountCredentialsUsecase =
        AccountCredentialsUsecase(partnerRepository: PartnerRepository());
    getLoanPartnersUsecase =
        GetLoanPartnersUsecase(partnerRepository: PartnerRepository());
    partnersUsecase = PartnersUsecase(partnerRepository: PartnerRepository());
  }
  late InitiateTransactionUsecase initiateTransactionUsecase;
  late AccountValidationUsecase accountValidationUsecase;
  late VerifyOTPUsecase verifyOTPUsecase;
  late GetBankTCUsecase getBankTCUsecase;
  late GetRepaymentDetailsUsecase getRepaymentDetailsUsecase;
  late GetLoanStatusUsecase getLoanStatusUsecase;
  late GetPartnerInsurersUsecase getPartnerInsurersUsecase;
  late AccountCredentialsUsecase accountCredentialsUsecase;
  late GetLoanPartnersUsecase getLoanPartnersUsecase;
  late PartnersUsecase partnersUsecase;

  bool _isBusy = false;
  bool get isBusy => _isBusy;
  var _currentPage = 0;
  int get currentPage => _currentPage;

  InitiateResponseModel? _initiateResponse;
  InitiateResponseModel? get initiateResponse => _initiateResponse;

  KlumpCheckoutData? _checkoutData;
  KlumpCheckoutData? get checkoutData => _checkoutData;

  String? _email;
  String? _accountNumber;
  String? _phoneNumber;
  String? _firstName;
  String? _username;

  String? get email => _email;
  String? get accountNumber => _accountNumber;
  String? get phoneNumber => _phoneNumber;
  String? get firstName => _firstName;
  String? get username => _username;

  // TermsAndCondition? _termsCondition;
  // TermsAndCondition? get termsCondition => _termsCondition;
  KlumpUser? _klumpUser;
  KlumpUser? get klumpUser => _klumpUser;
  RepaymentDetails? _repaymentDetails;
  RepaymentDetails? get repaymentDetails => _repaymentDetails;

  DisbursementStatusResponse? _disbursementStatusResponse;
  DisbursementStatusResponse? get disbursementStatusResponse =>
      _disbursementStatusResponse;
  List<PartnerInsurer>? _partnerInsurers;
  List<PartnerInsurer>? get partnerInsurers => _partnerInsurers;
  List<Partner>? _loanPartners;
  List<Partner>? get loanPartners => _loanPartners;

  final PageController _pageController = PageController();
  PageController get pageController => _pageController;

  //Step data
  KCAPIResponse? _verificationStepData;
  KCAPIResponse? get verificationStepData => _verificationStepData;

  KCAPIResponse? _verifyOTPStepData;
  KCAPIResponse? get verifyOTPStepData => _verifyOTPStepData;

  KCAPIResponse? _createPhoneNumberStepData;
  KCAPIResponse? get createPhoneNumberStepData => _createPhoneNumberStepData;

  KCAPIResponse? _verifyPhoneOTPStepData;
  KCAPIResponse? get verifyPhoneOTPStepData => _verifyPhoneOTPStepData;

  KCAPIResponse? _accountNumberStepData;
  KCAPIResponse? get accountNumberStepData => _accountNumberStepData;

  KCAPIResponse? _enterBVNStepData;
  KCAPIResponse? get enterBVNStepData => _enterBVNStepData;

  KCAPIResponse? _sendBVNOTPStepData;
  KCAPIResponse? get sendBVNOTPStepData => _sendBVNOTPStepData;

  KCAPIResponse? _verifyBVNStepData;
  KCAPIResponse? get verifyBVNStepData => _verifyBVNStepData;

  KCAPIResponse? _acceptTermsStepData;
  KCAPIResponse? get acceptTermsStepData => _acceptTermsStepData;

  KCAPIResponse? _bioDataStepData;
  KCAPIResponse? get bioDataStepData => _bioDataStepData;

  KCAPIResponse? _loanOptionStepData;
  KCAPIResponse? get loanOptionStepData => _loanOptionStepData;

  KCAPIResponse? _repaymentDetailsStepData;
  KCAPIResponse? get repaymentDetailsStepData => _repaymentDetailsStepData;

  KCAPIResponse? _userKYCStepData;
  KCAPIResponse? get userKYCStepData => _userKYCStepData;

  KCAPIResponse? _documentVerificationStepData;
  KCAPIResponse? get documentVerificationStepData =>
      _documentVerificationStepData;

  KCAPIResponse? _proofAddressStepData;
  KCAPIResponse? get proofAddressStepData => _proofAddressStepData;

  KCAPIResponse? _selfieStepData;
  KCAPIResponse? get selfieStepData => _selfieStepData;

  KCAPIResponse? _newLoanStepData;
  KCAPIResponse? get newLoanStepData => _newLoanStepData;

  KCAPIResponse? _loanStatusStepData;
  KCAPIResponse? get loanStatusStepData => _loanStatusStepData;

  KCAPIResponse? _redirectStepData;
  KCAPIResponse? get redirectStepData => _redirectStepData;

  KCAPIResponse? _paymentLinkData;
  KCAPIResponse? get paymentLinkData => _paymentLinkData;

  void nextPage() {
    _currentPage++;
    _pageController.animateToPage(
      _currentPage,
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
    );
    notifyListeners();
  }

  void prevPage() {
    _currentPage--;
    _pageController.animateToPage(
      _currentPage,
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
    );
    notifyListeners();
  }

  Partner? _selectedBankFlow;
  Partner? get selectedBankFlow => _selectedBankFlow;
  int? _paymentSplit;
  int? get paymentSplit => _paymentSplit;
  int? _repaymentDay;
  int? get paymentDay => _repaymentDay;
  PartnerInsurer? _selectedPartnerInsurer;
  PartnerInsurer? get selectedPartnerInsurer => _selectedPartnerInsurer;
  String? _documentType;
  String? get documentType => _documentType;
  double? _downPayment;
  double? get downPayment => _downPayment;

  void setTransactionData(KlumpCheckoutData data) {
    _checkoutData = data;
  }

  void _setBusy(bool value) {
    _isBusy = value;
    notifyListeners();
  }

  void setBankFlow(Partner bank) {
    _selectedBankFlow = bank;
    _selectedBank = null;
    notifyListeners();
  }

  void selectBank(Map<String, dynamic> bank) {
    _selectedBank = bank;
    notifyListeners();
  }

  void selectDocumentType(String type) {
    _documentType = type;
    nextPage();
  }

  void storeNextStepData(KCAPIResponse data) {
    final stepName = data.nextStep.name?.toUpperCase();
    Logger().d(stepName);
    switch (stepName) {
      case 'LOGIN':
      case 'LOGIN_OR_CONNECT_MONO':
      case 'LOGIN_OR_CREATE_ACCOUNT':
      case 'ACCOUNT_VERIFICATION':
        _verificationStepData = data;
        break;
      case 'CONNECT_MONO':
      case 'VERIFY_OTP':
        _verifyOTPStepData = data;
        break;
      case 'CREATE_PHONE_OTP':
        _createPhoneNumberStepData = data;
        break;
      case 'VERIFY_PHONE_OTP':
        _verifyPhoneOTPStepData = data;
        break;
      case 'VERIFY_ACCOUNT_NUMBER':
        _accountNumberStepData = data;
        break;
      case 'BIO_DATA':
        _bioDataStepData = data;
        break;
      case 'USER_KYC':
        _userKYCStepData = data;
        break;
      case 'LOAN_OPTIONS':
        _loanOptionStepData = data;
        break;
      case 'DOCUMENT_VERIFICATION':
        _documentVerificationStepData = data;
        break;
      case 'PROOF_OF_ADDRESS':
        _proofAddressStepData = data;
        break;
      case 'FACE_VERIFICATION':
        _selfieStepData = data;
        break;
      case 'NEW_LOAN':
      case 'NEW_USER_LOAN':
        _newLoanStepData = data;
        break;
      case 'LOAN_STATUS':
        _loanStatusStepData = data;
        break;
      case 'ACCEPT_LOAN_TERMS':
        _repaymentDetailsStepData = data;
        break;
      case 'REDIRECT':
        _redirectStepData = data;
        break;
      case 'TERM_CONDITIONS':
        _acceptTermsStepData = data;
        break;
      case 'FETCH_BVN_VERIFICATION_METHODS':
        _enterBVNStepData = data;
        break;
      case 'SEND_BVN_OTP':
        _sendBVNOTPStepData = data;
        break;
      case 'VERIFY_BVN':
        _verifyBVNStepData = data;
        break;
      case 'PAYMENT_LINK':
        _paymentLinkData = data;
        break;
      default:
    }
  }

  Future<bool> initiateTransaction({
    required String email,
    required String phone,
  }) async {
    _setBusy(true);
    _email = email;
    _phoneNumber = phone;
    if (initiateResponse == null) {
      var sourceAnalytics = <String, dynamic>{
        'plugin_source': 'Flutter',
        'plugin_version': KC_PLUGIN_VERSION,
      };
      if (_checkoutData?.appVersion != null) {
        sourceAnalytics['app_version'] = _checkoutData!.appVersion!;
      }
      final response = await initiateTransactionUsecase(
        InitiateTransactionUsecaseParams(
          amount: _checkoutData!.amount + (_checkoutData!.shippingFee ?? 0),
          shippingFee: checkoutData!.shippingFee,
          currency: _checkoutData!.currency ?? 'NGN',
          publicKey: _checkoutData!.merchantPublicKey,
          metaData: _checkoutData!.metaData,
          email: email,
          phone: phone,
          items: _checkoutData?.items ?? [],
          shippingData: _checkoutData!.shippingData,
          merchantReference: _checkoutData!.merchantReference,
          sourceAnalytics: sourceAnalytics,
        ),
      );
      _setBusy(false);
      return response.fold(
        (l) {
          showToast(KCExceptionsToMessage.mapErrorToMessage(l));
          return false;
        },
        (r) {
          _initiateResponse = r;
          MixPanelService.logEvent(
            '3 - Select Payment institution Modal',
            properties: {
              'environment': r.isLive ? 'production' : 'staging',
            },
          );
          return true;
        },
      );
    } else {
      return false;
    }
  }

  Future<void> getLoanPartners() async {
    _setBusy(true);
    final response = await getLoanPartnersUsecase(
      GetLoanPartnersUsecaseParams(
        publicKey: _checkoutData?.merchantPublicKey ?? '',
        amount: _checkoutData!.amount + (_checkoutData!.shippingFee ?? 0),
      ),
    );
    response.fold(
      (l) => showToast(KCExceptionsToMessage.mapErrorToMessage(l)),
      (r) {
        _loanPartners = r;
      },
    );
    _setBusy(false);
  }

  Future<void> validateAccount({
    String? accountNumber,
    String? phoneNumber,
    String? firstName,
    String? email,
    String? password,
    String? username,
    String? pin,
  }) async {
    _setBusy(true);
    _accountNumber = accountNumber ?? _accountNumber;
    _phoneNumber = phoneNumber ?? _phoneNumber;
    _firstName = firstName ?? _firstName;
    _email = email ?? _email;
    _username = username ?? _username;
    final formFields =
        (verificationStepData?.nextStep ?? selectedBankFlow?.nextStep)
            ?.formFields
            ?.map((e) => e.name)
            .toList();
    Map<String, dynamic> data = {
      'is_live': initiateResponse?.isLive == true,
      'partner': _selectedBankFlow!.slug,
      'klump_public_key': _checkoutData?.merchantPublicKey,
    };
    if (formFields?.contains('accountNumber') == true) {
      data['accountNumber'] = _accountNumber;
    }
    if (formFields?.contains('phoneNumber') == true) {
      data['phoneNumber'] = _phoneNumber;
    }
    if (formFields?.contains('bank') == true) {
      data['bank'] = _selectedBank != null ? _selectedBank!['slug'] : null;
    }
    if (formFields?.contains('firstName') == true) {
      data['firstName'] = firstName;
    }
    if (formFields?.contains('firstname') == true) {
      data['firstname'] = firstName;
    }
    if (formFields?.contains('password') == true) {
      data['password'] = password;
    }
    if (formFields?.contains('amount') == true ||
        selectedBankFlow?.slug == 'fidelity') {
      data['amount'] =
          _checkoutData!.amount + (_checkoutData!.shippingFee ?? 0);
    }
    if (formFields?.contains('email') == true) {
      data['email'] = _email;
    }

    if (formFields?.contains('currency') == true) {
      data['currency'] = 'NGN';
    }
    if (formFields?.contains('username') == true) {
      data['username'] = username;
    }
    if (formFields?.contains('pin') == true) {
      data['pin'] = pin;
    }
    MixPanelService.logEvent(
      '6 - ACCOUNT VERIFICATION MODAL',
      properties: {
        'environment':
            initiateResponse?.isLive == true ? 'production' : 'staging',
        'partner': selectedBankFlow!.slug,
        'payload': data,
      },
    );
    final response = await partnersUsecase(
      PartnersUsecaseParams(
        method: verificationStepData?.nextStep.method ??
            selectedBankFlow?.nextStep?.method ??
            '',
        api: verificationStepData?.nextStep.api ??
            selectedBankFlow?.nextStep?.api ??
            '',
        publicKey: _checkoutData?.merchantPublicKey ?? '',
        partner: _selectedBankFlow!.slug,
        data: data,
      ),
    );
    _setBusy(false);
    response.fold(
      (l) => showToast(KCExceptionsToMessage.mapErrorToMessage(l)),
      (r) {
        storeNextStepData(r);
        nextPage();
      },
    );
  }

  Future<bool> resendAccountOTP() async {
    _setBusy(true);
    final response = await accountValidationUsecase(
      AccountValidationUsecaseParams(
        accountNumber: _accountNumber!,
        phoneNumber: _phoneNumber!,
        publicKey: _checkoutData!.merchantPublicKey,
        partner: _selectedBankFlow!.slug,
        firstName: _firstName,
        bank: _selectedBank != null ? _selectedBank!['slug'] : null,
        isLive: initiateResponse?.isLive == true,
      ),
    );
    _setBusy(false);
    return response.fold(
      (l) {
        showToast(KCExceptionsToMessage.mapErrorToMessage(l));
        return false;
      },
      (r) {
        showToast('OTP has been sent.');
        return true;
      },
    );
  }

  Future<void> verifyOTP(String? otp, String? password) async {
    _setBusy(true);
    final response = await verifyOTPUsecase(
      VerifyOTPUsecaseParams(
        accountNumber:
            _accountNumber?.isNotEmpty == true ? _accountNumber : null,
        phoneNumber: _phoneNumber?.isNotEmpty == true ? _phoneNumber : null,
        email: _email?.isNotEmpty == true ? _email : null,
        otp: otp,
        password: password,
        publicKey: _checkoutData!.merchantPublicKey,
        partner: _selectedBankFlow!.slug,
        firstName: _firstName,
        bank: _selectedBank != null ? _selectedBank!['slug'] : null,
        isLive: initiateResponse?.isLive == true,
      ),
    );
    response.fold(
      (l) => showToast(KCExceptionsToMessage.mapErrorToMessage(l)),
      (r) {
        storeNextStepData(r);
        _klumpUser = r.data as KlumpUser;
        if (r.nextStep.name == 'NEW_LOAN') {
          createLoan();
        } else {
          nextPage();
        }
      },
    );
    _setBusy(false);
  }

  // Future<void> fetchBankTC() async {
  //   _setBusy(true);
  //   final response = await getBankTCUsecase(GetBankTCUsecaseParams(
  //     publicKey: _checkoutData?.merchantPublicKey ?? '',
  //     partner: _selectedBankFlow!.slug,
  //     isLive: initiateResponse?.isLive == true,
  //   ));
  //   response.fold(
  //     (l) => {},
  //     (r) {
  //       storeNextStepData(r);
  //       _termsCondition = r.data;
  //     },
  //   );
  //   _setBusy(false);
  // }

  Future<void> createLoan() async {
    _setBusy(true);
    final data = <String, dynamic>{
      "amount": _checkoutData?.amount ?? 0,
      'partner': _selectedBankFlow!.slug,
      'is_live': initiateResponse?.isLive == true,
      'klump_public_key': _checkoutData?.merchantPublicKey ?? '',
      "items": (_checkoutData?.items ?? []).map((e) => e.toMap()).toList(),
      "merchant_reference": _checkoutData!.merchantReference,
    };
    if (_checkoutData?.shippingData != null) {
      data.addAll({
        'shipping_data': _checkoutData?.shippingData,
      });
    }
    if (_selectedPartnerInsurer?.id != null) {
      data.addAll({
        "insurerId": _selectedPartnerInsurer?.id,
      });
    }

    if (_acceptTermsStepData?.nextStep.displayData?.version != null) {
      data.addAll({
        "termsAndConditionVersion":
            _acceptTermsStepData?.nextStep.displayData?.version.toString(),
      });
    }
    if (_repaymentDetails?.installment != null) {
      data.addAll({
        "installment": _repaymentDetails?.installment,
      });
    }
    if (_repaymentDetails?.repaymentDay != null) {
      data.addAll({
        "repaymentDay":
            int.tryParse(_repaymentDetails!.repaymentDay.toString()),
      });
    }
    if (_downPayment != null) {
      data.addAll({
        "downpayment_amount": _downPayment,
      });
    }
    data.addAll({
      'meta_data': checkoutData!.metaData,
    });
    final response = await partnersUsecase(
      PartnersUsecaseParams(
        method: newLoanStepData?.nextStep.method ?? '',
        api: newLoanStepData?.nextStep.api ?? '',
        publicKey: _checkoutData?.merchantPublicKey ?? '',
        partner: _selectedBankFlow!.slug,
        data: data,
      ),
    );

    response.fold(
      (l) => showToast(KCExceptionsToMessage.mapErrorToMessage(l)),
      (r) async {
        Logger().d("New loan data: $r");
        storeNextStepData(r);
        nextPage();
      },
    );
    _setBusy(false);
  }

  Future<DisbursementStatusResponse?> getLoanStatus() async {
    Logger().d(
      loanStatusStepData?.nextStep.api ?? redirectStepData?.nextStep.api ?? '',
    );
    final response = await getLoanStatusUsecase(
      GetLoanStatusUsecaseParams(
        url: loanStatusStepData?.nextStep.api ??
            redirectStepData?.nextStep.api ??
            paymentLinkData?.nextStep.api ??
            '',
        publicKey: _checkoutData?.merchantPublicKey ?? '',
        isLive: initiateResponse?.isLive == true,
      ),
    );
    return response.fold(
      (l) => null,
      (r) {
        _disbursementStatusResponse = r;
        MixPanelService.logEvent(
          '13 - SUCCESSFUL MODAL',
          properties: {
            'environment':
                initiateResponse?.isLive == true ? 'production' : 'staging',
            'partner': selectedBankFlow?.slug,
          },
        );
        return r;
      },
    );
  }

  void skipLoanStatus() {
    _disbursementStatusResponse = const DisbursementStatusResponse(
      isCompleted: true,
      isSuccessful: false,
      message: 'Transaction Failed',
      next_repayment_date: null,
      responseMessage: null,
      transaction: null,
    );
  }

  Future<void> getPartnerInsurer() async {
    if (_selectedBankFlow!.slug == 'stanbic') {
      _setBusy(true);
      final response = await getPartnerInsurersUsecase(
        GetPartnerInsurersUsecaseParams(
          publicKey: _checkoutData?.merchantPublicKey ?? '',
          partner: _selectedBankFlow!.slug,
          amount: _checkoutData?.amount ?? 0,
          isLive: initiateResponse?.isLive == true,
        ),
      );
      response.fold(
        (l) => showToast(KCExceptionsToMessage.mapErrorToMessage(l)),
        (r) {
          _partnerInsurers = r;
        },
      );
      _setBusy(false);
    }
  }

  Future<void> addAccountCredentials(
      String email, String password, DateTime? dob) async {
    _setBusy(true);
    final response = await accountCredentialsUsecase(
      AccountCredentialsUsecaseParams(
        publicKey: _checkoutData?.merchantPublicKey ?? '',
        email: email,
        password: password,
        partner: _selectedBankFlow!.slug,
        isLive: initiateResponse?.isLive == true,
        dob: dob,
      ),
    );
    _setBusy(false);
    response.fold(
      (l) => showToast(KCExceptionsToMessage.mapErrorToMessage(l)),
      (r) {
        if (r.nextStep.name == 'NEW_LOAN' &&
            _selectedBankFlow!.slug != 'stanbic') {
          createLoan();
        } else {
          nextPage();
        }
      },
    );
  }

  Future<void> acceptRepaymentTerms({
    String? reference,
  }) async {
    _setBusy(true);
    var data = {
      'partner': _selectedBankFlow!.slug,
      'is_live': initiateResponse?.isLive == true,
      'klump_public_key': _checkoutData?.merchantPublicKey ?? '',
      'is_accepted': true
    };
    if (reference != null) {
      data['reference'] = reference;
    }
    Logger().d(data);
    final response = await partnersUsecase(
      PartnersUsecaseParams(
        method: repaymentDetailsStepData?.nextStep.method ?? '',
        api: repaymentDetailsStepData?.nextStep.api ?? '',
        publicKey: _checkoutData?.merchantPublicKey ?? '',
        partner: _selectedBankFlow!.slug,
        data: data,
      ),
    );
    _setBusy(false);
    response.fold(
      (l) => showToast(KCExceptionsToMessage.mapErrorToMessage(l)),
      (r) {
        storeNextStepData(r);
        if (r.nextStep.name == 'NEW_LOAN' &&
            _selectedBankFlow!.slug != 'stanbic') {
          createLoan();
        } else {
          nextPage();
        }
      },
    );
  }

  Future<void> acceptTermsAndCondition({
    String? reference,
  }) async {
    _setBusy(true);
    var data = {
      'partner': _selectedBankFlow!.slug,
      'is_live': initiateResponse?.isLive == true,
      'klump_public_key': _checkoutData?.merchantPublicKey ?? '',
    };
    if (reference != null) {
      data['reference'] = reference;
    }
    final response = await partnersUsecase(
      PartnersUsecaseParams(
        method: acceptTermsStepData?.nextStep.method ?? '',
        api: acceptTermsStepData?.nextStep.api ?? '',
        publicKey: _checkoutData?.merchantPublicKey ?? '',
        partner: _selectedBankFlow!.slug,
        data: data,
      ),
    );
    _setBusy(false);
    response.fold(
      (l) => showToast(KCExceptionsToMessage.mapErrorToMessage(l)),
      (r) {
        storeNextStepData(r);
        if (r.nextStep.name == 'NEW_LOAN' &&
            _selectedBankFlow!.slug != 'stanbic') {
          createLoan();
        } else {
          nextPage();
        }
      },
    );
  }

  Future<void> wemaRedirect() async {
    _setBusy(true);
    final response = await partnersUsecase(
      PartnersUsecaseParams(
        method: _redirectStepData?.nextStep.method ?? '',
        api: _redirectStepData?.nextStep.api ?? '',
        publicKey: _checkoutData?.merchantPublicKey ?? '',
        partner: _selectedBankFlow!.slug,
        data: null,
      ),
    );
    _setBusy(false);
    response.fold(
      (l) => showToast(KCExceptionsToMessage.mapErrorToMessage(l)),
      (r) {
        storeNextStepData(r);
        nextPage();
      },
    );
  }

  Future<void> acceptRequirement() async {
    _setBusy(true);
    final response = await partnersUsecase(
      PartnersUsecaseParams(
        method: _selectedBankFlow?.nextStep?.method ?? '',
        api: _selectedBankFlow?.nextStep?.api ?? '',
        publicKey: _checkoutData?.merchantPublicKey ?? '',
        partner: _selectedBankFlow!.slug,
        data: null,
      ),
    );
    _setBusy(false);
    response.fold(
      (l) => showToast(KCExceptionsToMessage.mapErrorToMessage(l)),
      (r) {
        storeNextStepData(r);
        nextPage();
      },
    );
  }

  Future<void> newAccount() async {
    _setBusy(true);
    final data = {
      'amount': _checkoutData!.amount + (_checkoutData!.shippingFee ?? 0),
      'currency': _checkoutData!.currency ?? 'NGN',
      'partner': _selectedBankFlow!.slug,
      'is_live': initiateResponse?.isLive == true,
      'klump_public_key': _checkoutData?.merchantPublicKey ?? '',
      'email': email,
    };
    Logger().d(data);
    Logger().d(verificationStepData?.nextStep.api);
    final response = await partnersUsecase(
      PartnersUsecaseParams(
        method: verificationStepData?.nextStep.method ?? '',
        api: verificationStepData?.nextStep.api ?? '',
        publicKey: _checkoutData?.merchantPublicKey ?? '',
        partner: _selectedBankFlow!.slug,
        data: data,
      ),
    );
    _setBusy(false);
    response.fold(
      (l) => showToast(KCExceptionsToMessage.mapErrorToMessage(l)),
      (r) {
        storeNextStepData(r);
        nextPage();
      },
    );
  }

  Future<void> linkWithMono(BuildContext context) async {
    String monoCode = '';
    await showDialog(
      barrierDismissible: false,
      // ignore: use_build_context_synchronously
      context: context,
      builder: (_) {
        return Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.height - 20,
            child: MonoWebView(
              apiKey: initiateResponse?.isLive == true
                  ? KC_MONO_KEY_LIVE
                  : KC_MONO_KEY_TEST,
              scope: "auth", // NEWLY INTRODUCED
              onClosed: (data) {
                monoCode = data ?? '';
              },
              onSuccess: (code) {
                monoCode = code;
              },
              data:
                  // NEWLY INTRODUCED
                  {
                'customer': {
                  'name': '$firstName', // REQUIRED
                  'email': '$email', // REQUIRED
                  'identity': {
                    'type': "phone",
                    'number': "$phoneNumber",
                  }
                }
              },
            ),
          ),
        );
      },
    );
    if (monoCode.isNotEmpty) {
      _setBusy(true);
      final response = await partnersUsecase(
        PartnersUsecaseParams(
          method: verifyOTPStepData?.nextStep.method ?? '',
          api: verifyOTPStepData?.nextStep.api ?? '',
          publicKey: _checkoutData?.merchantPublicKey ?? '',
          partner: _selectedBankFlow!.slug,
          data: {
            'amount': _checkoutData!.amount + (_checkoutData!.shippingFee ?? 0),
            'currency': _checkoutData!.currency ?? 'NGN',
            'mono_auth_code': monoCode,
            'partner': _selectedBankFlow!.slug,
            'klump_public_key': _checkoutData?.merchantPublicKey ?? '',
            'is_live': initiateResponse?.isLive == true,
          },
        ),
      );
      _setBusy(false);
      response.fold(
        (l) => showToast(KCExceptionsToMessage.mapErrorToMessage(l)),
        (r) {
          _klumpUser = r.data as KlumpUser;
          storeNextStepData(r);
          nextPage();
        },
      );
    }
  }

  Future<void> linkExistingMono(
    BuildContext context, {
    required String? monoAuthCode,
    required String? token,
  }) async {
    _setBusy(true);
    final response = await partnersUsecase(
      PartnersUsecaseParams(
        method: verifyOTPStepData?.nextStep.method ?? '',
        api: verifyOTPStepData?.nextStep.api ?? '',
        publicKey: _checkoutData?.merchantPublicKey ?? '',
        partner: _selectedBankFlow!.slug,
        data: {
          'amount': _checkoutData!.amount + (_checkoutData!.shippingFee ?? 0),
          'currency': _checkoutData!.currency ?? 'NGN',
          'mono_auth_code': monoAuthCode ?? '',
          'partner': _selectedBankFlow!.slug,
          'klump_public_key': _checkoutData?.merchantPublicKey ?? '',
          'is_live': initiateResponse?.isLive == true,
          'is_accepted': true,
          'token': token ?? '',
        },
      ),
    );
    _setBusy(false);
    response.fold(
      (l) => showToast(KCExceptionsToMessage.mapErrorToMessage(l)),
      (r) {
        _klumpUser = r.data as KlumpUser;
        storeNextStepData(r);
        nextPage();
      },
    );
  }

  Future<void> bioData({
    required String? email,
    required String? firstname,
    required String? lastname,
    required DateTime? dob,
    required String? password,
    required double? amount,
    required String? apartment,
    required String? address,
    required String? city,
    required String? state,
  }) async {
    _setBusy(true);
    final data = <String, dynamic>{
      'partner': _selectedBankFlow!.slug,
      'is_live': initiateResponse?.isLive == true,
      'klump_public_key': _checkoutData?.merchantPublicKey ?? '',
    };
    if (email?.isNotEmpty == true) {
      _email = email;
      data.addAll({'email': email});
    }
    if (password?.isNotEmpty == true) {
      data.addAll({'password': password});
    }
    if (firstname?.isNotEmpty == true) {
      data.addAll({'firstname': firstname});
    }
    if (lastname?.isNotEmpty == true) {
      data.addAll({'lastname': lastname});
    }
    if (dob != null) {
      data.addAll({
        'date_of_birth': KCStringUtil.formatServerDate(dob),
      });
    }
    if (amount != null) {
      data.addAll({'amount': amount});
    }
    if (apartment?.isNotEmpty == true) {
      data.addAll({'apartment': apartment});
    }
    if (address?.isNotEmpty == true) {
      data.addAll({'address': address});
    }
    if (city?.isNotEmpty == true) {
      data.addAll({'city': city});
    }
    if (state?.isNotEmpty == true) {
      data.addAll({'state': state});
    }
    Logger().d(data);
    final response = await partnersUsecase(
      PartnersUsecaseParams(
        method: bioDataStepData?.nextStep.method ?? '',
        api: bioDataStepData?.nextStep.api ?? '',
        publicKey: _checkoutData?.merchantPublicKey ?? '',
        partner: _selectedBankFlow!.slug,
        data: data,
      ),
    );
    _setBusy(false);
    response.fold(
      (l) => showToast(KCExceptionsToMessage.mapErrorToMessage(l)),
      (r) {
        storeNextStepData(r);
        if (r.nextStep.name?.toUpperCase() == 'NEW_LOAN' &&
            _selectedBankFlow!.slug != 'stanbic') {
          createLoan();
        } else {
          nextPage();
        }
      },
    );
  }

  Future<void> partnerKYC({
    required String? nin,
    required String? maritalStatus,
    required String? residentialStatus,
    required String? address,
    required String? landmark,
    required String? city,
    required String? state,
    required DateTime? dateMovedIn,
    required String? employmentStatus,
    required String? companyName,
    required String? companyIndustry,
    required String? companyAddress,
    required DateTime? companyStartDate,
    required String? monthlyIncome,
    required String? education,
    required String? nextOfKinName,
    required String? nextOfKinRetionship,
    required String? nextOfKinPhone,
  }) async {
    _setBusy(true);
    final data = <String, dynamic>{
      'partner': _selectedBankFlow!.slug,
      'is_live': initiateResponse?.isLive == true,
      'klump_public_key': _checkoutData?.merchantPublicKey ?? '',
    };
    if (nin?.isNotEmpty == true) {
      data.addAll({'nin': nin});
    }
    if (maritalStatus?.isNotEmpty == true) {
      data.addAll({'marital_status': maritalStatus});
    }
    if (residentialStatus?.isNotEmpty == true) {
      data.addAll({'residential_status': residentialStatus});
    }
    if (address?.isNotEmpty == true) {
      data.addAll({'address': address});
    }
    if (landmark?.isNotEmpty == true) {
      data.addAll({'landmark': landmark});
    }
    if (city?.isNotEmpty == true) {
      data.addAll({'city': city});
    }
    if (state?.isNotEmpty == true) {
      data.addAll({'state': state});
    }
    if (dateMovedIn != null) {
      data.addAll({
        'date_moved_in': KCStringUtil.formatServerDate(dateMovedIn),
      });
    }
    if (employmentStatus?.isNotEmpty == true) {
      data.addAll({'employment_status': employmentStatus});
    }
    if (companyName?.isNotEmpty == true) {
      data.addAll({'company_name': companyName});
    }
    if (companyIndustry?.isNotEmpty == true) {
      data.addAll({'company_industry': companyIndustry});
    }
    if (companyAddress?.isNotEmpty == true) {
      data.addAll({'company_address': companyAddress});
    }
    if (companyStartDate != null) {
      data.addAll({
        'company_start_date': KCStringUtil.formatServerDate(companyStartDate),
      });
    }
    if (monthlyIncome?.isNotEmpty == true) {
      data.addAll({
        'monthly_income': KCStringUtil.convertTextFigure(monthlyIncome!),
      });
    }
    if (education?.isNotEmpty == true) {
      data.addAll({'education': education});
    }
    if (nextOfKinName?.isNotEmpty == true) {
      data.addAll({'next_of_kin_name': nextOfKinName});
    }
    if (nextOfKinRetionship?.isNotEmpty == true) {
      data.addAll({'next_of_kin_relationship': nextOfKinRetionship});
    }
    if (nextOfKinPhone?.isNotEmpty == true) {
      data.addAll({'next_of_kin_phone': nextOfKinPhone});
    }
    final response = await partnersUsecase(
      PartnersUsecaseParams(
        method: userKYCStepData?.nextStep.method ?? '',
        api: userKYCStepData?.nextStep.api ?? '',
        publicKey: _checkoutData?.merchantPublicKey ?? '',
        partner: _selectedBankFlow!.slug,
        data: data,
      ),
    );
    _setBusy(false);
    response.fold(
      (l) => showToast(KCExceptionsToMessage.mapErrorToMessage(l)),
      (r) {
        storeNextStepData(r);
        nextPage();
      },
    );
  }

  Future<void> getRepaymentDetails({
    required String? installments,
    required int? repaymentDay,
    required PartnerInsurer? insurer,
    required double? downpaymentAmount,
  }) async {
    _setBusy(true);
    final data = <String, dynamic>{
      "amount": _checkoutData?.amount ?? 0,
      'partner': _selectedBankFlow!.slug,
      'is_live': initiateResponse?.isLive == true,
      'klump_public_key': _checkoutData?.merchantPublicKey ?? '',
    };
    if (installments?.isNotEmpty == true) {
      data.addAll({'installment': int.parse(installments!)});
    }
    if (repaymentDay != null) {
      _repaymentDay = repaymentDay;
      data.addAll({'repayment_day': repaymentDay});
    }
    if (insurer != null) {
      _selectedPartnerInsurer = insurer;
      data.addAll({
        'insurerId': insurer.id,
      });
    }
    if (downpaymentAmount != null) {
      _downPayment = downpaymentAmount;
      data.addAll({
        'downpayment_amount': downpaymentAmount,
      });
    }
    final response = await partnersUsecase(
      PartnersUsecaseParams(
        method: loanOptionStepData?.nextStep.method ?? '',
        api: loanOptionStepData?.nextStep.api ?? '',
        publicKey: _checkoutData?.merchantPublicKey ?? '',
        partner: _selectedBankFlow!.slug,
        data: data,
      ),
    );
    _setBusy(false);
    response.fold(
      (l) => showToast(KCExceptionsToMessage.mapErrorToMessage(l)),
      (r) {
        storeNextStepData(r);
        if (r.nextStep.name?.toUpperCase() == 'NEW_LOAN' &&
            _selectedBankFlow!.slug != 'stanbic') {
          createLoan();
        } else {
          _repaymentDetails = r.data;
          nextPage();
        }
      },
    );
  }

  Future<void> uploadDocument({
    required String idNumber,
    required File file,
  }) async {
    _setBusy(true);
    final fileBytes = await File(file.path).readAsBytes();
    final base64File = 'data:image/jpeg;base64,${base64.encode(fileBytes)}';
    final data = <String, dynamic>{
      "amount": _checkoutData?.amount ?? 0,
      'partner': _selectedBankFlow!.slug,
      'is_live': initiateResponse?.isLive == true,
      'klump_public_key': _checkoutData?.merchantPublicKey ?? '',
      'number': idNumber,
      'type': documentType,
      'document_file': base64File,
    };
    final response = await partnersUsecase(
      PartnersUsecaseParams(
        method: documentVerificationStepData?.nextStep.method ?? '',
        api: documentVerificationStepData?.nextStep.api ?? '',
        publicKey: _checkoutData?.merchantPublicKey ?? '',
        partner: _selectedBankFlow!.slug,
        data: data,
      ),
    );
    _setBusy(false);
    response.fold(
      (l) => showToast(KCExceptionsToMessage.mapErrorToMessage(l)),
      (r) {
        storeNextStepData(r);
        nextPage();
      },
    );
  }

  Future<void> addressVerify({
    required File file,
  }) async {
    _setBusy(true);
    final fileBytes = await File(file.path).readAsBytes();
    final base64File = 'data:image/jpeg;base64,${base64.encode(fileBytes)}';
    final data = <String, dynamic>{
      "amount": _checkoutData?.amount ?? 0,
      'partner': _selectedBankFlow!.slug,
      'is_live': initiateResponse?.isLive == true,
      'klump_public_key': _checkoutData?.merchantPublicKey ?? '',
      'document_file': base64File,
    };
    final response = await partnersUsecase(
      PartnersUsecaseParams(
        method: proofAddressStepData?.nextStep.method ?? '',
        api: proofAddressStepData?.nextStep.api ?? '',
        publicKey: _checkoutData?.merchantPublicKey ?? '',
        partner: _selectedBankFlow!.slug,
        data: data,
      ),
    );
    _setBusy(false);
    response.fold(
      (l) => showToast(KCExceptionsToMessage.mapErrorToMessage(l)),
      (r) {
        storeNextStepData(r);
        nextPage();
      },
    );
  }

  Future<void> validateSelfie({
    required String filePath,
  }) async {
    _setBusy(true);
    final fileBytes = await File(filePath).readAsBytes();
    final base64File = 'data:image/jpeg;base64,${base64.encode(fileBytes)}';
    final data = <String, dynamic>{
      "amount": _checkoutData?.amount ?? 0,
      'partner': _selectedBankFlow!.slug,
      'is_live': initiateResponse?.isLive == true,
      'klump_public_key': _checkoutData?.merchantPublicKey ?? '',
      'selfie_file': base64File,
    };
    final response = await partnersUsecase(
      PartnersUsecaseParams(
        method: selfieStepData?.nextStep.method ?? '',
        api: selfieStepData?.nextStep.api ?? '',
        publicKey: _checkoutData?.merchantPublicKey ?? '',
        partner: _selectedBankFlow!.slug,
        data: data,
      ),
    );
    _setBusy(false);
    response.fold(
      (l) => showToast(KCExceptionsToMessage.mapErrorToMessage(l)),
      (r) {
        storeNextStepData(r);
        if (r.nextStep.name == 'NEW_LOAN' ||
            r.nextStep.name == 'NEW_USER_LOAN') {
          createLoan();
        } else {
          nextPage();
        }
      },
    );
  }

  Map<String, dynamic>? _selectedBank;
  Map<String, dynamic>? get selectedBank => _selectedBank;

  Future<void> verifyAccountNumber({
    required String accountNumber,
    required Map<String, dynamic> bank,
  }) async {
    _setBusy(true);
    _accountNumber = accountNumber;
    _selectedBank = bank;
    final token =
        (createPhoneNumberStepData?.data as Map<String, dynamic>?)?['token'] ??
            (_bioDataStepData?.data as Map<String, dynamic>?)?['token'];
    final data = <String, dynamic>{
      "accountNumber": accountNumber,
      "bank_code": bank['value'],
      "bank_name": bank['label'],
      "amount": _checkoutData?.amount ?? 0,
      "token": token,
      "currency": 'NGN',
      'partner': _selectedBankFlow!.slug,
      'is_live': initiateResponse?.isLive == true,
      'klump_public_key': _checkoutData?.merchantPublicKey ?? '',
    };
    final response = await partnersUsecase(
      PartnersUsecaseParams(
        method: accountNumberStepData?.nextStep.method ?? '',
        api: accountNumberStepData?.nextStep.api ?? '',
        publicKey: _checkoutData?.merchantPublicKey ?? '',
        partner: _selectedBankFlow!.slug,
        data: data,
      ),
    );
    _setBusy(false);
    response.fold(
      (l) => showToast(KCExceptionsToMessage.mapErrorToMessage(l)),
      (r) {
        storeNextStepData(r);
        if (r.nextStep.name == 'NEW_LOAN') {
          createLoan();
        } else {
          nextPage();
        }
      },
    );
  }

  String? _bvn;
  String? get bvn => _bvn;
  Future<void> enterBVN({
    required String bvn,
  }) async {
    _setBusy(true);
    _bvn = bvn;
    final data = <String, dynamic>{
      "bvn": bvn,
      'partner': _selectedBankFlow!.slug,
      'is_live': initiateResponse?.isLive == true,
      'klump_public_key': _checkoutData?.merchantPublicKey ?? '',
    };
    final response = await partnersUsecase(
      PartnersUsecaseParams(
        method: enterBVNStepData?.nextStep.method ?? '',
        api: enterBVNStepData?.nextStep.api ?? '',
        publicKey: _checkoutData?.merchantPublicKey ?? '',
        partner: _selectedBankFlow!.slug,
        data: data,
      ),
    );
    _setBusy(false);
    response.fold(
      (l) => showToast(KCExceptionsToMessage.mapErrorToMessage(l)),
      (r) {
        storeNextStepData(r);
        if (r.nextStep.name == 'NEW_LOAN') {
          createLoan();
        } else {
          nextPage();
        }
      },
    );
  }

  Map<String, dynamic>? _bvnContact;
  Map<String, dynamic>? get bvnContact => _bvnContact;
  Future<void> sendBVNOTP({
    required String? bvn,
    required Map<String, dynamic> contact,
  }) async {
    _setBusy(true);
    _bvnContact = contact;
    final data = <String, dynamic>{
      "contact": contact['value'],
      'partner': _selectedBankFlow!.slug,
      'is_live': initiateResponse?.isLive == true,
      'klump_public_key': _checkoutData?.merchantPublicKey ?? '',
    };
    if (bvn != null) {
      data['bvn'] = bvn;
    }
    final response = await partnersUsecase(
      PartnersUsecaseParams(
        method: sendBVNOTPStepData?.nextStep.method ?? '',
        api: sendBVNOTPStepData?.nextStep.api ?? '',
        publicKey: _checkoutData?.merchantPublicKey ?? '',
        partner: _selectedBankFlow!.slug,
        data: data,
      ),
    );
    _setBusy(false);
    response.fold(
      (l) => showToast(KCExceptionsToMessage.mapErrorToMessage(l)),
      (r) {
        storeNextStepData(r);
        if (r.nextStep.name == 'NEW_LOAN') {
          createLoan();
        } else {
          nextPage();
        }
      },
    );
  }

  Future<void> verifyBVN({
    required String otp,
  }) async {
    _setBusy(true);
    final data = <String, dynamic>{
      "bvn": bvn,
      "contact": bvnContact!['value'],
      "bvn_otp": otp,
      'partner': _selectedBankFlow!.slug,
      'is_live': initiateResponse?.isLive == true,
      'klump_public_key': _checkoutData?.merchantPublicKey ?? '',
    };
    final response = await partnersUsecase(
      PartnersUsecaseParams(
        method: verifyBVNStepData?.nextStep.method ?? '',
        api: verifyBVNStepData?.nextStep.api ?? '',
        publicKey: _checkoutData?.merchantPublicKey ?? '',
        partner: _selectedBankFlow!.slug,
        data: data,
      ),
    );
    _setBusy(false);
    response.fold(
      (l) => showToast(KCExceptionsToMessage.mapErrorToMessage(l)),
      (r) {
        storeNextStepData(r);
        if (r.nextStep.name == 'NEW_LOAN') {
          createLoan();
        } else {
          nextPage();
        }
      },
    );
  }

  Future<void> createPhoneNumber({required String phoneNumber}) async {
    _setBusy(true);
    _phoneNumber = phoneNumber;
    final data = <String, dynamic>{
      "phone": phoneNumber,
      "token":
          (createPhoneNumberStepData?.data as Map<String, dynamic>?)?['token'],
      'partner': _selectedBankFlow!.slug,
      'is_live': initiateResponse?.isLive == true,
      'klump_public_key': _checkoutData?.merchantPublicKey ?? '',
    };
    Logger().d(data);
    final response = await partnersUsecase(
      PartnersUsecaseParams(
        method: createPhoneNumberStepData?.nextStep.method ?? '',
        api: createPhoneNumberStepData?.nextStep.api ?? '',
        publicKey: _checkoutData?.merchantPublicKey ?? '',
        partner: _selectedBankFlow!.slug,
        data: data,
      ),
    );
    _setBusy(false);
    response.fold(
      (l) => showToast(KCExceptionsToMessage.mapErrorToMessage(l)),
      (r) {
        storeNextStepData(r);
        if (r.nextStep.name == 'NEW_LOAN') {
          createLoan();
        } else {
          nextPage();
        }
      },
    );
  }

  Future<void> verifyPhoneOTP({required String otp}) async {
    _setBusy(true);
    Logger().d(
        (createPhoneNumberStepData?.data as Map<String, dynamic>?)?['token']);
    final data = <String, dynamic>{
      "otp": otp,
      "phone": phoneNumber,
      "token":
          (createPhoneNumberStepData?.data as Map<String, dynamic>?)?['token'],
      'partner': _selectedBankFlow!.slug,
      'is_live': initiateResponse?.isLive == true,
      'klump_public_key': _checkoutData?.merchantPublicKey ?? '',
    };
    Logger().d(data);
    final response = await partnersUsecase(
      PartnersUsecaseParams(
        method: verifyPhoneOTPStepData?.nextStep.method ?? '',
        api: verifyPhoneOTPStepData?.nextStep.api ?? '',
        publicKey: _checkoutData?.merchantPublicKey ?? '',
        partner: _selectedBankFlow!.slug,
        data: data,
      ),
    );
    _setBusy(false);
    response.fold(
      (l) => showToast(KCExceptionsToMessage.mapErrorToMessage(l)),
      (r) {
        storeNextStepData(r);
        if (r.nextStep.name == 'NEW_LOAN') {
          createLoan();
        } else {
          nextPage();
        }
      },
    );
  }

  Future<void> resendPhoneOTP() async {
    _setBusy(true);
    final data = <String, dynamic>{
      "phone": phoneNumber,
      "token":
          (createPhoneNumberStepData?.data as Map<String, dynamic>?)?['token'],
      'partner': _selectedBankFlow!.slug,
      'is_live': initiateResponse?.isLive == true,
      'klump_public_key': _checkoutData?.merchantPublicKey ?? '',
    };
    final response = await partnersUsecase(
      PartnersUsecaseParams(
        method: createPhoneNumberStepData?.nextStep.method ?? '',
        api: createPhoneNumberStepData?.nextStep.api ?? '',
        publicKey: _checkoutData?.merchantPublicKey ?? '',
        partner: _selectedBankFlow!.slug,
        data: data,
      ),
    );
    _setBusy(false);
    response.fold(
      (l) => showToast(KCExceptionsToMessage.mapErrorToMessage(l)),
      (r) {
        storeNextStepData(r);
      },
    );
  }

  double get totalAmount =>
      _checkoutData!.amount + (_checkoutData!.shippingFee ?? 0);

  String get tranxReference =>
      redirectStepData?.data != null ? redirectStepData?.data['reference'] : '';

  List<Map<String, dynamic>> get productDetails {
    List<Map<String, dynamic>> items = [];
    for (var i = 0; i < _checkoutData!.items.length; i++) {
      final e = _checkoutData!.items[i];
      items.add({
        'productName': "'${e.name}'",
        'productAmount': "'${e.unitPrice}'",
        'productId': "'${i + 1}'",
      });
    }
    return items;
  }

  void selectBankSubmitted() {
    _verificationStepData = null;
    _verifyOTPStepData = null;
    _acceptTermsStepData = null;
    _bioDataStepData = null;
    _loanOptionStepData = null;
    _repaymentDetailsStepData = null;
    _userKYCStepData = null;
    _documentVerificationStepData = null;
    _proofAddressStepData = null;
    _selfieStepData = null;
    _newLoanStepData = null;
    _loanStatusStepData = null;
    _redirectStepData = null;
    _enterBVNStepData = null;
    _sendBVNOTPStepData = null;
    _verifyBVNStepData = null;
    _disbursementStatusResponse = null;
    _createPhoneNumberStepData = null;
    _verifyPhoneOTPStepData = null;
    _accountNumberStepData = null;
    _repaymentDetails = null;
    _disbursementStatusResponse = null;
    _paymentLinkData = null;
    _bvn = null;
    nextPage();
  }
}
