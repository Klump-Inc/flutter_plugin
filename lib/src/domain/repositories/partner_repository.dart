import 'package:dartz/dartz.dart';
import 'package:klump_checkout/klump_checkout.dart';

class PartnerRepository {
  late RemoteDatasource stanbicRmoteDatasource;
  PartnerRepository() {
    stanbicRmoteDatasource = RemoteDataSourceImpl(
      KCHttpRequester(),
      KCInternetInfo(),
    );
  }

  Future<Either<KCException, InitiateResponseModel>> initiate({
    required double amount,
    required String currency,
    required String publicKey,
    required Map<String, dynamic> metaData,
    required bool isLive,
    required String email,
    required String phone,
    required List<KlumpCheckoutItem> items,
    required Map<String, dynamic>? shippingData,
  }) async {
    try {
      final response = await stanbicRmoteDatasource.initiate(
        amount: amount,
        currency: currency,
        publicKey: publicKey,
        metaData: metaData,
        isLive: isLive,
        email: email,
        phone: phone,
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

  Future<Either<KCException, KCAPIResponse>> validateAccount({
    required String accountNumber,
    required String phoneNumber,
    String? firstName,
    required String publicKey,
    required String partner,
    required String? bank,
  }) async {
    try {
      final response = await stanbicRmoteDatasource.validateAccount(
        accountNumber: accountNumber,
        phoneNumber: phoneNumber,
        publicKey: publicKey,
        partner: partner,
        firstName: firstName,
        bank: bank,
      );
      return Right(response);
    } catch (e) {
      return Left(
        KCExceptionHandler.networkError(e),
      );
    }
  }

  Future<Either<KCException, KCAPIResponse>> verifyOTP({
    required String accountNumber,
    required String phoneNumber,
    required String? otp,
    required String? password,
    required String publicKey,
    String? firstName,
    required String partner,
    required String? bank,
  }) async {
    try {
      final response = await stanbicRmoteDatasource.verifyOTP(
        accountNumber: accountNumber,
        phoneNumber: phoneNumber,
        otp: otp,
        password: password,
        publicKey: publicKey,
        firstName: firstName,
        partner: partner,
        bank: bank,
      );
      return Right(response);
    } catch (e) {
      return Left(
        KCExceptionHandler.networkError(e),
      );
    }
  }

  Future<Either<KCException, KCAPIResponse>> getBankTC({
    required String publicKey,
    required String partner,
  }) async {
    try {
      final response = await stanbicRmoteDatasource.getBankTC(
        publicKey: publicKey,
        partner: partner,
      );
      return Right(response);
    } catch (e) {
      return Left(
        KCExceptionHandler.networkError(e),
      );
    }
  }

  Future<Either<KCException, KCAPIResponse>> getRepaymentDetails({
    required double amount,
    required String publicKey,
    required int installment,
    required int? repaymentDay,
    required int? insurerId,
    required String partner,
  }) async {
    try {
      final response = await stanbicRmoteDatasource.getRepaymentDetails(
        amount: amount,
        publicKey: publicKey,
        installment: installment,
        repaymentDay: repaymentDay,
        insurerId: insurerId,
        partner: partner,
      );
      return Right(response);
    } catch (e) {
      return Left(
        KCExceptionHandler.networkError(e),
      );
    }
  }

  Future<Either<KCException, KCAPIResponse>> createNew({
    required double amount,
    required String publicKey,
    required int? installment,
    required int? repaymentDay,
    required String? termsVersion,
    required List<KlumpCheckoutItem> items,
    required Map<String, dynamic>? shippingData,
    required int? insurerId,
    required String partner,
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
        insurerId: insurerId,
        partner: partner,
      );
      return Right(response);
    } catch (e) {
      return Left(
        KCExceptionHandler.networkError(e),
      );
    }
  }

  Future<Either<KCException, DisbursementStatusResponse>> getLoanStatus({
    required String url,
    required String publicKey,
  }) async {
    try {
      final response = await stanbicRmoteDatasource.getLoanStatus(
          url: url, publicKey: publicKey);
      return Right(response);
    } catch (e) {
      return Left(
        KCExceptionHandler.networkError(e),
      );
    }
  }

  Future<Either<KCException, KCAPIResponse>> accountCredentials({
    required String email,
    required String password,
    required String publicKey,
    required String partner,
    DateTime? dob,
  }) async {
    try {
      final response = await stanbicRmoteDatasource.accountCredentials(
        email: email,
        password: password,
        publicKey: publicKey,
        partner: partner,
        dob: dob,
      );
      return Right(response);
    } catch (e) {
      return Left(
        KCExceptionHandler.networkError(e),
      );
    }
  }

  Future<Either<KCException, List<PartnerInsurer>>> getPartnerInsurers({
    required String partner,
    required String publicKey,
    required double amount,
  }) async {
    try {
      final response = await stanbicRmoteDatasource.getPartnerInsurers(
        partner: partner,
        publicKey: publicKey,
        amount: amount,
      );
      return Right(response);
    } catch (e) {
      return Left(
        KCExceptionHandler.networkError(e),
      );
    }
  }

  Future<Either<KCException, List<Partner>>> getLoanPartners({
    required String publicKey,
  }) async {
    try {
      final response =
          await stanbicRmoteDatasource.getLoanPartners(publicKey: publicKey);
      return Right(response);
    } catch (e) {
      return Left(
        KCExceptionHandler.networkError(e),
      );
    }
  }

  Future<Either<KCException, KCAPIResponse>> acceptTerms({
    required String partner,
    required String publicKey,
  }) async {
    try {
      final response = await stanbicRmoteDatasource.acceptTerms(
        partner: partner,
        publicKey: publicKey,
      );
      return Right(response);
    } catch (e) {
      return Left(
        KCExceptionHandler.networkError(e),
      );
    }
  }
}
