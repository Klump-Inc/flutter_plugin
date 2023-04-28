import 'package:dartz/dartz.dart';
import 'package:klump_checkout/klump_checkout.dart';
import 'package:klump_checkout/src/checkout.dart';

class StanbicRepository {
  late StanbicRemoteDatasource stanbicRmoteDatasource;
  StanbicRepository() {
    stanbicRmoteDatasource = StanbicRemoteDataSourceImpl(
      KCHttpRequester(),
      KCInternetInfo(),
    );
  }

  Future<Either<KCException, void>> initiate({
    required double amount,
    required String currency,
    required String publicKey,
    required Map<String, dynamic> metaData,
  }) async {
    try {
      final response = await stanbicRmoteDatasource.initiate(
        amount: amount,
        currency: currency,
        publicKey: publicKey,
        metaData: metaData,
      );
      return Right(response);
    } catch (e) {
      return Left(
        KCExceptionHandler.networkError(e),
      );
    }
  }

  Future<Either<KCException, void>> validateAccount({
    required String accountNumber,
    required String phoneNumber,
  }) async {
    try {
      final response = await stanbicRmoteDatasource.validateAccount(
        accountNumber: accountNumber,
        phoneNumber: phoneNumber,
      );
      return Right(response);
    } catch (e) {
      return Left(
        KCExceptionHandler.networkError(e),
      );
    }
  }

  Future<Either<KCException, double>> verifyOTP({
    required String accountNumber,
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      final response = await stanbicRmoteDatasource.verifyOTP(
        accountNumber: accountNumber,
        phoneNumber: phoneNumber,
        otp: otp,
      );
      return Right(response);
    } catch (e) {
      return Left(
        KCExceptionHandler.networkError(e),
      );
    }
  }

  Future<Either<KCException, TermsAndCondition>> getBankTC() async {
    try {
      final response = await stanbicRmoteDatasource.getBankTC();
      return Right(response);
    } catch (e) {
      return Left(
        KCExceptionHandler.networkError(e),
      );
    }
  }

  Future<Either<KCException, RepaymentDetails>> getRepaymentDetails({
    required double amount,
    required String publicKey,
    required int installment,
    required int repaymentDay,
  }) async {
    try {
      final response = await stanbicRmoteDatasource.getRepaymentDetails(
        amount: amount,
        publicKey: publicKey,
        installment: installment,
        repaymentDay: repaymentDay,
      );
      return Right(response);
    } catch (e) {
      return Left(
        KCExceptionHandler.networkError(e),
      );
    }
  }

  Future<Either<KCException, String>> createNew({
    required double amount,
    required String publicKey,
    required int installment,
    required int repaymentDay,
    required String termsVersion,
    required List<KlumpCheckoutItem> items,
  }) async {
    try {
      final response = await stanbicRmoteDatasource.createNew(
        amount: amount,
        publicKey: publicKey,
        installment: installment,
        repaymentDay: repaymentDay,
        termsVersion: termsVersion,
        items: items,
      );
      return Right(response);
    } catch (e) {
      return Left(
        KCExceptionHandler.networkError(e),
      );
    }
  }

  Future<Either<KCException, StanbicStatusResponse>> getLoanStatus(
      {required String id}) async {
    try {
      final response = await stanbicRmoteDatasource.getLoanStatus(id: id);
      return Right(response);
    } catch (e) {
      return Left(
        KCExceptionHandler.networkError(e),
      );
    }
  }
}
