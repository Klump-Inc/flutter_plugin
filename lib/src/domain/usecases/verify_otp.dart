import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:klump_checkout/klump_checkout.dart';

class VerifyOTPUsecase extends KCUsecase<double, VerifyOTPUsecaseParams> {
  VerifyOTPUsecase({
    required this.stanbicRepository,
  });

  final StanbicRepository stanbicRepository;

  @override
  Future<Either<KCException, double>> call(
    VerifyOTPUsecaseParams params,
  ) =>
      stanbicRepository.verifyOTP(
        accountNumber: params.accountNumber,
        phoneNumber: params.phoneNumber,
        otp: params.otp,
      );
}

class VerifyOTPUsecaseParams extends Equatable {
  const VerifyOTPUsecaseParams({
    required this.accountNumber,
    required this.phoneNumber,
    required this.otp,
  });

  final String accountNumber;
  final String phoneNumber;
  final String otp;

  @override
  List<Object?> get props => [
        accountNumber,
        phoneNumber,
        otp,
      ];
}
