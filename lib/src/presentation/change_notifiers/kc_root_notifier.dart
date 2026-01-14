import 'package:flutter/material.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:oktoast/oktoast.dart';

class KCRootNotifier extends ChangeNotifier {
  KCRootNotifier() {
    initiateTransactionUsecase =
        InitiateTransactionUsecase(partnerRepository: PartnerRepository());
  }
  late InitiateTransactionUsecase initiateTransactionUsecase;

  bool _isBusy = false;
  bool get isBusy => _isBusy;

  InitiateResponseModel? _initiateResponse;
  InitiateResponseModel? get initiateResponse => _initiateResponse;

  KlumpCheckoutData? _checkoutData;
  KlumpCheckoutData? get checkoutData => _checkoutData;

  void setTransactionData(KlumpCheckoutData data) {
    _checkoutData = data;
  }

  void _setBusy(bool value) {
    _isBusy = value;
    notifyListeners();
  }

  Future<bool> initiateTransaction({
    required String email,
    required String phone,
  }) async {
    _setBusy(true);
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
}
