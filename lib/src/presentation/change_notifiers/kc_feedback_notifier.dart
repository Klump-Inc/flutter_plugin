import 'package:flutter/cupertino.dart';
import 'package:klump_checkout/klump_checkout.dart';

class KCFeedbackNotifier extends ChangeNotifier {
  KCFeedbackNotifier() {
    feedbackUsecase = FeedbackUsecase(partnerRepository: PartnerRepository());
  }

  late FeedbackUsecase feedbackUsecase;

  bool _isBusy = false;
  bool get isBusy => _isBusy;

  void _setBusy(bool value) {
    _isBusy = value;
    notifyListeners();
  }

  Future<String?> submitFeedback({
    required String publicKey,
    required String feedback,
    required String email,
    required String phoneNumber,
    required bool isLive,
  }) async {
    _setBusy(true);
    final response = await feedbackUsecase(
      FeedbackUsecaseParams(
        publicKey: publicKey,
        isLive: isLive,
        email: email,
        phoneNumber: phoneNumber,
        feedback: feedback,
      ),
    );
    _setBusy(false);
    return response.fold(
      (l) => null,
      (r) => r?.toString(),
    );
  }
}
