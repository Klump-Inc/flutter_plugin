import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:klump_checkout/klump_checkout.dart';
import 'package:klump_checkout/src/checkout.dart';

class CreateNewUsecase extends KCUsecase<String, CreateNewUsecaseParams> {
  CreateNewUsecase({
    required this.stanbicRepository,
  });

  final StanbicRepository stanbicRepository;

  @override
  Future<Either<KCException, String>> call(
    CreateNewUsecaseParams params,
  ) =>
      stanbicRepository.createNew(
        amount: params.amount,
        publicKey: params.publicKey,
        installment: params.installment,
        repaymentDay: params.repaymentDay,
        termsVersion: params.termsVersion,
        items: params.items,
      );
}

class CreateNewUsecaseParams extends Equatable {
  const CreateNewUsecaseParams({
    required this.amount,
    required this.publicKey,
    required this.installment,
    required this.repaymentDay,
    required this.termsVersion,
    required this.items,
  });

  final double amount;
  final String publicKey;
  final int installment;
  final int repaymentDay;
  final String termsVersion;
  final List<KlumpCheckoutItem> items;

  @override
  List<Object?> get props => [
        amount,
        publicKey,
        installment,
        repaymentDay,
        termsVersion,
        items,
      ];
}
