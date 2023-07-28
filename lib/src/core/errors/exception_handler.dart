import 'package:dio/dio.dart';
import 'package:klump_checkout/klump_checkout.dart';
import 'package:logger/logger.dart';

class KCExceptionHandler {
  static KCException networkError(dynamic e) {
    Logger().d(e);
    if (e is NoInternetKCException) {
      return NoInternetKCException();
    }
    if (e is DioError) {
      Logger().d(e.response?.data);
      if (e.type == DioErrorType.connectionTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        return TimeoutKCException();
      }
      if (e.response?.data != null) {
        return ServerKCException(
          message: (e.response!.data as Map<String, dynamic>?)?['message']
                  as String? ??
              (e.response!.data as Map<String, dynamic>?)?['error']
                  as String? ??
              'Service unavailable, please try again!',
          code: e.response?.statusCode ?? 500,
        );
      } else {
        return ServerKCException(
          message: 'Server error, please try again!',
          code: e.response?.statusCode ?? 500,
        );
      }
    } else {
      return UnknownKCException();
    }
  }
}
