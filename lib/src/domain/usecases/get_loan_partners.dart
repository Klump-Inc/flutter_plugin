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
      partnerRepository.getLoanPartners(
          publicKey: params.publicKey, amount: params.amount);
}

class GetLoanPartnersUsecaseParams extends Equatable {
  final String publicKey;
  final double amount;

  const GetLoanPartnersUsecaseParams({
    required this.publicKey,
    required this.amount,
  });

  @override
  List<Object?> get props => [publicKey, amount];
}
