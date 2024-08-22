import 'package:flutter/material.dart';
import 'package:klump_checkout/src/domain/usecases/accept_terms.dart';
import 'package:klump_checkout/src/domain/usecases/account_credentials.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:logger/logger.dart';
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

  KCAPIResponse? _verifyOTPStepData;
  KCAPIResponse? get verifyOTPNextStepData => _verifyOTPStepData;

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
  int? _paymentDay;
  int? get paymentDay => _paymentDay;
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

  void setPaymentSplit(int split) {
    _paymentSplit = split;
    notifyListeners();
  }

  void setPaymentDay(int day) {
    _paymentDay = day;
    notifyListeners();
  }

  void setPartnerInsurer(PartnerInsurer insurer) {
    _selectedPartnerInsurer = insurer;
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

  Future<void> validateAccount(
    String accountNumber,
    String phoneNumber, {
    String? firstName,
    String? email,
  }) async {
    _setBusy(true);
    _accountNumber = accountNumber;
    _phoneNumber = phoneNumber;
    _firstName = firstName;
    _email = email;
    final response = await accountValidationUsecase(
      AccountValidationUsecaseParams(
        accountNumber: accountNumber,
        phoneNumber: phoneNumber,
        publicKey: _checkoutData?.merchantPublicKey ?? '',
        partner: _selectedBankFlow!.slug,
        firstName: firstName?.isNotEmpty == true ? firstName : null,
        bank: _selectedBank != null ? _selectedBank!['slug'] : null,
        email: email?.isNotEmpty == true ? email : null,
      ),
    );
    _setBusy(false);
    response.fold(
      (l) => showToast(KCExceptionsToMessage.mapErrorToMessage(l)),
      (r) {
        _verifyOTPStepData = r;
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
        accountNumber: _accountNumber ?? '',
        phoneNumber: _phoneNumber ?? '',
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

  Future<void> getRepaymentDetails(int installment, int? repaymentDay) async {
    _setBusy(true);
    final response = await getRepaymentDetailsUsecase(
      GetRepaymentDetailsUsecaseParams(
        amount: _checkoutData?.amount ?? 0,
        publicKey: _checkoutData?.merchantPublicKey ?? '',
        installment: installment,
        repaymentDay: repaymentDay,
        insurerId: _selectedPartnerInsurer?.value ?? 0,
        partner: _selectedBankFlow!.slug,
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
      ),
    );
    _setBusy(false);
    response.fold(
      (l) => showToast(KCExceptionsToMessage.mapErrorToMessage(l)),
      (r) {
        Logger().d(r);
        _nextStepData = r;
        nextPage();
      },
    );
  }
}
