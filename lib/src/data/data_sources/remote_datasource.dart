import 'package:klump_checkout/klump_checkout.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class RemoteDatasource {
  Future<void> initiate({
    required double amount,
    required String currency,
    required String publicKey,
    required Map<String, dynamic> metaData,
    required bool isLive,
  });
  Future<KCAPIResponseModel> validateAccount({
    required String accountNumber,
    required String phoneNumber,
    String? firstName,
    required String publicKey,
    required String partner,
    required String? bank,
  });
  Future<KCAPIResponseModel> accountCredentials({
    required String email,
    required String password,
    required String publicKey,
    required String partner,
    DateTime? dob,
  });
  Future<KCAPIResponseModel> verifyOTP({
    required String accountNumber,
    required String phoneNumber,
    required String? otp,
    required String? password,
    required String publicKey,
    String? firstName,
    required String partner,
    required String? bank,
  });
  Future<KCAPIResponseModel> getBankTC({
    required String publicKey,
    required String partner,
  });
  Future<KCAPIResponseModel> getRepaymentDetails({
    required double amount,
    required String publicKey,
    required int installment,
    required int? repaymentDay,
    required int? insurerId,
    required String partner,
  });
  Future<KCAPIResponseModel> createNew({
    required double amount,
    required String publicKey,
    required int? installment,
    required int? repaymentDay,
    required String? termsVersion,
    required List<KlumpCheckoutItem> items,
    required Map<String, dynamic>? shippingData,
    required int? insurerId,
    required String partner,
  });
  Future<DisbursementStatusResponseModel> getLoanStatus({
    required String url,
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
  Future<KCAPIResponseModel> acceptTerms({
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
  Future<KCAPIResponseModel> validateAccount({
    required String accountNumber,
    required String phoneNumber,
    String? firstName,
    required String publicKey,
    required String partner,
    required String? bank,
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
        'is_live':
            prefs.getString(KC_ENVIRONMENT_KEY) == KC_PRODUCTION_ENVIRONMENT,
      };
      if (partner == 'polaris') {
        body.addAll({
          'firstname': firstName,
        });
      }
      if (bank != null) {
        body.addAll({
          'bank': bank,
        });
      }
      MixPanelService.logEvent(
        '6 - ACCOUNT VERIFICATION MODAL',
        properties: {
          'environment':
              prefs.getString(KC_ENVIRONMENT_KEY) == KC_PRODUCTION_ENVIRONMENT
                  ? 'production'
                  : 'staging',
          'partner': partner,
          'payload': body,
        },
      );
      final response = await kcHttpRequester.post(
        environment: prefs.getString(KC_ENVIRONMENT_KEY),
        headers: headers,
        endpoint: '/v1/loans/account/verification',
        body: body,
      );
      return KCAPIResponseModel(
        nextStep: NextStepModel.fromJson(response.data['next_step']),
        data: response.data['message'],
      );
    } else {
      throw NoInternetKCException();
    }
  }

  @override
  Future<KCAPIResponseModel> verifyOTP({
    required String accountNumber,
    required String phoneNumber,
    required String? otp,
    required String? password,
    required String publicKey,
    String? firstName,
    required String partner,
    required String? bank,
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
        "email": "",
        'is_live':
            prefs.getString(KC_ENVIRONMENT_KEY) == KC_PRODUCTION_ENVIRONMENT,
      };
      if (partner == 'polaris') {
        body.addAll({
          'firstname': firstName,
        });
      }
      if (otp?.isNotEmpty == true) {
        body.addAll({
          "otp": otp,
        });
      }
      if (password?.isNotEmpty == true) {
        body.addAll({
          "password": password,
        });
      }
      if (bank != null) {
        body.addAll({
          'bank': bank,
        });
      }
      final response = await kcHttpRequester.post(
        environment: prefs.getString(KC_ENVIRONMENT_KEY),
        endpoint: '/v1/loans/account/verify-otp',
        headers: headers,
        body: body,
      );
      await prefs.setString(KC_LOGIN_TOKEN,
          (response.data as Map<String, dynamic>)['data']['token']);
      return KCAPIResponseModel(
        nextStep: NextStepModel.fromJson(response.data['next_step']),
        data: KlumpUserModel.fromJson(response.data['data']),
      );
    } else {
      throw NoInternetKCException();
    }
  }

  @override
  Future<KCAPIResponseModel> getBankTC({
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
        token: prefs.getString(KC_LOGIN_TOKEN),
      );
      return KCAPIResponseModel(
        nextStep: NextStepModel.fromJson(response.data['next_step']),
        data: TermsAndConditionModel.fromJson(response.data['data']),
      );
    } else {
      throw NoInternetKCException();
    }
  }

  @override
  Future<KCAPIResponseModel> getRepaymentDetails({
    required double amount,
    required String publicKey,
    required int installment,
    required int? repaymentDay,
    required int? insurerId,
    required String partner,
  }) async {
    if (await kcInternetInfo.isConnected) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final headers = {
        'klump-public-key': publicKey,
      };
      final body = <String, dynamic>{
        "amount": amount,
        "installment": installment,
        "klump_public_key": publicKey,
        "partner": partner,
      };
      if (partner == 'stanbic') {
        body.addAll({
          "insurerId": insurerId,
        });
      }
      if (repaymentDay != null) {
        body.addAll({
          "repaymentDay": repaymentDay,
        });
      }
      final response = await kcHttpRequester.post(
        environment: prefs.getString(KC_ENVIRONMENT_KEY),
        endpoint: '/v1/loans/account/repayments-detail',
        body: body,
        token: prefs.getString(KC_LOGIN_TOKEN),
        headers: headers,
      );
      return KCAPIResponseModel(
        nextStep: NextStepModel.fromJson(response.data['next_step']),
        data: RepaymentDetailsModel.fromJson(response.data['data']),
      );
    } else {
      throw NoInternetKCException();
    }
  }

  @override
  Future<KCAPIResponseModel> createNew({
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
    if (await kcInternetInfo.isConnected) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final headers = {
        'klump-public-key': publicKey,
      };
      final body = {
        "amount": amount,
        "klump_public_key": publicKey,
        "items": items.map((e) => e.toMap()).toList(),
        "partner": partner,
      };
      if (shippingData != null) {
        body.addAll({
          'shipping_data': shippingData,
        });
      }
      if (insurerId != null) {
        body.addAll({
          "insurerId": insurerId,
        });
      }

      if (termsVersion != null) {
        body.addAll({
          "termsAndConditionVersion": termsVersion,
        });
      }
      if (installment != null) {
        body.addAll({
          "installment": installment,
        });
      }
      if (repaymentDay != null) {
        body.addAll({
          "repaymentDay": repaymentDay,
        });
      }

      final response = await kcHttpRequester.post(
        environment: prefs.getString(KC_ENVIRONMENT_KEY),
        endpoint: '/v1/loans/account/new-loan',
        headers: headers,
        body: body,
        token: prefs.getString(KC_LOGIN_TOKEN),
      );
      return KCAPIResponseModel(
        nextStep: NextStepModel.fromJson(response.data['next_step']),
        data: response.data['data']['id'],
      );
    } else {
      throw NoInternetKCException();
    }
  }

  @override
  Future<DisbursementStatusResponseModel> getLoanStatus({
    required String url,
    required String publicKey,
  }) async {
    if (await kcInternetInfo.isConnected) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final headers = {
        'klump-public-key': publicKey,
      };
      final response = await kcHttpRequester.get(
        environment: prefs.getString(KC_ENVIRONMENT_KEY),
        endpoint: '/v1$url',
        headers: headers,
        token: prefs.getString(KC_LOGIN_TOKEN),
      );
      return DisbursementStatusResponseModel.fromJson(response.data);
    } else {
      throw NoInternetKCException();
    }
  }

  @override
  Future<KCAPIResponseModel> accountCredentials(
      {required String email,
      required String password,
      required String publicKey,
      required String partner,
      DateTime? dob}) async {
    if (await kcInternetInfo.isConnected) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final body = {
        "email": email,
        "password": password,
        "partner": partner,
      };
      if (partner == 'polaris' && dob != null) {
        body.addAll({
          "date_of_birth": KCStringUtil.formatServerDate(dob),
        });
      }
      final headers = {
        'klump-public-key': publicKey,
      };
      final response = await kcHttpRequester.post(
        environment: prefs.getString(KC_ENVIRONMENT_KEY),
        headers: headers,
        endpoint: '/v1/loans/account/credentials',
        body: body,
        token: prefs.getString(KC_LOGIN_TOKEN),
      );
      return KCAPIResponseModel(
        nextStep: NextStepModel.fromJson(response.data['next_step']),
      );
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
  Future<KCAPIResponseModel> acceptTerms({
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
        token: prefs.getString(KC_LOGIN_TOKEN),
      );
      return KCAPIResponseModel(
        nextStep: NextStepModel.fromJson(response.data['next_step']),
      );
    } else {
      throw NoInternetKCException();
    }
  }
}
