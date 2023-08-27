import 'package:klump_checkout/klump_checkout.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class RemoteDatasource {
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
    String? firstName,
    required String publicKey,
    required String partner,
  });
  Future<bool> accountCredentials({
    required String email,
    required String password,
    required String publicKey,
  });
  Future<KlumpUserModel> verifyOTP({
    required String accountNumber,
    required String phoneNumber,
    required String otp,
    required String publicKey,
    String? firstName,
    required String partner,
  });
  Future<TermsAndConditionModel> getBankTC({
    required String publicKey,
    required String partner,
  });
  Future<RepaymentDetailsModel> getRepaymentDetails({
    required double amount,
    required String publicKey,
    required int installment,
    required int repaymentDay,
    required int insurerId,
    required String partner,
  });
  Future<String> createNew({
    required double amount,
    required String publicKey,
    required int installment,
    required int repaymentDay,
    required String termsVersion,
    required List<KlumpCheckoutItem> items,
    required Map<String, dynamic>? shippingData,
    required int insurerId,
  });
  Future<StanbicStatusResponseModel> getLoanStatus({
    required String id,
    required String publicKey,
  });
  Future<List<PartnerInsurerModel>> getPartnerInsurers({
    required String partner,
    required String publicKey,
    required double amount,
  });
  Future<List<PartnerModel>> getLoanPartners({
    required String publicKey,
  });
  Future<bool> acceptTerms({
    required String partner,
    required String publicKey,
  });
}

class RemoteDataSourceImpl implements RemoteDatasource {
  final KCHttpRequester kcHttpRequester;
  final KCInternetInfo kcInternetInfo;

