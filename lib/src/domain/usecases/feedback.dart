import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:klump_checkout/klump_checkout.dart';

class FeedbackUsecase extends KCUsecase<dynamic, FeedbackUsecaseParams> {
  FeedbackUsecase({
    required this.partnerRepository,
  });

  final PartnerRepository partnerRepository;

  @override
  Future<Either<KCException, dynamic>> call(
    FeedbackUsecaseParams params,
  ) =>
      partnerRepository.feedback(
        phoneNumber: params.phoneNumber,
        email: params.email,
        publicKey: params.publicKey,
        feedback: params.feedback,
        isLive: params.isLive,
      );
}

class FeedbackUsecaseParams extends Equatable {
  final String publicKey;
  final bool isLive;
  final String email;
  final String phoneNumber;
  final String feedback;

  const FeedbackUsecaseParams({
    required this.publicKey,
    required this.isLive,
    required this.email,
    required this.phoneNumber,
    required this.feedback,
  });

  @override
  List<Object?> get props => [
        publicKey,
        isLive,
        email,
        phoneNumber,
        feedback,
      ];
}
