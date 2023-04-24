import 'package:dio/dio.dart';
import 'package:klump_checkout/src/checkout.dart';
import 'package:logger/logger.dart';

class ExceptionHandler {
  static Failure networkError(dynamic e) {
    Logger().d(e);
    if (e is NoInternetException) {
      return NoInternetFailure();
    }
    if (e is DioError) {
      Logger().d(e.response?.data);
      if (e.type == DioErrorType.connectionTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        return TimeoutFailure();
      }
      if (e.response?.data != null) {
        return ServerFailure(
          message: (e.response!.data as Map<String, dynamic>?)?['message']
                  as String? ??
              (e.response!.data as Map<String, dynamic>?)?['error']
                  as String? ??
              'Service unavailable, please try again!',
          code: e.response?.statusCode ?? 500,
        );
      } else {
        return ServerFailure(
          message: 'Server error, please try again!',
          code: e.response?.statusCode ?? 500,
        );
      }
    } else {
      return UnknownFailure();
    }
  }
}
