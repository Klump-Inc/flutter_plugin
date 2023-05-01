import 'package:klump_checkout/klump_checkout.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class StanbicRemoteDatasource {
  Future<void> initiate({
    required double amount,
    required String currency,
    required String publicKey,
    required Map<String, dynamic> metaData,
    required bool isLive,
  });
  Future<void> validateAccount({
    required String accountNumber,
    required String phoneNumber,
  });
  Future<double> verifyOTP({
    required String accountNumber,
    required String phoneNumber,
    required String otp,
  });
  Future<TermsAndConditionModel> getBankTC();
  Future<RepaymentDetailsModel> getRepaymentDetails({
    required double amount,
    required String publicKey,
    required int installment,
    required int repaymentDay,
  });
  Future<String> createNew({
    required double amount,
    required String publicKey,
    required int installment,
    required int repaymentDay,
    required String termsVersion,
    required List<KlumpCheckoutItem> items,
  });
  Future<StanbicStatusResponseModel> getLoanStatus({required String id});
}

class StanbicRemoteDataSourceImpl implements StanbicRemoteDatasource {
  final KCHttpRequester kcHttpRequester;
  final KCInternetInfo kcInternetInfo;

  StanbicRemoteDataSourceImpl(
    this.kcHttpRequester,
    this.kcInternetInfo,
  );

  @override
  Future<void> initiate({
    required double amount,
    required String currency,
    required String publicKey,
    required Map<String, dynamic> metaData,
    required bool isLive,
  }) async {
    if (await kcInternetInfo.isConnected) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        KC_ENVIRONMENT_KEY,
        isLive ? KC_PRODUCTION_ENVIRONMENT : KC_STAGING_ENVIRONMENT,
      );
      final body = {
        "amount": amount,
        "currency": currency,
        "klump_public_key": publicKey,
        "meta_data": metaData,
      };
      final response = await kcHttpRequester.post(
        environment: prefs.getString(KC_ENVIRONMENT_KEY),
        endpoint: '/v1/transactions/initiate',
        body: body,
      );
      await prefs.setString(KC_CKECKOUT_TOKEN,
          (response.data as Map<String, dynamic>)['token'] as String);
    } else {
      throw NoInternetKCException();
    }
  }

  @override
  Future<void> validateAccount({
    required String accountNumber,
    required String phoneNumber,
  }) async {
    if (await kcInternetInfo.isConnected) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final body = {
        "accountNumber": accountNumber,
        "phoneNumber": phoneNumber,
      };
      await kcHttpRequester.post(
        environment: prefs.getString(KC_ENVIRONMENT_KEY),
        endpoint: '/v1/stanbic/accounts/validation',
        body: body,
      );
    } else {
      throw NoInternetKCException();
    }
  }

  @override
  Future<double> verifyOTP({
    required String accountNumber,
    required String phoneNumber,
    required String otp,
  }) async {
    if (await kcInternetInfo.isConnected) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final body = {
        "accountNumber": accountNumber,
        "phoneNumber": phoneNumber,
        "otp": otp,
        "email": "",
      };
      final response = await kcHttpRequester.post(
        environment: prefs.getString(KC_ENVIRONMENT_KEY),
        endpoint: '/v1/stanbic/accounts/verify',
        body: body,
      );
      await prefs.setString(KC_STANBIC_TOKEN,
          (response.data as Map<String, dynamic>)['token'] as String);
      return response.data['loanLimit']['maxMonthlyRepayment'] ?? 0.0;
    } else {
      throw NoInternetKCException();
    }
  }

  @override
  Future<TermsAndConditionModel> getBankTC() async {
    if (await kcInternetInfo.isConnected) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await kcHttpRequester.get(
        environment: prefs.getString(KC_ENVIRONMENT_KEY),
        endpoint: '/v1/stanbic/terms-and-conditions',
      );
      return TermsAndConditionModel.fromJson(response.data);
    } else {
      throw NoInternetKCException();
    }
  }

  @override
  Future<RepaymentDetailsModel> getRepaymentDetails({
    required double amount,
    required String publicKey,
    required int installment,
    required int repaymentDay,
  }) async {
    if (await kcInternetInfo.isConnected) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final headers = {
        'klump-public-key': publicKey,
      };
      final body = {
        "amount": amount,
        "installment": installment,
        "repaymentDay": repaymentDay,
        "klump_public_key": publicKey,
      };
      final response = await kcHttpRequester.post(
        environment: prefs.getString(KC_ENVIRONMENT_KEY),
        endpoint: '/v1/stanbic/loans/repayment-details',
        body: body,
        token: prefs.getString(KC_STANBIC_TOKEN),
        headers: headers,
      );
      return RepaymentDetailsModel.fromJson(response.data['data']);
    } else {
      throw NoInternetKCException();
    }
  }

  @override
  Future<String> createNew({
    required double amount,
    required String publicKey,
    required int installment,
    required int repaymentDay,
    required String termsVersion,
    required List<KlumpCheckoutItem> items,
  }) async {
    if (await kcInternetInfo.isConnected) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final body = {
        "amount": amount,
        "installment": installment,
        "repaymentDay": repaymentDay,
        "klump_public_key": publicKey,
        "termsAndConditionVersion": termsVersion,
        "items": items.map((e) => e.toMap()).toList(),
      };
      final response = await kcHttpRequester.post(
        environment: prefs.getString(KC_ENVIRONMENT_KEY),
        endpoint: '/v1/stanbic/loans/new',
        body: body,
        token: prefs.getString(KC_STANBIC_TOKEN),
      );
      return response.data['id'];
    } else {
      throw NoInternetKCException();
    }
  }

  @override
  Future<StanbicStatusResponseModel> getLoanStatus({required String id}) async {
    if (await kcInternetInfo.isConnected) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await kcHttpRequester.get(
        environment: prefs.getString(KC_ENVIRONMENT_KEY),
        endpoint: '/v1/stanbic/loans/$id/status',
        token: prefs.getString(KC_STANBIC_TOKEN),
      );
      return StanbicStatusResponseModel.fromJson(response.data);
    } else {
      throw NoInternetKCException();
    }
  }
}