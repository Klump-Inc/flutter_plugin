import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:klump_checkout/klump_checkout.dart';

class AccountValidationUsecase
    extends KCUsecase<void, AccountValidationUsecaseParams> {
  AccountValidationUsecase({
    required this.stanbicRepository,
  });

  final StanbicRepository stanbicRepository;

  @override
  Future<Either<KCException, void>> call(
    AccountValidationUsecaseParams params,
  ) =>
      stanbicRepository.validateAccount(
        accountNumber: params.accountNumber,
        phoneNumber: params.phoneNumber,
        publicKey: params.publicKey,
      );
}

class AccountValidationUsecaseParams extends Equatable {
  const AccountValidationUsecaseParams({
    required this.accountNumber,
    required this.phoneNumber,
    required this.publicKey,
  });

  final String accountNumber;
  final String phoneNumber;
  final String publicKey;

  @override
  List<Object?> get props => [
        accountNumber,
        phoneNumber,
        publicKey,
      ];
}
