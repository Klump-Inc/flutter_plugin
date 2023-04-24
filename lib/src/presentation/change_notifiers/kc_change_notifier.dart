import 'package:flutter/material.dart';
import 'package:klump_checkout/klump_checkout.dart';
import 'package:klump_checkout/src/src.dart';

class KCChangeNotifier extends ChangeNotifier {
  KCChangeNotifier() {
    initiateTransactionUsecase =
        InitiateTransactionUsecase(stanbicRepository: StanbicRepository());
  }
  late InitiateTransactionUsecase initiateTransactionUsecase;
  bool _isBusy = false;
  bool get isBusy => _isBusy;
  var _currentPage = 0;
  int get currentPage => _currentPage;

  final Map<String, bool> _stanbicSteps = {
    'initiated': false,
  };
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
}
