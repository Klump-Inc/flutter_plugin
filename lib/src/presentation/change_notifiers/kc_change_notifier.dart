import 'package:flutter/material.dart';
import 'package:klump_checkout/klump_checkout.dart';
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
  }
  late InitiateTransactionUsecase initiateTransactionUsecase;
  late AccountValidationUsecase accountValidationUsecase;
  late VerifyOTPUsecase verifyOTPUsecase;
  late GetBankTCUsecase getBankTCUsecase;

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

  String? _accountNumber;
  String? _phoneNumber;
  String? get accountNumber => _accountNumber;
  String? get phoneNumber => _phoneNumber;
  String? _stanbicTermsHTML;
  String? get stanbicTermsHTML => _stanbicTermsHTML;
  double? _eligibilityAmount;
  double? get eligibilityAmount => _eligibilityAmount;

  void _updateStanbicSteps(String key) {
    _stanbicSteps.update(key, (value) => true);
  }

  final PageController _pageController = PageController();
  PageController get pageController => _pageController;

  void nextPage() {
    _currentPage++;
    _pageController.animateToPage(
      _currentPage,
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
    );
    notifyListeners();
  }

  void prevPage() {
    _currentPage--;
    _pageController.animateToPage(
      _currentPage,
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
    );
    notifyListeners();
  }

  KCBankEntity? _selectedBankFlow;
  KCBankEntity? get selectedBankFlow => _selectedBankFlow;

  void _setBusy(bool value) {
    _isBusy = value;
    notifyListeners();
  }

  void setBankFlow(KCBankEntity bank) {
    _selectedBankFlow = bank;
    notifyListeners();
  }

  void initiateTransaction(KlumpCheckoutData data) async {
    if (_stanbicSteps['initiated'] != true) {
      _setBusy(true);
      initiateTransactionUsecase(
        InitiateTransactionUsecaseParams(
          amount: data.amount + (data.shippingFee ?? 0),
          currency: data.currency ?? 'NGN',
          publicKey: data.merchantPublicKey,
          metaData: data.metaData,
        ),
      ).then(
        (_) {
          _updateStanbicSteps('initiated');
          _setBusy(false);
        },
      );
    }
  }

  Future<void> validateAccount(String accountNumber, String phoneNumber) async {
    _setBusy(true);
    _accountNumber = accountNumber;
    _phoneNumber = phoneNumber;
    final response = await accountValidationUsecase(
      AccountValidationUsecaseParams(
        accountNumber: accountNumber,
        phoneNumber: phoneNumber,
      ),
    );
    _setBusy(false);
    response.fold(
      (l) => showToast(KCExceptionsToMessage.mapErrorToMessage(l)),
      (r) => nextPage(),
    );
  }

  Future<void> verifyOTP(String otp) async {
    _setBusy(true);
    final response = await verifyOTPUsecase(
      VerifyOTPUsecaseParams(
        accountNumber: _accountNumber ?? '',
        phoneNumber: _phoneNumber ?? '',
        otp: otp,
      ),
    );
    response.fold(
      (l) => showToast(KCExceptionsToMessage.mapErrorToMessage(l)),
      (r) {
        _eligibilityAmount = r;
        nextPage();
      },
    );
    _setBusy(false);
  }

  Future<void> fetchBankTC() async {
    _setBusy(true);
    final response = await getBankTCUsecase(
      NoParams(),
    );
    response.fold(
      (l) => {},
      (r) {
        _stanbicTermsHTML = r;
      },
    );
    _setBusy(false);
  }
}
