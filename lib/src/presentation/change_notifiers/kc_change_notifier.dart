import 'package:flutter/material.dart';
import 'package:klump_checkout/src/src.dart';

class KCChangeNotifier extends ChangeNotifier {
  var _currentPage = 0;
  int get currentPage => _currentPage;

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

  void setBankFlow(KCBankEntity bank) {
    _selectedBankFlow = bank;
    notifyListeners();
  }
}
