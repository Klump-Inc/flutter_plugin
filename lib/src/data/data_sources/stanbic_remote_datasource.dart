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
}
