import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:klump_checkout/klump_checkout.dart';

class AcceptTermsUsecase
    extends KCUsecase<KCAPIResponse, AcceptTermsUsecaseParams> {
  AcceptTermsUsecase({
    required this.partnerRepository,
  });

  final PartnerRepository partnerRepository;

  @override
  Future<Either<KCException, KCAPIResponse>> call(
    AcceptTermsUsecaseParams params,
  ) =>
      partnerRepository.acceptTerms(
        partner: params.partner,
        publicKey: params.publicKey,
      );
}

class AcceptTermsUsecaseParams extends Equatable {
  final String publicKey;
  final String partner;

  const AcceptTermsUsecaseParams({
    required this.publicKey,
    required this.partner,
  });

  @override
  List<Object?> get props => [publicKey, partner];
}
