import 'package:flutter/cupertino.dart';
import 'package:klump_checkout/src/domain/entities/kc_api_response.dart';
import 'package:logger/logger.dart';

class KCTopupNotifier extends ChangeNotifier {
  final PageController _pageController = PageController();
  PageController get pageController => _pageController;

  var _currentPage = 0;
  int get currentPage => _currentPage;

  bool _isBusy = false;
  bool get isBusy => _isBusy;

  void setIsBusy(bool value) {
    _isBusy = value;
    notifyListeners();
  }

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

  KCAPIResponse? _balanceTopupStepData;
  KCAPIResponse? get balanceTopupStepData => _balanceTopupStepData;

  void storeNextStepData(KCAPIResponse data) {
    final stepName = data.nextStep.name?.toUpperCase();
    Logger().d(stepName);
    switch (stepName) {
      case 'BALANCE_PAGE_WITH_TOPUP':
        _balanceTopupStepData = data;
        break;
      default:
    }
  }
}
