import 'package:dio/dio.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:logger/logger.dart';

class KCHttpRequester {
  KCHttpRequester() {
    dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: KC_CONNECT_TIMEOUT),
        receiveTimeout: const Duration(seconds: KC_RECEIVE_TIMEOUT),
        contentType: KC_CONTENT_TYPE_DEFAULT,
      ),
    );
  }
  late Dio dio;

  Future<Response<dynamic>> post({
    required String? environment,
    required String endpoint,
    required dynamic body,
    String? token,
    Map<String, dynamic>? queryParam,
    String? contentType,
    Map<String, dynamic>? headers,
  }) async {
    final isLive = environment == KC_PRODUCTION_ENVIRONMENT;
    dio.options.headers['Authorization'] = 'Bearer $token';
    dio.options.headers[KC_CLIENT_ID] =
        isLive ? KC_CLIENT_ID_VALUE_PROD : KC_CLIENT_ID_VALUE_STAGING;
    dio.options.headers[KC_CLIENT_KEY] =
        isLive ? KC_CLIENT_KEY_VALUE_PROD : KC_CLIENT_KEY_VALUE_STAGING;
    dio.options.headers[KC_CLIENT_SECRET] =
        isLive ? KC_CLIENT_SECRET_VALUE_PROD : KC_CLIENT_SECRET_VALUE_STAGING;
    final response = await dio.post<dynamic>(
      isLive ? KC_BASE_URL + endpoint : KC_STAGING_BASE_URL + endpoint,
      data: body,
      queryParameters: queryParam,
      options: Options(
        contentType: contentType,
        headers: headers,
      ),
    );
    Logger().d(response.data);
    return response;
  }

  Future<Response<dynamic>> get({
    required String? environment,
    required String endpoint,
    String? token,
    Map<String, dynamic>? queryParam,
    String? contentType,
    Map<String, dynamic>? headers,
  }) async {
    final isLive = environment == KC_PRODUCTION_ENVIRONMENT;
    dio.options.headers['Authorization'] = 'Bearer $token';
    dio.options.headers[KC_CLIENT_ID] =
        isLive ? KC_CLIENT_ID_VALUE_PROD : KC_CLIENT_ID_VALUE_STAGING;
    dio.options.headers[KC_CLIENT_KEY] =
        isLive ? KC_CLIENT_KEY_VALUE_PROD : KC_CLIENT_KEY_VALUE_STAGING;
    dio.options.headers[KC_CLIENT_SECRET] =
        isLive ? KC_CLIENT_SECRET_VALUE_PROD : KC_CLIENT_SECRET_VALUE_STAGING;
    final response = await dio.get<dynamic>(
      isLive ? KC_BASE_URL + endpoint : KC_STAGING_BASE_URL + endpoint,
      queryParameters: queryParam,
      options: Options(
        contentType: contentType,
        headers: headers,
      ),
    );
    Logger().d(response.data);
    return response;
  }

  Future<Response<dynamic>> patch({
    required String? environment,
    required String endpoint,
    required dynamic body,
    String? token,
    Map<String, dynamic>? queryParam,
    String? contentType,
    Map<String, dynamic>? headers,
  }) async {
    final isLive = environment == KC_PRODUCTION_ENVIRONMENT;
    dio.options.headers['Authorization'] = 'Bearer $token';
    dio.options.headers[KC_CLIENT_ID] =
        isLive ? KC_CLIENT_ID_VALUE_PROD : KC_CLIENT_ID_VALUE_STAGING;
    dio.options.headers[KC_CLIENT_KEY] =
        isLive ? KC_CLIENT_KEY_VALUE_PROD : KC_CLIENT_KEY_VALUE_STAGING;
    dio.options.headers[KC_CLIENT_SECRET] =
        isLive ? KC_CLIENT_SECRET_VALUE_PROD : KC_CLIENT_SECRET_VALUE_STAGING;
    final response = await dio.patch<dynamic>(
      isLive ? KC_BASE_URL + endpoint : KC_STAGING_BASE_URL + endpoint,
      data: body,
      queryParameters: queryParam,
      options: Options(
        contentType: contentType,
        headers: headers,
      ),
    );
    return response;
  }
}
