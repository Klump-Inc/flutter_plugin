import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:klump_checkout/klump_checkout.dart';

class GetLoanPartnersUsecase
    extends KCUsecase<List<Partner>, GetLoanPartnersUsecaseParams> {
  GetLoanPartnersUsecase({
    required this.stanbicRepository,
  });

  final StanbicRepository stanbicRepository;

  @override
  Future<Either<KCException, List<Partner>>> call(
    GetLoanPartnersUsecaseParams params,
  ) =>
      stanbicRepository.getLoanPartners(publicKey: params.publicKey);
}

class GetLoanPartnersUsecaseParams extends Equatable {
  final String publicKey;

  const GetLoanPartnersUsecaseParams({
    required this.publicKey,
  });

  @override
  List<Object?> get props => [publicKey];
}
