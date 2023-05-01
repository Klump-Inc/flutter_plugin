import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:klump_checkout/klump_checkout.dart';

class GetRepaymentDetailsUsecase
    extends KCUsecase<RepaymentDetails, GetRepaymentDetailsUsecaseParams> {
  GetRepaymentDetailsUsecase({
    required this.stanbicRepository,
  });

  final StanbicRepository stanbicRepository;

  @override
  Future<Either<KCException, RepaymentDetails>> call(
    GetRepaymentDetailsUsecaseParams params,
  ) =>
      stanbicRepository.getRepaymentDetails(
        amount: params.amount,
        publicKey: params.publicKey,
        installment: params.installment,
        repaymentDay: params.repaymentDay,
      );
}

class GetRepaymentDetailsUsecaseParams extends Equatable {
  const GetRepaymentDetailsUsecaseParams({
    required this.amount,
    required this.publicKey,
    required this.installment,
    required this.repaymentDay,
  });

  final double amount;
  final String publicKey;
  final int installment;
  final int repaymentDay;

  @override
  List<Object?> get props => [
        amount,
        publicKey,
        installment,
        repaymentDay,
      ];
}
