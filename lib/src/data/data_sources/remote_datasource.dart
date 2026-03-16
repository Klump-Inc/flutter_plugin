import 'package:dio/dio.dart';
import 'package:klump_checkout/klump_checkout.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class RemoteDatasource {
  Future<InitiateResponseModel> initiate({
    required double amount,
    required double? shippingFee,
    required String currency,
    required String publicKey,
    required Map<String, dynamic> metaData,
    required String email,
    required String phone,
    required List<KlumpCheckoutItem> items,
    required Map<String, dynamic>? shippingData,
    required String? merchantReference,
    required Map<String, dynamic> sourceAnalytics,
  });
  Future<KCAPIResponseModel> validateAccount({
    required String? accountNumber,
    required String? phoneNumber,
    required String publicKey,
    required String partner,
    required String? firstName,
    required String? bank,
    required String? email,
    required bool isLive,
  });
  Future<KCAPIResponseModel> accountCredentials({
    required String email,
    required String password,
    required String publicKey,
    required String partner,
    DateTime? dob,
    required bool isLive,
  });
  Future<KCAPIResponseModel> verifyOTP({
    required String? accountNumber,
    required String? phoneNumber,
    required String? email,
    required String? otp,
    required String? password,
    required String publicKey,
    required String? firstName,
    required String partner,
    required String? bank,
    required String? username,
    required bool isLive,
  });
  Future<KCAPIResponseModel> getBankTC({
    required String publicKey,
    required String partner,
    required bool isLive,
  });
  Future<KCAPIResponseModel> getRepaymentDetails({
    required double amount,
    required String publicKey,
    required int installment,
    required int? repaymentDay,
    required int? insurerId,
    required String partner,
    required bool isLive,
  });

  Future<DisbursementStatusResponseModel> getLoanStatus({
    required String url,
    required String publicKey,
    required bool isLive,
  });
  Future<List<PartnerInsurerModel>> getPartnerInsurers({
    required String partner,
    required String publicKey,
    required double amount,
    required bool isLive,
  });
  Future<List<PartnerModel>> getLoanPartners({
    required String publicKey,
    required double amount,
  });
  Future<KCAPIResponseModel> partners({
    required String method,
    required String api,
    required String publicKey,
    required String partner,
    required Map<String, dynamic>? data,
  });

  Future<dynamic> feedback({
    required String phoneNumber,
    required String email,
    required String publicKey,
    required String feedback,
    required bool isLive,
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
  Future<InitiateResponseModel> initiate({
    required double amount,
    required double? shippingFee,
    required String currency,
    required String publicKey,
    required Map<String, dynamic> metaData,
    required String email,
    required String phone,
    required List<KlumpCheckoutItem> items,
    required Map<String, dynamic>? shippingData,
    required String? merchantReference,
    required Map<String, dynamic> sourceAnalytics,
  }) async {
    if (await kcInternetInfo.isConnected) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final headers = {
        'klump-public-key': publicKey,
      };
      final body = {
        "source": "mobile",
        "amount": amount,
        "currency": currency,
        "klump_public_key": publicKey,
        "meta_data": metaData,
        "email": email,
        "phone": phone,
        "items": items.map((e) => e.toMap()).toList(),
        "source_analytics": sourceAnalytics,
      };
      if (merchantReference != null) {
        body.addAll({
          'merchant_reference': merchantReference,
        });
      }
      if (shippingFee != null) {
        body['shipping_fee'] = shippingFee;
      }
      if (shippingData != null) {
        body.addAll({
          'shipping_data': shippingData,
        });
      }
      final response = await kcHttpRequester.post(
        endpoint: '/v1/transactions/initiate',
        body: body,
        headers: headers,
      );
      Logger().d(response.data);
      await prefs.setString(KC_CHECKOUT_TOKEN,
          (response.data as Map<String, dynamic>)['token'] as String);
      return InitiateResponseModel.fromJson(response.data);
    } else {
      throw NoInternetKCException();
    }
  }

  @override
  Future<KCAPIResponseModel> validateAccount({
    required String? accountNumber,
    required String? phoneNumber,
    required String publicKey,
    required String partner,
    required String? firstName,
    required String? bank,
    required String? email,
    required bool isLive,
  }) async {
    if (await kcInternetInfo.isConnected) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final headers = {
        'klump-public-key': publicKey,
      };
      final body = <String, dynamic>{
        'partner': partner,
        'klump_public_key': publicKey,
        'is_live': isLive,
      };
      if (accountNumber != null) {
        body.addAll({
          'accountNumber': accountNumber,
        });
      }
      if (phoneNumber != null) {
        body.addAll({
          'phoneNumber': phoneNumber,
        });
      }
      if (firstName != null) {
        body.addAll({
          'firstname': firstName,
        });
      }
      if (email != null) {
        body.addAll({
          'email': email,
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
          'environment': isLive ? 'production' : 'staging',
          'partner': partner,
          'payload': body,
        },
      );
      final response = await kcHttpRequester.post(
        headers: headers,
        endpoint: '/v1/loans/account/verification',
        body: body,
        token: prefs.getString(KC_CHECKOUT_TOKEN),
      );
      Logger().d(response.data);
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
    required String? accountNumber,
    required String? phoneNumber,
    required String? email,
    required String? otp,
    required String? password,
    required String publicKey,
    required String? firstName,
    required String partner,
    required String? bank,
    required String? username,
    required bool isLive,
  }) async {
    if (await kcInternetInfo.isConnected) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final headers = {
        'klump-public-key': publicKey,
      };
      final body = <String, dynamic>{
        "partner": partner,
        'klump_public_key': publicKey,
        'is_live': isLive,
      };
      if (accountNumber?.isNotEmpty == true) {
        body.addAll({
          'accountNumber': accountNumber,
        });
      }
      if (phoneNumber?.isNotEmpty == true) {
        body.addAll({
          'phoneNumber': phoneNumber,
        });
      }
      if (email?.isNotEmpty == true) {
        body.addAll({
          'email': email,
        });
      }
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
      if (username?.isNotEmpty == true) {
        body.addAll({
          "username": username,
        });
      }
      if (bank != null) {
        body.addAll({
          'bank': bank,
        });
      }
      final response = await kcHttpRequester.post(
        endpoint: '/v1/loans/account/verify-otp',
        headers: headers,
        body: body,
        token: prefs.getString(KC_CHECKOUT_TOKEN),
      );
      await prefs.setString(KC_CHECKOUT_TOKEN,
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
    required bool isLive,
  }) async {
    if (await kcInternetInfo.isConnected) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final headers = {
        'klump-public-key': publicKey,
      };
      final queryParams = {
        'partner': partner,
        'is_live': isLive,
      };
      final response = await kcHttpRequester.get(
        headers: headers,
        endpoint: '/v1/loans/partners/terms-and-conditions',
        queryParam: queryParams,
        token: prefs.getString(KC_CHECKOUT_TOKEN),
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
    required bool isLive,
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
        'is_live': isLive,
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
        endpoint: '/v1/loans/account/repayments-detail',
        body: body,
        token: prefs.getString(KC_CHECKOUT_TOKEN),
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
  Future<DisbursementStatusResponseModel> getLoanStatus({
    required String url,
    required String publicKey,
    required bool isLive,
  }) async {
    if (await kcInternetInfo.isConnected) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final headers = {
        'klump-public-key': publicKey,
      };
      final response = await kcHttpRequester.get(
        endpoint: '/v1$url',
        headers: headers,
        token: prefs.getString(KC_CHECKOUT_TOKEN),
      );
      return DisbursementStatusResponseModel.fromJson(response.data);
    } else {
      throw NoInternetKCException();
    }
  }

  @override
  Future<KCAPIResponseModel> accountCredentials({
    required String email,
    required String password,
    required String publicKey,
    required String partner,
    required bool isLive,
    DateTime? dob,
  }) async {
    if (await kcInternetInfo.isConnected) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final body = {
        "email": email,
        "password": password,
        "partner": partner,
        'is_live': isLive,
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
        headers: headers,
        endpoint: '/v1/loans/account/credentials',
        body: body,
        token: prefs.getString(KC_CHECKOUT_TOKEN),
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
    required bool isLive,
  }) async {
    if (await kcInternetInfo.isConnected) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final headers = {
        'klump-public-key': publicKey,
      };
      final response = await kcHttpRequester.get(
        endpoint:
            '/v1/loans/partners/insurers?is_live=$isLive&partner=$partner&amount=$amount',
        headers: headers,
        token: prefs.getString(KC_CHECKOUT_TOKEN),
      );
      return PartnerInsurerListModel.fromJson(response.data).data;
    } else {
      throw NoInternetKCException();
    }
  }

  @override
  Future<List<PartnerModel>> getLoanPartners({
    required String publicKey,
    required double amount,
  }) async {
    if (await kcInternetInfo.isConnected) {
      final headers = {
        'klump-public-key': publicKey,
      };
      final response = await kcHttpRequester.get(
        endpoint: '/v1/loans/partners?amount=$amount',
        headers: headers,
      );
      return PartnerListModel.fromJson(response.data).data;
    } else {
      throw NoInternetKCException();
    }
  }

  @override
  Future<KCAPIResponseModel> partners({
    required String method,
    required String api,
    required String publicKey,
    required String partner,
    required Map<String, dynamic>? data,
  }) async {
    if (await kcInternetInfo.isConnected) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final headers = {
        'klump-public-key': publicKey,
      };
      late Response<dynamic> response;
      if (method == 'POST') {
        response = await kcHttpRequester.post(
          endpoint: '/v1$api',
          headers: headers,
          token: prefs.getString(KC_CHECKOUT_TOKEN),
          body: data,
        );
      } else {
        response = await kcHttpRequester.get(
          endpoint: '/v1$api',
          headers: headers,
          token: prefs.getString(KC_CHECKOUT_TOKEN),
        );
      }
      final rData = (response.data as Map<String, dynamic>)['data'];
      if (rData.runtimeType != int) {
        final token = (rData as Map<String, dynamic>?)?['token'];
        if (token != null) {
          await prefs.setString(KC_CHECKOUT_TOKEN,
              (response.data as Map<String, dynamic>)['data']['token']);
        }
      }
      Logger().d(response.data);
      return KCAPIResponseModel(
        nextStep: NextStepModel.fromJson(response.data['next_step']),
        data: api == '/loans/account/verify-otp'
            ? KlumpUserModel.fromJson(response.data['data'])
            : api == '/loans/account/repayments-detail'
                ? RepaymentDetailsModel.fromJson(response.data['data'])
                : response.data['data'],
        message: response.data['message'],
      );
    } else {
      throw NoInternetKCException();
    }
  }

  @override
  Future<dynamic> feedback({
    required String phoneNumber,
    required String email,
    required String publicKey,
    required String feedback,
    required bool isLive,
  }) async {
    if (await kcInternetInfo.isConnected) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final headers = {
        'klump-public-key': publicKey,
      };
      final body = {
        'email': email,
        'phone': phoneNumber,
        'feedback': feedback,
        'is_live': isLive,
      };
      final response = await kcHttpRequester.post(
        endpoint: '/v1/loans/feedback',
        headers: headers,
        body: body,
        token: prefs.getString(KC_CHECKOUT_TOKEN),
      );
      return (response.data as Map<String, dynamic>)['message'];
    } else {
      throw NoInternetKCException();
    }
  }
}
