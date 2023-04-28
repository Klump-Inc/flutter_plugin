import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:klump_checkout/klump_checkout.dart';

class InitiateTransactionUsecase
    extends KCUsecase<void, InitiateTransactionUsecaseParams> {
  InitiateTransactionUsecase({
    required this.stanbicRepository,
  });

  final StanbicRepository stanbicRepository;

  @override
  Future<Either<KCException, void>> call(
    InitiateTransactionUsecaseParams params,
  ) =>
      stanbicRepository.initiate(
        amount: params.amount,
        currency: params.currency,
        publicKey: params.publicKey,
        metaData: params.metaData,
      );
}

class InitiateTransactionUsecaseParams extends Equatable {
  const InitiateTransactionUsecaseParams({
    required this.amount,
    required this.currency,
    required this.publicKey,
    required this.metaData,
  });

  final double amount;
  final String currency;
  final String publicKey;
  final Map<String, dynamic> metaData;

  @override
  List<Object?> get props => [
        amount,
        currency,
        publicKey,
        metaData,
      ];
}
