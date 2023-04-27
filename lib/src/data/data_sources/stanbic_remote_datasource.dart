import 'package:klump_checkout/src/checkout.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class StanbicRemoteDatasource {
  Future<void> initiate({
    required double amount,
    required String currency,
    required String publicKey,
    required Map<String, dynamic> metaData,
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
  Future<String> getBankTC();
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
  }) async {
    if (await kcInternetInfo.isConnected) {
      final body = {
        "amount": amount,
        "currency": currency,
        "klump_public_key": publicKey,
        "meta_data": metaData,
      };
      Logger().d(body);
      final response = await kcHttpRequester.post(
        endpoint: '/v1/transactions/initiate',
        body: body,
      );
      Logger().d(response.data);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
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
      final body = {
        "accountNumber": accountNumber,
        "phoneNumber": phoneNumber,
      };
      Logger().d(body);
      final response = await kcHttpRequester.post(
        endpoint: '/v1/stanbic/accounts/validation',
        body: body,
      );
      Logger().d(response.data);
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
      final body = {
        "accountNumber": accountNumber,
        "phoneNumber": phoneNumber,
        "otp": otp,
        "email": "",
      };
      Logger().d(body);
      final response = await kcHttpRequester.post(
        endpoint: '/v1/stanbic/accounts/verify',
        body: body,
      );
      Logger().d(response.data);
      return response.data['loanLimit']['maxMonthlyRepayment'] ?? 0.0;
    } else {
      throw NoInternetKCException();
    }
  }

  @override
  Future<String> getBankTC() async {
    if (await kcInternetInfo.isConnected) {
      final response = await kcHttpRequester.get(
        endpoint: '/v1/stanbic/terms-and-conditions',
      );
      Logger().d(response.data);
      return response.data['termsAndConditions'];
    } else {
      throw NoInternetKCException();
    }
  }
}
