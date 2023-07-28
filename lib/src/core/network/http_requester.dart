import 'package:dio/dio.dart';
import 'package:klump_checkout/src/src.dart';

class KCHttpRequester {
  KCHttpRequester() {
    dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: KC_CONNECT_TIMEOUT),
        receiveTimeout: const Duration(seconds: KC_RECEIVE_TIMEOUT),
        headers: {
          KC_CLIENT_ID: KC_CLIENT_ID_VALUE,
          KC_CLIENT_KEY: KC_CLIENT_KEY_VALUE,
          KC_CLIENT_SECRET: KC_CLIENT_SECRET_VALUE,
        },
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
    dio.options.headers['Authorization'] = 'Bearer $token';
    final response = await dio.post<dynamic>(
      environment == KC_PRODUCTION_ENVIRONMENT
          ? KC_BASE_URL + endpoint
          : KC_STAGING_BASE_URL + endpoint,
      data: body,
      queryParameters: queryParam,
      options: Options(
        contentType: contentType,
        headers: headers,
      ),
    );
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
    dio.options.headers['Authorization'] = 'Bearer $token';
    final response = dio.get<dynamic>(
      environment == KC_PRODUCTION_ENVIRONMENT
          ? KC_BASE_URL + endpoint
          : KC_STAGING_BASE_URL + endpoint,
      queryParameters: queryParam,
      options: Options(
        contentType: contentType,
        headers: headers,
      ),
    );
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
    dio.options.headers['Authorization'] = 'Bearer $token';
    final response = await dio.patch<dynamic>(
      environment == KC_PRODUCTION_ENVIRONMENT
          ? KC_BASE_URL + endpoint
          : KC_STAGING_BASE_URL + endpoint,
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
