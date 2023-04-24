import 'package:equatable/equatable.dart';

abstract class KCException extends Equatable implements Exception {
  const KCException();
  @override
  List<Object> get props => [];
}

class NoInternetKCException extends KCException {
  @override
  List<Object> get props => [];
}

class ServerKCException extends KCException {
  const ServerKCException({
    required this.message,
    required this.code,
  });

  final String message;
  final int code;
  @override
  List<Object> get props => [message, code];
}

class CacheKCException extends KCException {
  @override
  List<Object> get props => [];
}

class NoDataKCException extends KCException {
  @override
  List<Object> get props => [];
}

class NullKCException extends KCException {
  @override
  List<Object> get props => [];
}

class UnknownKCException extends KCException {
  @override
  List<Object> get props => [];
}

class TimeoutKCException extends KCException {
  @override
  List<Object> get props => [];
}

class KCExceptionsToMessage {
  static String mapErrorToMessage(KCException failure) {
    String message;
    if (failure is NoInternetKCException) {
      message = 'Please check your internet connection and try again!';
    } else if (failure is ServerKCException) {
      message = failure.message;
    } else if (failure is CacheKCException || failure is NoDataKCException) {
      message = 'Data not found, please login again!';
    } else if (failure is TimeoutKCException) {
      message = 'Connection timout, please try again!';
    } else {
      message = 'An Error occurred, please try again!';
    }
    return message;
  }
}
