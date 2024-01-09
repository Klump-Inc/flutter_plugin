import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:klump_checkout/klump_checkout.dart';

class GetLoanPartnersUsecase
    extends KCUsecase<List<Partner>, GetLoanPartnersUsecaseParams> {
  GetLoanPartnersUsecase({
    required this.partnerRepository,
  });

  final PartnerRepository partnerRepository;

  @override
  Future<Either<KCException, List<Partner>>> call(
    GetLoanPartnersUsecaseParams params,
  ) =>
      partnerRepository.getLoanPartners(publicKey: params.publicKey);
}

class GetLoanPartnersUsecaseParams extends Equatable {
  final String publicKey;

  const GetLoanPartnersUsecaseParams({
    required this.publicKey,
  });

  @override
  List<Object?> get props => [publicKey];
}
