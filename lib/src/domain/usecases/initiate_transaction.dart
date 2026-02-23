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
        shippingFee: params.shippingFee,
        currency: params.currency,
        publicKey: params.publicKey,
        metaData: params.metaData,
        email: params.email,
        phone: params.phone,
        items: params.items,
        shippingData: params.shippingData,
        merchantReference: params.merchantReference,
        sourceAnalytics: params.sourceAnalytics,
      );
}

class InitiateTransactionUsecaseParams extends Equatable {
  const InitiateTransactionUsecaseParams({
    required this.amount,
    required this.shippingFee,
    required this.currency,
    required this.publicKey,
    required this.metaData,
    required this.email,
    required this.phone,
    required this.items,
    required this.shippingData,
    required this.merchantReference,
    required this.sourceAnalytics,
  });

  final double amount;
  final double? shippingFee;
  final String currency;
  final String publicKey;
  final Map<String, dynamic> metaData;
  final String email;
  final String phone;
  final List<KlumpCheckoutItem> items;
  final Map<String, dynamic>? shippingData;
  final String? merchantReference;
  final Map<String, dynamic> sourceAnalytics;

  @override
  List<Object?> get props => [
        amount,
        currency,
        publicKey,
        metaData,
        items,
        shippingData,
        merchantReference,
        sourceAnalytics,
      ];
}
