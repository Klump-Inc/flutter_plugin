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
      stanbicRepository.getBankTC(publicKey: params.publicKey);
}

class GetBankTCUsecaseParams extends Equatable {
  final String publicKey;

  const GetBankTCUsecaseParams({required this.publicKey});

  @override
  List<Object?> get props => [publicKey];
}
