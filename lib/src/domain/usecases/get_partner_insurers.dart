import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:klump_checkout/klump_checkout.dart';

class GetPartnerInsurersUsecase
    extends KCUsecase<List<PartnerInsurer>, GetPartnerInsurersUsecaseParams> {
  GetPartnerInsurersUsecase({
    required this.stanbicRepository,
  });

  final StanbicRepository stanbicRepository;

  @override
  Future<Either<KCException, List<PartnerInsurer>>> call(
    GetPartnerInsurersUsecaseParams params,
  ) =>
      stanbicRepository.getPartnerInsurers(
        partner: params.partner,
        publicKey: params.publicKey,
        amount: params.amount,
      );
}

class GetPartnerInsurersUsecaseParams extends Equatable {
  final String publicKey;
  final String partner;
  final double amount;

  const GetPartnerInsurersUsecaseParams({
    required this.publicKey,
    required this.partner,
    required this.amount,
  });

  @override
  List<Object?> get props => [publicKey, partner, amount];
}
