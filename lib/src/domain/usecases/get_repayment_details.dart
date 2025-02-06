import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:klump_checkout/klump_checkout.dart';

class GetRepaymentDetailsUsecase
    extends KCUsecase<KCAPIResponse, GetRepaymentDetailsUsecaseParams> {
  GetRepaymentDetailsUsecase({
    required this.partnerRepository,
  });

  final PartnerRepository partnerRepository;

  @override
  Future<Either<KCException, KCAPIResponse>> call(
    GetRepaymentDetailsUsecaseParams params,
  ) =>
      partnerRepository.getRepaymentDetails(
        amount: params.amount,
        publicKey: params.publicKey,
        installment: params.installment,
        repaymentDay: params.repaymentDay,
        insurerId: params.insurerId,
        partner: params.partner,
        isLive: params.isLive,
      );
}

class GetRepaymentDetailsUsecaseParams extends Equatable {
  const GetRepaymentDetailsUsecaseParams({
    required this.amount,
    required this.publicKey,
    required this.installment,
    required this.repaymentDay,
    required this.insurerId,
    required this.partner,
    required this.isLive,
  });

  final double amount;
  final String publicKey;
  final int installment;
  final int? repaymentDay;
  final int? insurerId;
  final String partner;
  final bool isLive;

  @override
  List<Object?> get props => [
        amount,
        publicKey,
        installment,
        repaymentDay,
        insurerId,
        partner,
        isLive,
      ];
}
