import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:klump_checkout/klump_checkout.dart';

class InitiateTransactionUsecase
    extends KCUsecase<void, InitiateTransactionUsecaseParams> {
  InitiateTransactionUsecase({
    required this.partnerRepository,
  });

  final PartnerRepository partnerRepository;

  @override
  Future<Either<KCException, void>> call(
    InitiateTransactionUsecaseParams params,
  ) =>
      partnerRepository.initiate(
        amount: params.amount,
        currency: params.currency,
        publicKey: params.publicKey,
        metaData: params.metaData,
        isLive: params.isLive,
      );
}

class InitiateTransactionUsecaseParams extends Equatable {
  const InitiateTransactionUsecaseParams({
    required this.amount,
    required this.currency,
    required this.publicKey,
    required this.metaData,
    required this.isLive,
  });

  final double amount;
  final String currency;
  final String publicKey;
  final Map<String, dynamic> metaData;
  final bool isLive;

  @override
  List<Object?> get props => [
        amount,
        currency,
        publicKey,
        metaData,
        isLive,
      ];
}
