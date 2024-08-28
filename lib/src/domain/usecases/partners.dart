import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:klump_checkout/klump_checkout.dart';

class PartnersUsecase extends KCUsecase<KCAPIResponse, PartnersUsecaseParams> {
  PartnersUsecase({
    required this.partnerRepository,
  });

  final PartnerRepository partnerRepository;

  @override
  Future<Either<KCException, KCAPIResponse>> call(
    PartnersUsecaseParams params,
  ) =>
      partnerRepository.partners(
        method: params.method,
        api: params.api,
        publicKey: params.publicKey,
        partner: params.partner,
        data: params.data,
      );
}

class PartnersUsecaseParams extends Equatable {
  final String method;
  final String api;
  final String publicKey;
  final String partner;
  final Map<String, dynamic>? data;

  const PartnersUsecaseParams({
    required this.method,
    required this.api,
    required this.publicKey,
    required this.partner,
    required this.data,
  });

  @override
  List<Object?> get props => [method, api, publicKey, partner, data];
}
