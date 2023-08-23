import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:klump_checkout/klump_checkout.dart';

class GetBankTCUsecase
    extends KCUsecase<TermsAndCondition, GetBankTCUsecaseParams> {
  GetBankTCUsecase({
    required this.stanbicRepository,
  });

  final StanbicRepository stanbicRepository;

  @override
  Future<Either<KCException, TermsAndCondition>> call(
    GetBankTCUsecaseParams params,
  ) =>
      stanbicRepository.getBankTC(
        publicKey: params.publicKey,
        partner: params.partner,
      );
}

class GetBankTCUsecaseParams extends Equatable {
  final String publicKey;
  final String partner;

  const GetBankTCUsecaseParams({
    required this.publicKey,
    required this.partner,
  });

  @override
  List<Object?> get props => [publicKey, partner];
}
