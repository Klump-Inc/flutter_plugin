import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:klump_checkout/klump_checkout.dart';

class GetPartnerInsurersUsecase
    extends KCUsecase<List<PartnerInsurer>, GetPartnerInsurersUsecaseParams> {
  GetPartnerInsurersUsecase({
    required this.partnerRepository,
  });

  final PartnerRepository partnerRepository;

  @override
  Future<Either<KCException, List<PartnerInsurer>>> call(
    GetPartnerInsurersUsecaseParams params,
  ) =>
      partnerRepository.getPartnerInsurers(
        partner: params.partner,
        publicKey: params.publicKey,
        amount: params.amount,
        isLive: params.isLive,
      );
}

class GetPartnerInsurersUsecaseParams extends Equatable {
  final String publicKey;
  final String partner;
  final double amount;
  final bool isLive;

  const GetPartnerInsurersUsecaseParams({
    required this.publicKey,
    required this.partner,
    required this.amount,
    required this.isLive,
  });

  @override
  List<Object?> get props => [
        publicKey,
        partner,
        amount,
        isLive,
      ];
}
