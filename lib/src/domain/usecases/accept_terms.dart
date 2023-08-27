import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:klump_checkout/klump_checkout.dart';

class AcceptTermsUsecase extends KCUsecase<bool, AcceptTermsUsecaseParams> {
  AcceptTermsUsecase({
    required this.stanbicRepository,
  });

  final StanbicRepository stanbicRepository;

  @override
  Future<Either<KCException, bool>> call(
    AcceptTermsUsecaseParams params,
  ) =>
      stanbicRepository.acceptTerms(
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
