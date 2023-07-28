import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:klump_checkout/klump_checkout.dart';

class AccountCredentialsUsecase
    extends KCUsecase<bool, AccountCredentialsUsecaseParams> {
  AccountCredentialsUsecase({
    required this.stanbicRepository,
  });

  final StanbicRepository stanbicRepository;

  @override
  Future<Either<KCException, bool>> call(
    AccountCredentialsUsecaseParams params,
  ) =>
      stanbicRepository.accountCredentials(
        email: params.email,
        password: params.password,
        publicKey: params.publicKey,
      );
}

class AccountCredentialsUsecaseParams extends Equatable {
  const AccountCredentialsUsecaseParams({
    required this.email,
    required this.password,
    required this.publicKey,
  });

  final String email;
  final String password;
  final String publicKey;

  @override
  List<Object?> get props => [
        email,
        password,
        publicKey,
      ];
}
