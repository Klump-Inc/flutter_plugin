import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:klump_checkout/klump_checkout.dart';

class AccountValidationUsecase
    extends KCUsecase<KCAPIResponse, AccountValidationUsecaseParams> {
  AccountValidationUsecase({
    required this.partnerRepository,
  });

  final PartnerRepository partnerRepository;

  @override
  Future<Either<KCException, KCAPIResponse>> call(
    AccountValidationUsecaseParams params,
  ) =>
      partnerRepository.validateAccount(
        accountNumber: params.accountNumber,
        phoneNumber: params.phoneNumber,
        publicKey: params.publicKey,
        partner: params.partner,
        firstName: params.firstName,
        bank: params.bank,
        email: params.email,
      );
}

class AccountValidationUsecaseParams extends Equatable {
  const AccountValidationUsecaseParams({
    required this.accountNumber,
    required this.phoneNumber,
    required this.publicKey,
    required this.partner,
    this.firstName,
    this.bank,
    this.email,
  });

  final String accountNumber;
  final String phoneNumber;
  final String publicKey;
  final String partner;
  final String? firstName;
  final String? bank;
  final String? email;

  @override
  List<Object?> get props => [
        accountNumber,
        phoneNumber,
        publicKey,
        partner,
        firstName,
        bank,
        email,
      ];
}
