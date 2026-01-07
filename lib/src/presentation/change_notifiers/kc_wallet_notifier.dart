import 'package:flutter/cupertino.dart';

class KCWalletNotifier extends ChangeNotifier {
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
}
