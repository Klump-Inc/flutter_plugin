import 'package:flutter/material.dart';
import 'package:klump_checkout/src/domain/usecases/account_credentials.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:oktoast/oktoast.dart';

class KCChangeNotifier extends ChangeNotifier {
  KCChangeNotifier() {
    initiateTransactionUsecase =
        InitiateTransactionUsecase(stanbicRepository: StanbicRepository());
    accountValidationUsecase =
        AccountValidationUsecase(stanbicRepository: StanbicRepository());
    verifyOTPUsecase = VerifyOTPUsecase(stanbicRepository: StanbicRepository());
    getBankTCUsecase = GetBankTCUsecase(stanbicRepository: StanbicRepository());
    getRepaymentDetailsUsecase =
        GetRepaymentDetailsUsecase(stanbicRepository: StanbicRepository());
    createNewUsecase = CreateNewUsecase(stanbicRepository: StanbicRepository());
    getLoanStatusUsecase =
        GetLoanStatusUsecase(stanbicRepository: StanbicRepository());
    getPartnerInsurersUsecase =
        GetPartnerInsurersUsecase(stanbicRepository: StanbicRepository());
    accountCredentialsUsecase =
        AccountCredentialsUsecase(stanbicRepository: StanbicRepository());
    getLoanPartnersUsecase = GetLoanPartnersUsecase(
      stanbicRepository: StanbicRepository(),
    );
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

  bool _isBusy = false;
  bool get isBusy => _isBusy;
  var _currentPage = 0;
  int get currentPage => _currentPage;

  final Map<String, bool> _stanbicSteps = {
    'initiated': false,
    'account_validation': false,
    'verify_otp': false,
    'terms_and_condition': false,
  };

  KlumpCheckoutData? _checkoutData;

  String? _accountNumber;
  String? _phoneNumber;
  String? _firstName;
  String? get accountNumber => _accountNumber;
  String? get phoneNumber => _phoneNumber;
  String? get firstName => _firstName;
  TermsAndCondition? _stanbicTC;
  TermsAndCondition? get stanbicTC => _stanbicTC;
  KlumpUser? _stanbicUser;
  KlumpUser? get stanbicUser => _stanbicUser;
  RepaymentDetails? _repaymentDetails;
  RepaymentDetails? get repaymentDetails => _repaymentDetails;
  String? _newLoanId;
  StanbicStatusResponse? _stanbicStatusResponse;
  StanbicStatusResponse? get stanbicStatusResponse => _stanbicStatusResponse;
  List<PartnerInsurer>? _partnerInsurers;
  List<PartnerInsurer>? get partnerInsurers => _partnerInsurers;
  List<Partner>? _loanPartners;
  List<Partner>? get loanPartners => _loanPartners;

  void _updateStanbicSteps(String key) {
    _stanbicSteps.update(key, (value) => true);
  }

  final PageController _pageController = PageController();
  PageController get pageController => _pageController;

  void nextPage({bool skipPage = false}) {
    if (skipPage) {
      _currentPage = _currentPage + 2;
      _pageController.jumpToPage(_currentPage);
    } else {
      _currentPage++;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
    }
    notifyListeners();
  }

  void prevPage({bool skipPage = false}) {
    if (skipPage) {
      _currentPage = _currentPage - 2;
      _pageController.jumpToPage(_currentPage);
    } else {
      _currentPage--;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
    }

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

  void _setBusy(bool value) {
    _isBusy = value;
    notifyListeners();
  }

  void setBankFlow(Partner bank) {
    _selectedBankFlow = bank;
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

  void initiateTransaction(bool isLive, KlumpCheckoutData data) async {
    if (_stanbicSteps['initiated'] != true) {
      _checkoutData = data;
      _setBusy(true);
      initiateTransactionUsecase(
        InitiateTransactionUsecaseParams(
          amount: data.amount + (data.shippingFee ?? 0),
          currency: data.currency ?? 'NGN',
          publicKey: data.merchantPublicKey,
          metaData: data.metaData,
          isLive: isLive,
        ),
      ).then(
        (_) {
          _updateStanbicSteps('initiated');
          _setBusy(false);
        },
      );
    }
  }

  Future<void> getLoanPartners() async {
    if (_stanbicSteps['initiated'] != true) {
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
  }

  Future<void> validateAccount(String accountNumber, String phoneNumber,
      {String? firstName}) async {
    _setBusy(true);
    _accountNumber = accountNumber;
    _phoneNumber = phoneNumber;
    _firstName = firstName;
    final response = await accountValidationUsecase(
      AccountValidationUsecaseParams(
        accountNumber: accountNumber,
        phoneNumber: phoneNumber,
        publicKey: _checkoutData?.merchantPublicKey ?? '',
        partner: _selectedBankFlow!.slug,
        firstName: firstName,
      ),
    );
    _setBusy(false);
    response.fold(
      (l) => showToast(KCExceptionsToMessage.mapErrorToMessage(l)),
      (r) => nextPage(),
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

  Future<void> verifyOTP(String otp) async {
    _setBusy(true);
    final response = await verifyOTPUsecase(
      VerifyOTPUsecaseParams(
          accountNumber: _accountNumber ?? '',
          phoneNumber: _phoneNumber ?? '',
          otp: otp,
          publicKey: _checkoutData!.merchantPublicKey,
          partner: _selectedBankFlow!.slug,
          firstName: _firstName),
    );
    response.fold(
      (l) => showToast(KCExceptionsToMessage.mapErrorToMessage(l)),
      (r) {
        _stanbicUser = r;
        nextPage();
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
        _stanbicTC = r;
      },
    );
    _setBusy(false);
  }

  Future<void> getRepaymentDetails(int installment, int repaymentDay) async {
    _setBusy(true);
    final response =
        await getRepaymentDetailsUsecase(GetRepaymentDetailsUsecaseParams(
      amount: _checkoutData?.amount ?? 0,
      publicKey: _checkoutData?.merchantPublicKey ?? '',
      installment: installment,
      repaymentDay: repaymentDay,
      insurerId: _selectedPartnerInsurer?.value ?? 0,
    ));
    _setBusy(false);
    response.fold(
      (l) => showToast(KCExceptionsToMessage.mapErrorToMessage(l)),
      (r) {
        _repaymentDetails = r;
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
        installment: _repaymentDetails!.installment,
        repaymentDay: int.parse(_repaymentDetails!.repaymentDay.toString()),
        termsVersion: _stanbicTC!.version ?? '1',
        items: _checkoutData?.items ?? [],
        shippingData: _checkoutData?.shippingData,
        insurerId: _selectedPartnerInsurer!.value,
      ),
    );
    response.fold(
      (l) => showToast(KCExceptionsToMessage.mapErrorToMessage(l)),
      (r) {
        _newLoanId = r;
        nextPage();
      },
    );
    _setBusy(false);
  }

  Future<StanbicStatusResponse?> getLoanStatus() async {
    final response = await getLoanStatusUsecase(
      GetLoanStatusUsecaseParams(
        id: _newLoanId!,
        publicKey: _checkoutData?.merchantPublicKey ?? '',
      ),
    );
    return response.fold(
      (l) => null,
      (r) {
        _stanbicStatusResponse = r;
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

  Future<void> addAccountCredentials(String email, String password) async {
    _setBusy(true);
    final response = await accountCredentialsUsecase(
      AccountCredentialsUsecaseParams(
        publicKey: _checkoutData?.merchantPublicKey ?? '',
        email: email,
        password: password,
      ),
    );
    _setBusy(false);
    response.fold(
      (l) => showToast(KCExceptionsToMessage.mapErrorToMessage(l)),
      (r) => nextPage(),
    );
  }
}
