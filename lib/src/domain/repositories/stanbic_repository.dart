import 'package:dartz/dartz.dart';
import 'package:klump_checkout/klump_checkout.dart';

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
    required bool isLive,
  }) async {
    try {
      final response = await stanbicRmoteDatasource.initiate(
        amount: amount,
        currency: currency,
        publicKey: publicKey,
        metaData: metaData,
        isLive: isLive,
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
    required String publicKey,
  }) async {
    try {
      final response = await stanbicRmoteDatasource.validateAccount(
        accountNumber: accountNumber,
        phoneNumber: phoneNumber,
        publicKey: publicKey,
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
    required String publicKey,
  }) async {
    try {
      final response = await stanbicRmoteDatasource.verifyOTP(
        accountNumber: accountNumber,
        phoneNumber: phoneNumber,
        otp: otp,
        publicKey: publicKey,
      );
      return Right(response);
    } catch (e) {
      return Left(
        KCExceptionHandler.networkError(e),
      );
    }
  }

  Future<Either<KCException, TermsAndCondition>> getBankTC(
      {required String publicKey}) async {
    try {
      final response =
          await stanbicRmoteDatasource.getBankTC(publicKey: publicKey);
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
    required Map<String, dynamic>? shippingData,
  }) async {
    try {
      final response = await stanbicRmoteDatasource.createNew(
        amount: amount,
        publicKey: publicKey,
        installment: installment,
        repaymentDay: repaymentDay,
        termsVersion: termsVersion,
        items: items,
        shippingData: shippingData,
      );
      return Right(response);
    } catch (e) {
      return Left(
        KCExceptionHandler.networkError(e),
      );
    }
  }

  Future<Either<KCException, StanbicStatusResponse>> getLoanStatus({
    required String id,
    required String publicKey,
  }) async {
    try {
      final response = await stanbicRmoteDatasource.getLoanStatus(
          id: id, publicKey: publicKey);
      return Right(response);
    } catch (e) {
      return Left(
        KCExceptionHandler.networkError(e),
      );
    }
  }
}
