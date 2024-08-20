import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:klump_checkout/klump_checkout.dart';

class InitiateTransactionUsecase
    extends KCUsecase<InitiateResponseModel, InitiateTransactionUsecaseParams> {
  InitiateTransactionUsecase({
    required this.partnerRepository,
  });

  final PartnerRepository partnerRepository;

  @override
  Future<Either<KCException, InitiateResponseModel>> call(
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
        items: params.items,
        shippingData: params.shippingData,
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
    required this.items,
    required this.shippingData,
  });

  final double amount;
  final String currency;
  final String publicKey;
  final Map<String, dynamic> metaData;
  final bool isLive;
  final String email;
  final String phone;
  final List<KlumpCheckoutItem> items;
  final Map<String, dynamic>? shippingData;

  @override
  List<Object?> get props => [
        amount,
        currency,
        publicKey,
        metaData,
        isLive,
        items,
        shippingData,
      ];
}
