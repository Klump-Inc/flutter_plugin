import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:klump_checkout/klump_checkout.dart';

class VerifyOTPUsecase
    extends KCUsecase<KCAPIResponse, VerifyOTPUsecaseParams> {
  VerifyOTPUsecase({
    required this.partnerRepository,
  });

  final PartnerRepository partnerRepository;

  @override
  Future<Either<KCException, KCAPIResponse>> call(
    VerifyOTPUsecaseParams params,
  ) =>
      partnerRepository.verifyOTP(
        accountNumber: params.accountNumber,
        phoneNumber: params.phoneNumber,
        email: params.email,
        otp: params.otp,
        password: params.password,
        publicKey: params.publicKey,
        partner: params.partner,
        firstName: params.firstName,
        bank: params.bank,
      );
}

class VerifyOTPUsecaseParams extends Equatable {
  const VerifyOTPUsecaseParams({
    required this.accountNumber,
    required this.phoneNumber,
    required this.email,
    required this.otp,
    required this.password,
    required this.publicKey,
    required this.partner,
    required this.firstName,
    required this.bank,
  });

  final String? accountNumber;
  final String? phoneNumber;
  final String? email;
  final String? otp;
  final String? password;
  final String publicKey;
  final String partner;
  final String? firstName;
  final String? bank;

  @override
  List<Object?> get props => [
        accountNumber,
        phoneNumber,
        email,
        otp,
        publicKey,
        partner,
        firstName,
        bank,
      ];
}
