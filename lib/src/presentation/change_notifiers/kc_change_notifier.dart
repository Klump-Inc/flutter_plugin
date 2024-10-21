import 'package:flutter/material.dart';
import 'package:klump_checkout/src/domain/usecases/accept_terms.dart';
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
    createNewUsecase = CreateNewUsecase(partnerRepository: PartnerRepository());
    getLoanStatusUsecase =
        GetLoanStatusUsecase(partnerRepository: PartnerRepository());
    getPartnerInsurersUsecase =
        GetPartnerInsurersUsecase(partnerRepository: PartnerRepository());
    accountCredentialsUsecase =
        AccountCredentialsUsecase(partnerRepository: PartnerRepository());
    getLoanPartnersUsecase =
        GetLoanPartnersUsecase(partnerRepository: PartnerRepository());
    acceptTermsUsecase =
        AcceptTermsUsecase(partnerRepository: PartnerRepository());
    partnersUsecase = PartnersUsecase(partnerRepository: PartnerRepository());
  }
  late InitiateTransactionUsecase initiateTransactionUsecase;
  late AccountValidationUsecase accountValidationUsecase;
  late VerifyOTPUsecase verifyOTPUsecase;
  late GetBankTCUsecase getBankTCUsecase;
  late GetRepaymentDetailsUsecase getRepaymentDetailsUsecase;
  late CreateNewUsecase createNewUsecase;
  late GetLoanStatusUsecase getLoanStatusUsecase;
  late GetPartnerInsurersUsecase getPartnerInsurersUsecase;
  late AccountCredentialsUsecase accountCredentialsUsecase;
  late GetLoanPartnersUsecase getLoanPartnersUsecase;
  late AcceptTermsUsecase acceptTermsUsecase;
  late PartnersUsecase partnersUsecase;

  bool _isLive = false;
  bool get isLive => _isLive;
  bool _isBusy = false;
  bool get isBusy => _isBusy;
  var _currentPage = 0;
  int get currentPage => _currentPage;

  InitiateResponseModel? _initiateResponse;
  InitiateResponseModel? get initiateResponse => _initiateResponse;

  KlumpCheckoutData? _checkoutData;
  KlumpCheckoutData? get checkoutData => _checkoutData;

  KCAPIResponse? _nextStepData;
  KCAPIResponse? get nextStepData => _nextStepData;

  String? _email;
  String? _accountNumber;
  String? _phoneNumber;
  String? _firstName;
  String? get email => _email;
  String? get accountNumber => _accountNumber;
  String? get phoneNumber => _phoneNumber;
  String? get firstName => _firstName;
  TermsAndCondition? _termsCondition;
  TermsAndCondition? get termsCondition => _termsCondition;
  KlumpUser? _klumpUser;
  KlumpUser? get klumpUser => _klumpUser;
  RepaymentDetails? _repaymentDetails;
  RepaymentDetails? get repaymentDetails => _repaymentDetails;
  NextStep? _finalLoanStep;
  NextStep? get finalLoanStep => _finalLoanStep;
  DisbursementStatusResponse? _disbursementStatusResponse;
  DisbursementStatusResponse? get disbursementStatusResponse =>
      _disbursementStatusResponse;
  List<PartnerInsurer>? _partnerInsurers;
  List<PartnerInsurer>? get partnerInsurers => _partnerInsurers;
  List<Partner>? _loanPartners;
  List<Partner>? get loanPartners => _loanPartners;
  String? _loanId;
  String? get loanId => _loanId;

  Map<String, dynamic>? _selectedBank;
  Map<String, dynamic>? get selectedBank => _selectedBank;

  final PageController _pageController = PageController();
  PageController get pageController => _pageController;

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
    // _currentPage--;
    _currentPage = 0;
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

  void setTransactionData(bool isLive, KlumpCheckoutData data) {
    _isLive = isLive;
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

  Future<bool> initiateTransaction({
    required String email,
    required String phone,
  }) async {
    _setBusy(true);
    _email = email;
    _phoneNumber = phone;
    final response = await initiateTransactionUsecase(
      InitiateTransactionUsecaseParams(
        amount: _checkoutData!.amount + (_checkoutData!.shippingFee ?? 0),
        currency: _checkoutData!.currency ?? 'NGN',
        publicKey: _checkoutData!.merchantPublicKey,
        metaData: _checkoutData!.metaData,
        isLive: isLive,
        email: email,
        phone: phone,
        items: _checkoutData?.items ?? [],
        shippingData: _checkoutData?.shippingData,
      ),
    );
    _setBusy(false);
    return response.fold(
      (l) => false,
      (r) {
        _initiateResponse = r;
        return true;
      },
    );
  }

  Future<void> getLoanPartners() async {
    _setBusy(true);
    final response = await getLoanPartnersUsecase(
      GetLoanPartnersUsecaseParams(
        publicKey: _checkoutData?.merchantPublicKey ?? '',
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
    bool? skipPage,
  }) async {
    _setBusy(true);

    _accountNumber = accountNumber ?? _accountNumber;
    _phoneNumber = phoneNumber ?? _phoneNumber;
    _firstName = firstName ?? _firstName;
    _email = email ?? _email;
    final formFields = (nextStepData?.nextStep ?? selectedBankFlow?.nextStep)
        ?.formFields
        ?.map((e) => e.name)
        .toList();
    Map<String, dynamic> data = {
      'is_live': isLive,
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
    if (formFields?.contains('password') == true) {
      data['password'] = password;
    }
    if (formFields?.contains('amount') == true) {
      data['amount'] =
          _checkoutData!.amount + (_checkoutData!.shippingFee ?? 0);
    }
    if (formFields?.contains('email') == true) {
      data['email'] = email;
    }
    if (formFields?.contains('currency') == true) {
      data['currency'] = 'NGN';
    }
    MixPanelService.logEvent(
      '6 - ACCOUNT VERIFICATION MODAL',
      properties: {
        'environment': isLive ? 'production' : 'staging',
        'partner': selectedBankFlow!.slug,
        'payload': data,
      },
    );
    final response = await partnersUsecase(
      PartnersUsecaseParams(
        method: _nextStepData?.nextStep.method ?? '',
        api: _nextStepData?.nextStep.api ?? '',
        publicKey: _checkoutData?.merchantPublicKey ?? '',
        partner: _selectedBankFlow!.slug,
        data: data,
      ),
    );
    _setBusy(false);
    response.fold(
      (l) => showToast(KCExceptionsToMessage.mapErrorToMessage(l)),
      (r) {
        _nextStepData = r;
        if (skipPage == true) {
          _currentPage = _currentPage + 2;
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 300),
            curve: Curves.linear,
          );
          notifyListeners();
        } else {
          nextPage();
        }
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
      ),
    );
    response.fold(
      (l) => showToast(KCExceptionsToMessage.mapErrorToMessage(l)),
      (r) {
        _nextStepData = r;
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

  Future<void> fetchBankTC() async {
    _setBusy(true);
    final response = await getBankTCUsecase(GetBankTCUsecaseParams(
      publicKey: _checkoutData?.merchantPublicKey ?? '',
      partner: _selectedBankFlow!.slug,
    ));
    response.fold(
      (l) => {},
      (r) {
        _nextStepData = r;
        _termsCondition = r.data;
      },
    );
    _setBusy(false);
  }

  Future<void> createLoan() async {
    _setBusy(true);
    final response = await createNewUsecase(
      CreateNewUsecaseParams(
        amount: _checkoutData!.amount,
        publicKey: _checkoutData!.merchantPublicKey,
        installment: _repaymentDetails?.installment,
        repaymentDay: _repaymentDetails != null
            ? int.parse(_repaymentDetails!.repaymentDay.toString())
            : null,
        termsVersion: _termsCondition?.version,
        items: _checkoutData?.items ?? [],
        shippingData: _checkoutData?.shippingData,
        insurerId: _selectedPartnerInsurer?.value,
        partner: _selectedBankFlow!.slug,
      ),
    );
    response.fold(
      (l) => showToast(KCExceptionsToMessage.mapErrorToMessage(l)),
      (r) async {
        _finalLoanStep = r.nextStep;
        _loanId = r.data;
        nextPage();
      },
    );
    _setBusy(false);
  }

  Future<DisbursementStatusResponse?> getLoanStatus() async {
    final response = await getLoanStatusUsecase(
      GetLoanStatusUsecaseParams(
        url: selectedBankFlow?.slug == 'stanbic'
            ? '/loans/account/new-loan/$loanId'
            : _finalLoanStep?.api ?? '',
        publicKey: _checkoutData?.merchantPublicKey ?? '',
      ),
    );
    return response.fold(
      (l) => null,
      (r) {
        _disbursementStatusResponse = r;
        MixPanelService.logEvent(
          '13 - SUCCESSFUL MODAL',
          properties: {
            'environment': isLive ? 'production' : 'staging',
            'partner': selectedBankFlow?.slug,
          },
        );
        return r;
      },
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
        dob: dob,
      ),
    );
    _setBusy(false);
    response.fold(
      (l) => showToast(KCExceptionsToMessage.mapErrorToMessage(l)),
      (r) {
        if (r.nextStep.name == 'NEW_LOAN') {
          createLoan();
        } else {
          nextPage();
        }
      },
    );
  }

  Future<void> acceptTerms() async {
    if (nextStepData?.nextStep.name == 'ACCEPT_LOAN_TERMS') {
      _setBusy(true);
      final response = await acceptTermsUsecase(
        AcceptTermsUsecaseParams(
          publicKey: _checkoutData?.merchantPublicKey ?? '',
          partner: _selectedBankFlow!.slug,
        ),
      );
      _setBusy(false);
      response.fold(
        (l) => showToast(KCExceptionsToMessage.mapErrorToMessage(l)),
        (r) {
          if (r.nextStep.name == 'NEW_LOAN') {
            createLoan();
          } else {
            nextPage();
          }
        },
      );
    } else {
      nextPage();
    }
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
        _nextStepData = r;
        nextPage();
      },
    );
  }

  Future<void> newAccount() async {
    _setBusy(true);
    final response = await partnersUsecase(
      PartnersUsecaseParams(
        method: _nextStepData?.nextStep.method ?? '',
        api: _nextStepData?.nextStep.api ?? '',
        publicKey: _checkoutData?.merchantPublicKey ?? '',
        partner: _selectedBankFlow!.slug,
        data: {
          'amount': _checkoutData!.amount + (_checkoutData!.shippingFee ?? 0),
          'currency': _checkoutData!.currency ?? 'NGN',
          'partner': _selectedBankFlow!.slug,
          'is_live': isLive,
          'klump_public_key': _checkoutData?.merchantPublicKey ?? '',
        },
      ),
    );
    _setBusy(false);
    response.fold(
      (l) => showToast(KCExceptionsToMessage.mapErrorToMessage(l)),
      (r) {
        _nextStepData = r;
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
              apiKey: KC_MONO_KEY_TEST,
              scope: "auth", // NEWLY INTRODUCED
              data:
                  // NEWLY INTRODUCED
                  {
                "customer": {
                  "name": "$firstName", // REQUIRED
                  "email": email, // REQUIRED
                  "identity": {
                    "type": "phone",
                    "number": phoneNumber,
                  }
                }
              },
              onClosed: (data) {
                monoCode = data ?? '';
              },
              onSuccess: (code) {
                monoCode = code;
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
          method: _nextStepData?.nextStep.method ?? '',
          api: _nextStepData?.nextStep.api ?? '',
          publicKey: _checkoutData?.merchantPublicKey ?? '',
          partner: _selectedBankFlow!.slug,
          data: {
            'amount': _checkoutData!.amount + (_checkoutData!.shippingFee ?? 0),
            'currency': _checkoutData!.currency ?? 'NGN',
            'mono_auth_code': monoCode,
            'partner': _selectedBankFlow!.slug,
            'klump_public_key': _checkoutData?.merchantPublicKey ?? '',
          },
        ),
      );
      _setBusy(false);
      response.fold(
        (l) => showToast(KCExceptionsToMessage.mapErrorToMessage(l)),
        (r) {
          _nextStepData = r;
          nextPage();
        },
      );
    }
  }

  Future<void> bioData({
    required String? email,
    required String? firstname,
    required String? lastname,
    required DateTime? dob,
    required String? password,
  }) async {
    _setBusy(true);
    final data = <String, dynamic>{
      'partner': _selectedBankFlow!.slug,
      'is_live': isLive,
      'klump_public_key': _checkoutData?.merchantPublicKey ?? '',
    };
    if (email?.isNotEmpty == true) {
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
    final response = await partnersUsecase(
      PartnersUsecaseParams(
        method: _nextStepData?.nextStep.method ?? '',
        api: _nextStepData?.nextStep.api ?? '',
        publicKey: _checkoutData?.merchantPublicKey ?? '',
        partner: _selectedBankFlow!.slug,
        data: data,
      ),
    );
    _setBusy(false);
    response.fold(
      (l) => showToast(KCExceptionsToMessage.mapErrorToMessage(l)),
      (r) {
        _nextStepData = r;
        nextPage();
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
      'is_live': isLive,
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
    Logger().d(data);
    final response = await partnersUsecase(
      PartnersUsecaseParams(
        method: _nextStepData?.nextStep.method ?? '',
        api: _nextStepData?.nextStep.api ?? '',
        publicKey: _checkoutData?.merchantPublicKey ?? '',
        partner: _selectedBankFlow!.slug,
        data: data,
      ),
    );
    _setBusy(false);
    response.fold(
      (l) => showToast(KCExceptionsToMessage.mapErrorToMessage(l)),
      (r) {
        _nextStepData = r;
        nextPage();
      },
    );
  }

  Future<void> getRepaymentDetails({
    required String? installments,
    required int? repaymentDay,
    required PartnerInsurer? insurer,
  }) async {
    _setBusy(true);
    final data = <String, dynamic>{
      "amount": 150000, // _checkoutData?.amount ?? 0,
      'partner': _selectedBankFlow!.slug,
      'is_live': isLive,
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
        'insurer_id': insurer.value,
      });
    }
    final response = await partnersUsecase(
      PartnersUsecaseParams(
        method: _nextStepData?.nextStep.method ?? '',
        api:
            '/loans/account/repayments-detail', //_nextStepData?.nextStep.api ?? '',
        publicKey: _checkoutData?.merchantPublicKey ?? '',
        partner: _selectedBankFlow!.slug,
        data: data,
      ),
    );
    _setBusy(false);
    response.fold(
      (l) => showToast(KCExceptionsToMessage.mapErrorToMessage(l)),
      (r) {
        _nextStepData = r;
        _repaymentDetails = r.data;
        nextPage();
      },
    );
  }
}
