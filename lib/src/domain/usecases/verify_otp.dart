import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:klump_checkout/klump_checkout.dart';

class VerifyOTPUsecase extends KCUsecase<KlumpUser, VerifyOTPUsecaseParams> {
  VerifyOTPUsecase({
    required this.stanbicRepository,
  });

  final StanbicRepository stanbicRepository;

  @override
  Future<Either<KCException, KlumpUser>> call(
    VerifyOTPUsecaseParams params,
  ) =>
      stanbicRepository.verifyOTP(
        accountNumber: params.accountNumber,
        phoneNumber: params.phoneNumber,
        otp: params.otp,
        publicKey: params.publicKey,
        partner: params.partner,
        firstName: params.firstName,
      );
}

class VerifyOTPUsecaseParams extends Equatable {
  const VerifyOTPUsecaseParams({
    required this.accountNumber,
    required this.phoneNumber,
    required this.otp,
    required this.publicKey,
    required this.partner,
    this.firstName,
  });

  final String accountNumber;
  final String phoneNumber;
  final String otp;
  final String publicKey;
  final String partner;
  final String? firstName;

  @override
  List<Object?> get props => [
        accountNumber,
        phoneNumber,
        otp,
        publicKey,
        partner,
        firstName,
      ];
}