  RemoteDataSourceImpl(
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
    String? firstName,
    required String publicKey,
    required String partner,
  }) async {
    if (await kcInternetInfo.isConnected) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final headers = {
        'klump-public-key': publicKey,
      };
      final body = <String, dynamic>{
        "accountNumber": accountNumber,
        "phoneNumber": phoneNumber,
        "partner": partner,
        'firstname': firstName,
        'is_live':
            prefs.getString(KC_ENVIRONMENT_KEY) == KC_PRODUCTION_ENVIRONMENT,
      };
      await kcHttpRequester.post(
        environment: prefs.getString(KC_ENVIRONMENT_KEY),
        headers: headers,
        endpoint: partner == 'stanbic'
            ? '/v1/stanbic/accounts/validation'
            : '/v1/loans/account/verification',
        body: body,
      );
    } else {
      throw NoInternetKCException();
    }
  }

  @override
  Future<KlumpUserModel> verifyOTP({
    required String accountNumber,
    required String phoneNumber,
    required String otp,
    required String publicKey,
    String? firstName,
    required String partner,
  }) async {
    if (await kcInternetInfo.isConnected) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final headers = {
        'klump-public-key': publicKey,
      };
      final body = {
        "accountNumber": accountNumber,
        "phoneNumber": phoneNumber,
        "otp": otp,
        "partner": partner,
        "email": "",
        "firstname": firstName,
        'is_live':
            prefs.getString(KC_ENVIRONMENT_KEY) == KC_PRODUCTION_ENVIRONMENT,
      };
      final response = await kcHttpRequester.post(
        environment: prefs.getString(KC_ENVIRONMENT_KEY),
        endpoint: partner == 'stanbic'
            ? '/v1/stanbic/accounts/verify'
            : '/v1/loans/account/verify-otp',
        headers: headers,
        body: body,
      );
      await prefs.setString(
          KC_STANBIC_TOKEN,
          (response.data as Map<String, dynamic>)['token'] ??
              (response.data as Map<String, dynamic>)['data']['token']);
      return KlumpUserModel.fromJson(
          partner == 'stanbic' ? response.data : response.data['data']);
    } else {
      throw NoInternetKCException();
    }
  }

  @override
  Future<TermsAndConditionModel> getBankTC({
    required String publicKey,
    required String partner,
  }) async {
    if (await kcInternetInfo.isConnected) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final headers = {
        'klump-public-key': publicKey,
      };
      final queryParams = {
        'partner': partner,
        'is_live':
            prefs.getString(KC_ENVIRONMENT_KEY) == KC_PRODUCTION_ENVIRONMENT,
      };
      final response = await kcHttpRequester.get(
        environment: prefs.getString(KC_ENVIRONMENT_KEY),
        headers: headers,
        endpoint: '/v1/loans/partners/terms-and-conditions',
        queryParam: queryParams,
        token: prefs.getString(KC_STANBIC_TOKEN),
      );
      return TermsAndConditionModel.fromJson(response.data['data']);
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
    required int insurerId,
    required String partner,
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
        "partner": partner,
      };
      if (partner == 'stanbic') {
        body.addAll({
          "insurerId": insurerId,
        });
      }
      final response = await kcHttpRequester.post(
        environment: prefs.getString(KC_ENVIRONMENT_KEY),
        endpoint: '/v1/loans/account/repayments-detail',
        body: body,
        token: prefs.getString(KC_STANBIC_TOKEN),
        headers: headers,
      );
      Logger().d(response.data);
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
    required Map<String, dynamic>? shippingData,
    required int insurerId,
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
        "termsAndConditionVersion": termsVersion,
        "items": items.map((e) => e.toMap()).toList(),
        "insurerId": insurerId,
      };
      if (shippingData != null) {
        body.addAll({
          'shipping_data': shippingData,
        });
      }
      final response = await kcHttpRequester.post(
        environment: prefs.getString(KC_ENVIRONMENT_KEY),
        endpoint: '/v1/stanbic/loans/new',
        headers: headers,
        body: body,
        token: prefs.getString(KC_STANBIC_TOKEN),
      );
      return response.data['id'];
    } else {
      throw NoInternetKCException();
    }
  }

  @override
  Future<StanbicStatusResponseModel> getLoanStatus({
    required String id,
    required String publicKey,
  }) async {
    if (await kcInternetInfo.isConnected) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final headers = {
        'klump-public-key': publicKey,
      };
      final response = await kcHttpRequester.get(
        environment: prefs.getString(KC_ENVIRONMENT_KEY),
        endpoint: '/v1/stanbic/loans/$id/status',
        headers: headers,
        token: prefs.getString(KC_STANBIC_TOKEN),
      );
      return StanbicStatusResponseModel.fromJson(response.data);
    } else {
      throw NoInternetKCException();
    }
  }

  @override
  Future<bool> accountCredentials({
    required String email,
    required String password,
    required String publicKey,
  }) async {
    if (await kcInternetInfo.isConnected) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final body = {
        "email": email,
        "password": password,
      };
      final headers = {
        'klump-public-key': publicKey,
      };
      final response = await kcHttpRequester.post(
        environment: prefs.getString(KC_ENVIRONMENT_KEY),
        headers: headers,
        endpoint: '/v1/loans/account/credentials',
        body: body,
        token: prefs.getString(KC_STANBIC_TOKEN),
      );
      return response.statusCode == 200;
    } else {
      throw NoInternetKCException();
    }
  }

  @override
  Future<List<PartnerInsurerModel>> getPartnerInsurers({
    required String partner,
    required String publicKey,
    required double amount,
  }) async {
    if (await kcInternetInfo.isConnected) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final headers = {
        'klump-public-key': publicKey,
      };
      final isLive =
          prefs.getString(KC_ENVIRONMENT_KEY) == KC_PRODUCTION_ENVIRONMENT;
      final response = await kcHttpRequester.get(
        environment: prefs.getString(KC_ENVIRONMENT_KEY),
        endpoint:
            '/v1/loans/partners/insurers?is_live=$isLive&partner=$partner&amount=$amount',
        headers: headers,
      );
      return PartnerInsurerListModel.fromJson(response.data).data;
    } else {
      throw NoInternetKCException();
    }
  }

  @override
  Future<List<PartnerModel>> getLoanPartners({
    required String publicKey,
  }) async {
    if (await kcInternetInfo.isConnected) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final headers = {
        'klump-public-key': publicKey,
      };
      final response = await kcHttpRequester.get(
        environment: prefs.getString(KC_ENVIRONMENT_KEY),
        endpoint: '/v1/loans/partners',
        headers: headers,
      );
      return PartnerListModel.fromJson(response.data).data;
    } else {
      throw NoInternetKCException();
    }
  }

  @override
  Future<bool> acceptTerms({
    required String partner,
    required String publicKey,
  }) async {
    if (await kcInternetInfo.isConnected) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final headers = {
        'klump-public-key': publicKey,
      };
      final body = {
        'partner': partner,
        'is_live':
            prefs.getString(KC_ENVIRONMENT_KEY) == KC_PRODUCTION_ENVIRONMENT,
      };
      final response = await kcHttpRequester.post(
        environment: prefs.getString(KC_ENVIRONMENT_KEY),
        endpoint: '/v1/loans/account/accept-loan-terms',
        headers: headers,
        body: body,
        token: prefs.getString(KC_STANBIC_TOKEN),
      );
      Logger().d(response.data);
      return response.statusCode == 200;
    } else {
      throw NoInternetKCException();
    }
  }
}
