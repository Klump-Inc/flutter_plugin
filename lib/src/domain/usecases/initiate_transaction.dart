import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:klump_checkout/klump_checkout.dart';

class InitiateTransactionUsecase
    extends KCUsecase<bool, InitiateTransactionUsecaseParams> {
  InitiateTransactionUsecase({
    required this.partnerRepository,
  });

  final PartnerRepository partnerRepository;

  @override
  Future<Either<KCException, bool>> call(
    InitiateTransactionUsecaseParams params,
  ) =>
      partnerRepository.initiate(
        amount: params.amount,
        currency: params.currency,
        publicKey: params.publicKey,
        metaData: params.metaData,
        isLive: params.isLive,
        email: params.email,
        phone: params.phone,
      );
}

class InitiateTransactionUsecaseParams extends Equatable {
  const InitiateTransactionUsecaseParams({
    required this.amount,
    required this.currency,
    required this.publicKey,
    required this.metaData,
    required this.isLive,
    required this.email,
    required this.phone,
  });

  final double amount;
  final String currency;
  final String publicKey;
  final Map<String, dynamic> metaData;
  final bool isLive;
  final String email;
  final String phone;

  @override
  List<Object?> get props => [
        amount,
        currency,
        publicKey,
        metaData,
        isLive,
      ];
}
