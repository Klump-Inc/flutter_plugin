import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:klump_checkout/klump_checkout.dart';

class AccountCredentialsUsecase
    extends KCUsecase<KCAPIResponse, AccountCredentialsUsecaseParams> {
  AccountCredentialsUsecase({
    required this.partnerRepository,
  });

  final PartnerRepository partnerRepository;

  @override
  Future<Either<KCException, KCAPIResponse>> call(
    AccountCredentialsUsecaseParams params,
  ) =>
      partnerRepository.accountCredentials(
        email: params.email,
        password: params.password,
        publicKey: params.publicKey,
        partner: params.partner,
        dob: params.dob,
      );
}

class AccountCredentialsUsecaseParams extends Equatable {
  const AccountCredentialsUsecaseParams({
    required this.email,
    required this.password,
    required this.publicKey,
    required this.partner,
    this.dob,
  });

  final String email;
  final String password;
  final String publicKey;
  final String partner;
  final DateTime? dob;

  @override
  List<Object?> get props => [
        email,
        password,
        publicKey,
        partner,
        dob,
      ];
}
