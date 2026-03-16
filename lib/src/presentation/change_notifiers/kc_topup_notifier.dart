import 'package:flutter/cupertino.dart';
import 'package:klump_checkout/klump_checkout.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:logger/logger.dart';

class KCTopupNotifier extends ChangeNotifier {
  KCTopupNotifier({
    required KCAPIResponse confirmWalletSteoData,
    required InitiateResponseModel initiateResponse,
    required String publicKey,
  })  : _confirmWalletSteoData = confirmWalletSteoData,
        _initiateResponse = initiateResponse,
        _publicKey = publicKey {
    _partnersUsecase = PartnersUsecase(partnerRepository: PartnerRepository());
  }

  late final PartnersUsecase _partnersUsecase;

  final InitiateResponseModel _initiateResponse;
  InitiateResponseModel get initiateResponse => _initiateResponse;

  final String _publicKey;

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

  KCAPIResponse? _confirmWalletSteoData;
  KCAPIResponse? get confirmWalletSteoData => _confirmWalletSteoData;

  void storeNextStepData(KCAPIResponse data) {
    final stepName = data.nextStep.name?.toUpperCase();
    Logger().d(stepName);
    switch (stepName) {
      case 'CONFIRM_WALLET_BALANCE':
        _confirmWalletSteoData = data;
        break;
      default:
    }
    notifyListeners();
  }

  Future<bool> confirmWallet() async {
    if (_isBusy) return false;
    setIsBusy(true);
    final data = <String, dynamic>{
      'klump_public_key': _publicKey,
      'is_live': _initiateResponse.isLive,
      'partner': 'refund_wallet',
    };
    Logger().d(data);
    final response = await _partnersUsecase(
      PartnersUsecaseParams(
        method: _confirmWalletSteoData?.nextStep.method ?? '',
        api: _confirmWalletSteoData?.nextStep.api ?? '',
        publicKey: _publicKey,
        partner: 'refund_wallet',
        data: data,
      ),
    );
    setIsBusy(false);
    return response.fold(
      (l) {
        Logger().e(KCExceptionsToMessage.mapErrorToMessage(l));
        return false;
      },
      (r) {
        storeNextStepData(r);
        return (r.data as Map<String, dynamic>)['has_sufficient_balance'] ==
            true;
      },
    );
  }
}
