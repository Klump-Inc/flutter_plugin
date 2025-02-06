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
    required double? shippingFee,
    required String currency,
    required String publicKey,
    required Map<String, dynamic> metaData,
    required String email,
    required String phone,
    required List<KlumpCheckoutItem> items,
    required Map<String, dynamic>? shippingData,
    required String merchantReference,
  }) async {
    try {
      final response = await stanbicRmoteDatasource.initiate(
        amount: amount,
        shippingFee: shippingFee,
        currency: currency,
        publicKey: publicKey,
        metaData: metaData,
        email: email,
        phone: phone,
        items: items,
        shippingData: shippingData,
        merchantReference: merchantReference,
      );
      return Right(response);
    } catch (e) {
      return Left(
        KCExceptionHandler.networkError(e),
      );
    }
  }

  Future<Either<KCException, KCAPIResponse>> validateAccount({
    required String? accountNumber,
    required String? phoneNumber,
    String? firstName,
    required String publicKey,
    required String partner,
    required String? bank,
    required String? email,
    required bool isLive,
  }) async {
    try {
      final response = await stanbicRmoteDatasource.validateAccount(
        accountNumber: accountNumber,
        phoneNumber: phoneNumber,
        publicKey: publicKey,
        partner: partner,
        firstName: firstName,
        bank: bank,
        email: email,
        isLive: isLive,
      );
      return Right(response);
    } catch (e) {
      return Left(
        KCExceptionHandler.networkError(e),
      );
    }
  }

  Future<Either<KCException, KCAPIResponse>> verifyOTP({
    required String? accountNumber,
    required String? phoneNumber,
    required String? email,
    required String? otp,
    required String? password,
    required String publicKey,
    required String? firstName,
    required String partner,
    required String? bank,
    required bool isLive,
  }) async {
    try {
      final response = await stanbicRmoteDatasource.verifyOTP(
        accountNumber: accountNumber,
        phoneNumber: phoneNumber,
        email: email,
        otp: otp,
        password: password,
        publicKey: publicKey,
        firstName: firstName,
        partner: partner,
        bank: bank,
        isLive: isLive,
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
    required bool isLive,
  }) async {
    try {
      final response = await stanbicRmoteDatasource.getBankTC(
        publicKey: publicKey,
        partner: partner,
        isLive: isLive,
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
    required bool isLive,
  }) async {
    try {
      final response = await stanbicRmoteDatasource.getRepaymentDetails(
        amount: amount,
        publicKey: publicKey,
        installment: installment,
        repaymentDay: repaymentDay,
        insurerId: insurerId,
        partner: partner,
        isLive: isLive,
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
    required bool isLive,
  }) async {
    try {
      final response = await stanbicRmoteDatasource.getLoanStatus(
        url: url,
        publicKey: publicKey,
        isLive: isLive,
      );
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
    required bool isLive,
    DateTime? dob,
  }) async {
    try {
      final response = await stanbicRmoteDatasource.accountCredentials(
        email: email,
        password: password,
        publicKey: publicKey,
        partner: partner,
        isLive: isLive,
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
    required bool isLive,
  }) async {
    try {
      final response = await stanbicRmoteDatasource.getPartnerInsurers(
        partner: partner,
        publicKey: publicKey,
        amount: amount,
        isLive: isLive,
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
    required double amount,
  }) async {
    try {
      final response = await stanbicRmoteDatasource.getLoanPartners(
          publicKey: publicKey, amount: amount);
      return Right(response);
    } catch (e) {
      return Left(
        KCExceptionHandler.networkError(e),
      );
    }
  }

  Future<Either<KCException, KCAPIResponse>> partners({
    required String method,
    required String api,
    required String publicKey,
    required String partner,
    required Map<String, dynamic>? data,
  }) async {
    try {
      final response = await stanbicRmoteDatasource.partners(
        method: method,
        api: api,
        partner: partner,
        publicKey: publicKey,
        data: data,
      );
      return Right(response);
    } catch (e) {
      return Left(
        KCExceptionHandler.networkError(e),
      );
    }
  }
}
